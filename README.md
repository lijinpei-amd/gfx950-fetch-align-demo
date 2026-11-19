# gfx950 instruction-alignment demo: one `s_nop`, 22% slower

On AMD Instinct MI350X (gfx950), an 8-byte instruction that crosses a 32-byte
boundary issues 4 cycles late. If no other wave on the same SIMD is ready to
issue in those cycles, as in kernels limited to one wave per SIMD, those cycles
are lost. Adding or removing one 4-byte instruction (`s_nop 0`) moves every later
instruction in a hot loop of 8-byte VALU instructions by 4 bytes. That changes
which instructions cross a boundary, and the loop gets measurably slower.

```
kernel_demo/   synthetic loop of 64 v_pk_mul_f32
  aligned.s
  shifted.s    = aligned.s + one s_nop 0 before the loop
  launcher.cpp
kernel_gemm/   aiter's Triton FP8 block-scale GEMM, M=N=4096 K=4160
  aligned.s    = shifted.s + one s_nop 0 in the main loop
  shifted.s    Triton's output
  launcher.cpp
```

In each directory, the two kernels differ by exactly one line:

```
$ diff kernel_demo/aligned.s kernel_demo/shifted.s
94a95
> 	s_nop 0                                     // the only difference: +4 bytes
$ diff kernel_gemm/aligned.s kernel_gemm/shifted.s
941d940
< 	s_nop 0
```

## Results (MI350X)

| pair | kernel | 8-byte loop insts crossing 32 B | time |
|---|---|---:|---:|
| `kernel_demo`, 1 wave per CU | aligned | 0 of 64 | 288 cycles/iter, 2.644 ms |
| | shifted | 16 of 64 | **352 cycles/iter** (+64), 3.226 ms (**+22.0%**) |
| `kernel_gemm` | aligned | 28 of 444 | 177.3 µs, 787 TFLOPS |
| | shifted | 77 of 444 | 182.3 µs (**+2.8%**; 2.8–3.3% over repeated runs) |

`kernel_demo` was measured with ROCm 10.1, `kernel_gemm` with ROCm 7.2.

**`kernel_demo`:** the extra 64 cycles per iteration are exactly
16 crossings × 4 cycles. The cycles/iter come from ATT traces of all 256 CUs,
4 dispatches per kernel: every CU ran the loop in exactly 288 (aligned) or 352
(shifted) cycles. Wall time grows by 22.0%, close to 352 / 288 = 1.222.

| waves per CU | launcher `--threads` | aligned wall | shifted wall | shifted vs aligned |
|---:|---:|---:|---:|---:|
| 1 | 64 | 2.644 ms | 3.226 ms | **+22.0%** |
| 2 | 128 | 2.655 ms | 3.230 ms | +21.6% |
| 3 | 192 | 2.654 ms | 3.233 ms | +21.8% |
| 4 (1 per SIMD) | 256 | 3.551 ms | 4.032 ms | +13.6% |
| 8 (2 per SIMD) | 512 | 5.802 ms | 5.971 ms | +2.9% |
| 16 (4 per SIMD) | 1024 | 10.524 ms | 10.747 ms | +2.1% |

- **1 to 3 waves per CU:** each wave has a SIMD to itself, and the full penalty
  shows. One earlier run on another GPU gave +19.8% and +15.9% at 2 and 3 waves
  per CU; that GPU later carried outside load, so the difference is unconfirmed.
