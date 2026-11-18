// Run the two GEMM code objects (aligned.s, shifted.s in this directory) on the same
// inputs, interleaved, with L2 flushed before every launch. Reports the median
// kernel time and checks that both kernels write identical outputs.
//
// The kernel is aiter's Triton _gemm_a8w8_blockscale_kernel specialized for
// M=N=4096, K=4160: y[M,N] (bf16) = (x[M,K] fp8 * x_scale) @ (w[N,K] fp8 * w_scale)^T
// with 128x128 scale blocks.
//
// Usage: gemm_launcher <aligned.hsaco> <shifted.hsaco> [--iters N] [--device D]

#include <hip/hip_runtime.h>

#include <algorithm>
#include <cmath>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <string>
#include <vector>

#define CHECK(x)                                                                         \
  do {                                                                                   \
    hipError_t e_ = (x);                                                                 \
    if (e_ != hipSuccess) {                                                              \
      std::fprintf(stderr, "%s:%d: %s: %s\n", __FILE__, __LINE__, #x, hipGetErrorString(e_)); \
      std::exit(1);                                                                      \
    }                                                                                    \
  } while (0)

namespace {

constexpr int M = 4096, N = 4096, K = 4160;
constexpr int kScaleBlock = 128;
constexpr int kScaleK = (K + kScaleBlock - 1) / kScaleBlock;  // 33
constexpr int kScaleN = (N + kScaleBlock - 1) / kScaleBlock;  // 32
constexpr int kBlockM = 128, kBlockN = 256, kThreads = 256;  // tile config compiled into the kernel
constexpr int kLdsBytes = 102400;                            // Triton "shared" metadata
constexpr size_t kFlushBytes = size_t(512) << 20;             // larger than L2 + MALL

const char* kKernel =
    "_gemm_a8w8_blockscale_kernel_GROUP_K_128_GROUP_N_128_BLOCK_SIZE_M_128_BLOCK_SIZE_N_256_"
    "BLOCK_SIZE_K_128_GROUP_SIZE_M_1_NUM_KSPLIT_1_SPLITK_BLOCK_SIZE_4160_EVEN_K_0_EVEN_SPLITK_1_"
    "cache_modifier_NONE";

// Kernel arguments in the order of the code object's metadata. Triton drops the
// strides it specialized to 1 (stride_ak, stride_bk, stride_cn, stride_ascale_k,
// stride_bscale_k) and appends two scratch pointers.
struct KernelArgs {
  const void* a;        // x, [M, K] fp8 e4m3, row-major
  const void* b;        // w, [N, K] fp8 e4m3, row-major (read as w^T)
  void* c;              // y, [M, N] bf16
  const float* a_scale; // x_scale, [M, kScaleK]
  const float* b_scale; // w_scale, [kScaleN, kScaleK] (read as w_scale^T)
  int32_t m, n, k;
  int32_t stride_am;        // K
  int32_t stride_bn;        // K
  int32_t stride_ck;        // 0: no split-K
  int32_t stride_cm;        // N
  int32_t stride_ascale_m;  // kScaleK
  int32_t stride_bscale_n;  // kScaleK
  int32_t pad;
  void* global_scratch;
  void* profile_scratch;
};
static_assert(sizeof(KernelArgs) == 96, "kernarg size must match .kernarg_segment_size");

double median(std::vector<double> v) {
  std::sort(v.begin(), v.end());
  size_t n = v.size();
  return n % 2 ? v[n / 2] : 0.5 * (v[n / 2 - 1] + v[n / 2]);
}

// fp8 e4m3fn (finite values only) and bf16 to float.
float fp8_e4m3(uint8_t b) {
  int e = (b >> 3) & 0xF, m = b & 7;
  float v = e ? std::ldexp(1.0f + m / 8.0f, e - 7) : std::ldexp(m / 8.0f, -6);
  return (b & 0x80) ? -v : v;
}

float bf16(uint16_t h) {
  uint32_t u = uint32_t(h) << 16;
  float f;
  std::memcpy(&f, &u, 4);
  return f;
}

uint32_t lcg(uint64_t& s) {
  s = s * 6364136223846793005ULL + 1442695040888963407ULL;
  return static_cast<uint32_t>(s >> 33);
}

}  // namespace

int main(int argc, char** argv) {
  std::string paths[2];
  int iters = 100, device = 0, pos = 0;
  for (int i = 1; i < argc; ++i) {
    std::string s = argv[i];
    if (s == "--iters" && i + 1 < argc) iters = std::atoi(argv[++i]);
    else if (s == "--device" && i + 1 < argc) device = std::atoi(argv[++i]);
    else if (pos < 2) paths[pos++] = s;
    else { std::fprintf(stderr, "unexpected argument %s\n", s.c_str()); return 2; }
  }
  if (pos != 2) {
    std::fprintf(stderr, "usage: %s <aligned.hsaco> <shifted.hsaco> [--iters N] [--device D]\n", argv[0]);
    return 2;
  }
  CHECK(hipSetDevice(device));
  hipDeviceProp_t prop;
  CHECK(hipGetDeviceProperties(&prop, device));

  // Inputs: fp8 bytes 0x00..0x37 are finite values in [0, 0.875]; scales in [0, 1).
  uint64_t seed = 0;
  std::vector<uint8_t> hx(size_t(M) * K), hw(size_t(N) * K);
  for (auto& v : hx) v = lcg(seed) % 0x38;
  for (auto& v : hw) v = lcg(seed) % 0x38;
  std::vector<float> hxs(size_t(M) * kScaleK), hws(size_t(kScaleN) * kScaleK);
  for (auto& v : hxs) v = (lcg(seed) % 1000) / 1000.0f;
  for (auto& v : hws) v = (lcg(seed) % 1000) / 1000.0f;

  void *dx, *dw, *dy[2], *dflush;
  float *dxs, *dws;
  CHECK(hipMalloc(&dx, hx.size()));
  CHECK(hipMalloc(&dw, hw.size()));
  CHECK(hipMalloc(&dxs, hxs.size() * sizeof(float)));
  CHECK(hipMalloc(&dws, hws.size() * sizeof(float)));
  for (auto& p : dy) CHECK(hipMalloc(&p, size_t(M) * N * 2));
  CHECK(hipMalloc(&dflush, kFlushBytes));
  CHECK(hipMemcpy(dx, hx.data(), hx.size(), hipMemcpyHostToDevice));
  CHECK(hipMemcpy(dw, hw.data(), hw.size(), hipMemcpyHostToDevice));
  CHECK(hipMemcpy(dxs, hxs.data(), hxs.size() * sizeof(float), hipMemcpyHostToDevice));
  CHECK(hipMemcpy(dws, hws.data(), hws.size() * sizeof(float), hipMemcpyHostToDevice));

  const char* names[2] = {"aligned", "shifted"};
  hipModule_t mod[2];
  hipFunction_t fn[2];
  KernelArgs args[2];
  for (int k = 0; k < 2; ++k) {
    CHECK(hipModuleLoad(&mod[k], paths[k].c_str()));
    CHECK(hipModuleGetFunction(&fn[k], mod[k], kKernel));
    args[k] = {dx, dw, dy[k], dxs, dws, M, N, K, K, K, 0, N, kScaleK, kScaleK, 0, nullptr, nullptr};
    CHECK(hipMemset(dy[k], 0, size_t(M) * N * 2));
  }
  const int grid = (M / kBlockM) * (N / kBlockN);

  hipEvent_t start, stop;
  CHECK(hipEventCreate(&start));
  CHECK(hipEventCreate(&stop));
  auto launch = [&](int k) -> double {
    CHECK(hipMemsetAsync(dflush, 0, kFlushBytes));
    size_t size = sizeof(KernelArgs);
    void* config[] = {HIP_LAUNCH_PARAM_BUFFER_POINTER, &args[k], HIP_LAUNCH_PARAM_BUFFER_SIZE, &size,
                      HIP_LAUNCH_PARAM_END};
    CHECK(hipEventRecord(start));
    CHECK(hipModuleLaunchKernel(fn[k], grid, 1, 1, kThreads, 1, 1, kLdsBytes, nullptr, nullptr, config));
    CHECK(hipEventRecord(stop));
    CHECK(hipEventSynchronize(stop));
    float ms = 0;
    CHECK(hipEventElapsedTime(&ms, start, stop));
    return ms * 1e3;
  };

  for (int i = 0; i < 10; ++i) launch(i % 2);  // warm-up
  std::vector<double> us[2];
  for (int i = 0; i < iters; ++i) {
    for (int j = 0; j < 2; ++j) {
      int k = (i + j) % 2;  // alternate which kernel runs first
      us[k].push_back(launch(k));
    }
  }

  std::vector<uint16_t> out[2];
  for (int k = 0; k < 2; ++k) {
    out[k].resize(size_t(M) * N);
    CHECK(hipMemcpy(out[k].data(), dy[k], out[k].size() * 2, hipMemcpyDeviceToHost));
  }
  bool same = std::memcmp(out[0].data(), out[1].data(), out[0].size() * 2) == 0;

  // Spot-check the aligned kernel against a CPU reference on 64 random outputs.
  double max_rel = 0;
  for (int t = 0; t < 64; ++t) {
    int m = lcg(seed) % M, n = lcg(seed) % N;
    double ref = 0;
    for (int kb = 0; kb < kScaleK; ++kb) {
      double block = 0;
      for (int k = kb * kScaleBlock; k < std::min(K, (kb + 1) * kScaleBlock); ++k)
        block += double(fp8_e4m3(hx[size_t(m) * K + k])) * fp8_e4m3(hw[size_t(n) * K + k]);
      ref += block * hxs[size_t(m) * kScaleK + kb] * hws[size_t(n / kScaleBlock) * kScaleK + kb];
    }
    max_rel = std::max(max_rel, std::abs(bf16(out[0][size_t(m) * N + n]) - ref) / std::abs(ref));
  }
  bool correct = max_rel < 1e-2;

  std::printf("device %d: %s (%s), %d CUs\n", device, prop.name, prop.gcnArchName, prop.multiProcessorCount);
  std::printf("gemm_a8w8_blockscale M=%d N=%d K=%d, grid %d x %d threads, %d launches each, L2 flushed\n\n",
              M, N, K, grid, kThreads, iters);
  std::printf("%-8s %12s %10s\n", "kernel", "median us", "TFLOPS");
  double base = median(us[0]);
  for (int k = 0; k < 2; ++k) {
    double t = median(us[k]);
    std::printf("%-8s %12.2f %10.1f", names[k], t, 2.0 * M * N * K / t * 1e-6);
    if (k) std::printf("   (%+.1f%% time vs aligned)", 100 * (t / base - 1));
    std::printf("\n");
  }
  std::printf("\noutputs identical: %s\n", same ? "yes" : "NO");
  std::printf("max relative error vs CPU reference (64 points): %.2e %s\n", max_rel, correct ? "(ok)" : "(FAIL)");

  for (auto p : {dx, dw, dy[0], dy[1], dflush}) CHECK(hipFree(p));
  CHECK(hipFree(dxs));
  CHECK(hipFree(dws));
  for (int k = 0; k < 2; ++k) CHECK(hipModuleUnload(mod[k]));
  return same && correct ? 0 : 1;
}
