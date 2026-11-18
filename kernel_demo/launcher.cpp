// Load two code objects that contain `valu_loop`, run them interleaved, and
// compare per-wave loop cycles (s_memtime) and wall time (hipEvent).
//
// Usage: launcher <aligned.hsaco> <shifted.hsaco> [--iters N] [--blocks B]
//                 [--threads T] [--lds BYTES] [--reps R] [--device D]

#include <hip/hip_runtime.h>

#include <algorithm>
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

constexpr int kLoopInsts = 64;  // 8-byte VALU instructions per iteration in aligned.s / shifted.s

struct Args {
  std::string paths[2];
  uint32_t iters = 20000;
  int blocks = 0;        // 0: one per CU
  int threads = 256;     // 256 = 1 wave per SIMD
  int lds = 96 * 1024;   // dynamic LDS per group; 96 KB keeps one group per CU
  int reps = 5;
  int device = 0;
};

Args parse(int argc, char** argv) {
  Args a;
  int pos = 0;
  for (int i = 1; i < argc; ++i) {
    std::string s = argv[i];
    auto next = [&] { if (i + 1 >= argc) { std::fprintf(stderr, "missing value for %s\n", s.c_str()); std::exit(2); } return std::atoi(argv[++i]); };
    if (s == "--iters") a.iters = next();
    else if (s == "--blocks") a.blocks = next();
    else if (s == "--threads") a.threads = next();
    else if (s == "--lds") a.lds = next();
    else if (s == "--reps") a.reps = next();
    else if (s == "--device") a.device = next();
    else if (pos < 2) a.paths[pos++] = s;
    else { std::fprintf(stderr, "unexpected argument %s\n", s.c_str()); std::exit(2); }
  }
  if (pos != 2) {
    std::fprintf(stderr, "usage: %s <aligned.hsaco> <shifted.hsaco> [--iters N] [--blocks B] "
                         "[--threads T] [--lds BYTES] [--reps R] [--device D]\n", argv[0]);
    std::exit(2);
  }
  return a;
}

double median(std::vector<double> v) {
  std::sort(v.begin(), v.end());
  size_t n = v.size();
  return n % 2 ? v[n / 2] : 0.5 * (v[n / 2 - 1] + v[n / 2]);
}

struct Sample {
  double wall_ms;
  double cycles_per_iter;  // median over waves
};

Sample run(hipFunction_t fn, const Args& a, int blocks, uint64_t* d_out, std::vector<uint64_t>& h_out,
           hipEvent_t start, hipEvent_t stop) {
  struct {
    uint64_t* out;
    uint32_t iters;
    uint32_t waves_per_group;
  } kargs{d_out, a.iters, static_cast<uint32_t>(a.threads / 64)};
  size_t size = sizeof(kargs);
  void* config[] = {HIP_LAUNCH_PARAM_BUFFER_POINTER, &kargs, HIP_LAUNCH_PARAM_BUFFER_SIZE, &size,
                    HIP_LAUNCH_PARAM_END};
  CHECK(hipMemset(d_out, 0, h_out.size() * sizeof(uint64_t)));
  CHECK(hipEventRecord(start));
  CHECK(hipModuleLaunchKernel(fn, blocks, 1, 1, a.threads, 1, 1, a.lds, nullptr, nullptr, config));
  CHECK(hipEventRecord(stop));
  CHECK(hipEventSynchronize(stop));
  float ms = 0;
  CHECK(hipEventElapsedTime(&ms, start, stop));
  CHECK(hipMemcpy(h_out.data(), d_out, h_out.size() * sizeof(uint64_t), hipMemcpyDeviceToHost));
  std::vector<double> cyc(h_out.begin(), h_out.end());
  return {ms, median(cyc) / a.iters};
}

}  // namespace

int main(int argc, char** argv) {
  Args a = parse(argc, argv);
  CHECK(hipSetDevice(a.device));
  hipDeviceProp_t prop;
  CHECK(hipGetDeviceProperties(&prop, a.device));
  int blocks = a.blocks ? a.blocks : prop.multiProcessorCount;
  if (a.threads % 64 || a.threads < 64 || a.threads > 1024) {
    std::fprintf(stderr, "--threads must be a multiple of 64 in [64, 1024]\n");
    return 2;
  }

  const char* names[2] = {"aligned", "shifted"};
  hipModule_t mod[2];
  hipFunction_t fn[2];
  for (int k = 0; k < 2; ++k) {
    CHECK(hipModuleLoad(&mod[k], a.paths[k].c_str()));
    CHECK(hipModuleGetFunction(&fn[k], mod[k], "valu_loop"));
  }

  size_t waves = static_cast<size_t>(blocks) * (a.threads / 64);
  uint64_t* d_out;
  CHECK(hipMalloc(&d_out, waves * sizeof(uint64_t)));
  std::vector<uint64_t> h_out(waves);
  hipEvent_t start, stop;
  CHECK(hipEventCreate(&start));
  CHECK(hipEventCreate(&stop));

  std::printf("device %d: %s (%s), %d CUs\n", a.device, prop.name, prop.gcnArchName, prop.multiProcessorCount);
  std::printf("grid %d x %d threads (%d waves/group), %u iterations x %d v_pk_mul_f32, dynamic LDS %d B\n",
              blocks, a.threads, a.threads / 64, a.iters, kLoopInsts, a.lds);

  for (int k = 0; k < 2; ++k) run(fn[k], a, blocks, d_out, h_out, start, stop);  // warm-up

  std::vector<double> wall[2], cyc[2];
  for (int r = 0; r < a.reps; ++r) {
    for (int j = 0; j < 2; ++j) {
      int k = (r + j) % 2;  // alternate which kernel runs first
      Sample s = run(fn[k], a, blocks, d_out, h_out, start, stop);
      wall[k].push_back(s.wall_ms);
      cyc[k].push_back(s.cycles_per_iter);
    }
  }

  std::printf("\n%-8s %12s %16s %16s\n", "kernel", "wall ms", "cycles/iter", "cycles/inst");
  double base_ms = median(wall[0]), base_cyc = median(cyc[0]);
  for (int k = 0; k < 2; ++k) {
    double ms = median(wall[k]), c = median(cyc[k]);
    std::printf("%-8s %12.3f %16.1f %16.2f", names[k], ms, c, c / kLoopInsts);
    if (k) std::printf("   (%+.1f%% wall, %+.1f%% cycles vs aligned)", 100 * (ms / base_ms - 1), 100 * (c / base_cyc - 1));
    std::printf("\n");
  }

  CHECK(hipFree(d_out));
  for (int k = 0; k < 2; ++k) CHECK(hipModuleUnload(mod[k]));
  return 0;
}