- **4 waves per CU:** some CUs run the loop in a slower state that hides part of
  the penalty; see [Fast and slow CUs](#4-waves-per-cu-fast-and-slow-cus).
- **2 or more waves per SIMD:** the other waves on the SIMD fill most of the
  bubbles.

**`kernel_gemm`:** both kernels write bit-identical outputs, and the output
matches a CPU reference.

## Build and run

Requires ROCm (tested with 7.2 and 10.1) and a gfx950 GPU. In either directory:

```bash
cd kernel_demo        # or kernel_gemm
for k in aligned shifted; do
  /opt/rocm/llvm/bin/clang -x assembler -target amdgcn-amd-amdhsa -mcpu=gfx950 $k.s -o $k.hsaco
done
/opt/rocm/bin/hipcc -O2 -std=c++17 -o launcher launcher.cpp
./launcher aligned.hsaco shifted.hsaco
```

Use `ROCR_VISIBLE_DEVICES` to pick a GPU on a shared machine. Both launchers
alternate the two kernels and report medians.

To see the crossings, disassemble a code object and read the address after
`//` on each loop line:

```bash
/opt/rocm/llvm/bin/llvm-objdump -d --mcpu=gfx950 shifted.hsaco
```

An 8-byte instruction crosses a 32-byte boundary when its address is 28 mod 32.

## `kernel_demo`: synthetic loop

`valu_loop(iters)` runs `iters` iterations of 64
independent `v_pk_mul_f32` (8 bytes each, 32 packed accumulators, so there are
no dependency stalls) and writes nothing.

- `aligned.s`: the prologue is 320 bytes, five `s_nop 0` of it padding, so the
  loop starts on a 32-byte boundary and no loop instruction crosses one.
- `shifted.s`: the same code plus `s_nop 0` before the loop. The nop runs once
  per wave, but it moves every loop instruction to an address that is 4 mod 8,
  so every fourth 8-byte instruction crosses a 32-byte boundary.

The launcher allocates 96 KB of dynamic LDS per workgroup, so each CU runs
exactly one workgroup. `--threads 64`, the default, gives one wave per CU;
`--threads 256` gives one wave per SIMD.

Launcher options:
- `--iters N` (20000)
- `--blocks B` (one per CU)
- `--threads T` (64)
- `--lds BYTES` (98304)
- `--reps R` (5)
- `--device D` (0)

The launcher reports wall time only. For cycles per iteration, take an ATT
trace (`rocprofv3 --att`) and read the time between consecutive
`s_cbranch_scc1` of one wave. The kernel has no `s_memtime`: the hardware traces
it as an SMEM instruction, rocprof-trace-decoder classifies it as SALU, and the
mismatch stops the decoder from mapping any later instruction, the whole loop
included, to the code.

For the loop rate of every CU, trace all shader engines
(`--att-shader-engine-mask 0xFFFFFFFF`): `occupancy.json` in each
`ui_output_*` directory holds the start and end time of every wave.

### 4 waves per CU: fast and slow CUs

ATT traces of all 256 CUs at `--threads 256` (8 dispatches of aligned, 2 of
shifted) show every CU running the loop at one of two rates:

| kernel | fast CU | slow CU |
|---|---:|---:|
| aligned | 288 cycles/iter | 384 cycles/iter |
| shifted | 352 cycles/iter | 432–440 cycles/iter |

- **State per CU:** all 4 waves of a CU share it. Every wave's first iteration
  takes about 380 cycles. A CU either drops to the fast rate within 1–3
  iterations or stays slow, then keeps its state for the rest of the 20000
  iterations.
- **Where the time goes:** in a slow CU, the extra cycles fall on the first
  ~10 instructions after the loop's backward branch, the first two 64-byte
  lines of the loop. The waves wait for instructions after jumping back.
- **How many:** 27–80% of CUs were slow in each aligned dispatch. The share did
  not follow the loop's start address mod 128, the shader clock, or which of
  the two loaded copies of the code ran.
- **Effect on wall time:** every dispatch had slow CUs, and they set the
  dispatch time: about 384 cycles/iter for aligned against 440 for shifted, so
  wall time grows by 13.6% instead of 22%.
- **Cause:** unknown. In 12 traced dispatches at 1 or 2 waves per CU, no CU was
  slow, so the CU's waves seem to delay each other's instruction fetch after
  the branch.

## `kernel_gemm`: the GEMM where this showed up

The kernel is `aiter`'s Triton `_gemm_a8w8_blockscale_kernel` for M=N=4096,
K=4160 (FP8 e4m3 inputs, 128×128 block scales, bf16 output). Its tile is
128×256×128 with 4 warps and 2 stages, and it is VGPR-limited to one wave per
SIMD.

- **`shifted.s`:** the compiler output from Triton `3.9.0+gitfeb5e186`, which
  is triton-lang/triton main `1c53e566` with the `add_move_up_prologue_loads`
  pass removed from the AMD pipeline. Only the target-id string was rewritten
  so ROCm's clang accepts the file; the instructions are identical to Triton's
  binary.
- **`aligned.s`:** the same file plus one `s_nop 0` in the main loop, before
  the `b_scale` load.

Removing that pass makes Triton issue the scale loads after the A/B tile copies
in the prologue. The compiler then places a few extra 4-byte
`s_waitcnt vmcnt(N)` instructions inside the main loop. These shift the loop's
tail of 8-byte VALU instructions (`v_pk_mul_f32`, `v_pk_add_f32`,
`v_accvgpr_read/write`) by 4 bytes, so 77 instead of 30 of them cross a 32-byte
boundary.

Measured on this kernel:
- **Timing:** the build without the pass was 3.2% slower than the build with
  it (177.6 → 183.6 µs).
- **Trace:** an ATT trace showed the wave issuing the instruction after each
  crossing 4 cycles late, about 200 extra cycles per loop iteration. Prologue
  and epilogue were unchanged.
- **One-`s_nop` test:** inserting one `s_nop 0` at the same place in each
  build swapped the results:

| build | original | + one `s_nop 0` |
|---|---|---|
| with the pass | 177.6 µs (30 crossings) | 183.1 µs (78 crossings) |
| without the pass | 183.6 µs (77 crossings) | 177.9 µs (28 crossings) |

The launcher runs the pair on the same random inputs:
- it flushes L2 before every launch;
- it checks that both kernels write identical output, and checks 64 outputs
  against a CPU reference.

Options: `--iters N` (100), `--device D` (0).

## Caveat

The 32-byte figure and the 4-cycle cost come from measurement on gfx950 (this
repo and the ATT trace above), not from documentation. Other architectures and
occupancies may behave differently, and the slow CU state at 4 waves per CU is
not explained.
