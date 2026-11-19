// Load two code objects that contain `valu_loop`, run them interleaved, and
// compare their wall time (hipEvent). For cycles per iteration, take an ATT trace.
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
  int threads = 64;      // 64 = 1 wave per CU; 256 = 1 wave per SIMD
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

// Returns the wall time of one launch in ms.
double run(hipFunction_t fn, const Args& a, int blocks, hipEvent_t start, hipEvent_t stop) {
  uint32_t iters = a.iters;  // the only kernel argument
  size_t size = sizeof(iters);
  void* config[] = {HIP_LAUNCH_PARAM_BUFFER_POINTER, &iters, HIP_LAUNCH_PARAM_BUFFER_SIZE, &size,
                    HIP_LAUNCH_PARAM_END};
  CHECK(hipEventRecord(start));
  CHECK(hipModuleLaunchKernel(fn, blocks, 1, 1, a.threads, 1, 1, a.lds, nullptr, nullptr, config));
  CHECK(hipEventRecord(stop));
  CHECK(hipEventSynchronize(stop));
  float ms = 0;
  CHECK(hipEventElapsedTime(&ms, start, stop));
  return ms;
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

  hipEvent_t start, stop;
  CHECK(hipEventCreate(&start));
  CHECK(hipEventCreate(&stop));

  std::printf("device %d: %s (%s), %d CUs\n", a.device, prop.name, prop.gcnArchName, prop.multiProcessorCount);
  std::printf("grid %d x %d threads (%d waves/group), %u iterations x %d v_pk_mul_f32, dynamic LDS %d B\n",
              blocks, a.threads, a.threads / 64, a.iters, kLoopInsts, a.lds);

  for (int k = 0; k < 2; ++k) run(fn[k], a, blocks, start, stop);  // warm-up

  std::vector<double> wall[2];
  for (int r = 0; r < a.reps; ++r) {
    for (int j = 0; j < 2; ++j) {
      int k = (r + j) % 2;  // alternate which kernel runs first
      wall[k].push_back(run(fn[k], a, blocks, start, stop));
    }
  }

  std::printf("\n%-8s %12s\n", "kernel", "wall ms");
  double base_ms = median(wall[0]);
  for (int k = 0; k < 2; ++k) {
    double ms = median(wall[k]);
    std::printf("%-8s %12.3f", names[k], ms);
    if (k) std::printf("   (%+.1f%% vs aligned)", 100 * (ms / base_ms - 1));
    std::printf("\n");
  }

  for (int k = 0; k < 2; ++k) CHECK(hipModuleUnload(mod[k]));
  return 0;
}
