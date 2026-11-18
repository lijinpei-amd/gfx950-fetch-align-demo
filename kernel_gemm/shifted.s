// aiter gemm_a8w8_blockscale (Triton), M=N=4096 K=4160, gfx950. Compiled by Triton 3.9.0+gitfeb5e186
// (triton-lang/triton main 1c53e566 without add_move_up_prologue_loads). shifted.s is the compiler
// output with instructions unchanged; aligned.s adds one `s_nop 0` in the main loop, before the b_scale load.
// The target-id string was rewritten from Triton's "amdgpu9.50-amd-amdhsa-unknown-gfx950" so ROCm clang accepts it.
	.amdgcn_target "amdgcn-amd-amdhsa--gfx950"
	.amdhsa_code_object_version 5
	.text
	.globl	_gemm_a8w8_blockscale_kernel_GROUP_K_128_GROUP_N_128_BLOCK_SIZE_M_128_BLOCK_SIZE_N_256_BLOCK_SIZE_K_128_GROUP_SIZE_M_1_NUM_KSPLIT_1_SPLITK_BLOCK_SIZE_4160_EVEN_K_0_EVEN_SPLITK_1_cache_modifier_NONE ; -- Begin function _gemm_a8w8_blockscale_kernel_GROUP_K_128_GROUP_N_128_BLOCK_SIZE_M_128_BLOCK_SIZE_N_256_BLOCK_SIZE_K_128_GROUP_SIZE_M_1_NUM_KSPLIT_1_SPLITK_BLOCK_SIZE_4160_EVEN_K_0_EVEN_SPLITK_1_cache_modifier_NONE
	.p2align	8
	.type	_gemm_a8w8_blockscale_kernel_GROUP_K_128_GROUP_N_128_BLOCK_SIZE_M_128_BLOCK_SIZE_N_256_BLOCK_SIZE_K_128_GROUP_SIZE_M_1_NUM_KSPLIT_1_SPLITK_BLOCK_SIZE_4160_EVEN_K_0_EVEN_SPLITK_1_cache_modifier_NONE,@function
_gemm_a8w8_blockscale_kernel_GROUP_K_128_GROUP_N_128_BLOCK_SIZE_M_128_BLOCK_SIZE_N_256_BLOCK_SIZE_K_128_GROUP_SIZE_M_1_NUM_KSPLIT_1_SPLITK_BLOCK_SIZE_4160_EVEN_K_0_EVEN_SPLITK_1_cache_modifier_NONE: ; @_gemm_a8w8_blockscale_kernel_GROUP_K_128_GROUP_N_128_BLOCK_SIZE_M_128_BLOCK_SIZE_N_256_BLOCK_SIZE_K_128_GROUP_SIZE_M_1_NUM_KSPLIT_1_SPLITK_BLOCK_SIZE_4160_EVEN_K_0_EVEN_SPLITK_1_cache_modifier_NONE
; %bb.5:
	s_load_dwordx2 s[2:3], s[0:1], 0x0
	s_load_dwordx8 s[4:11], s[0:1], 0x8
	s_load_dwordx4 s[12:15], s[0:1], 0x28
	s_waitcnt lgkmcnt(0)
	s_branch .LBB0_0
	.p2align	8
; %bb.6:
.LBB0_0:
	s_mov_b64 s[20:21], s[10:11]
	s_cmp_lt_i32 s14, 1
	v_readfirstlane_b32 s11, v0
	s_cbranch_scc1 .LBB0_4
; %bb.1:
	s_mov_b64 s[28:29], s[2:3]
	s_add_i32 s2, s13, 0xff
	s_ashr_i32 s3, s2, 31
	s_lshr_b32 s3, s3, 24
	s_add_i32 s2, s2, s3
	s_ashr_i32 s10, s2, 8
	s_mov_b32 s26, s13
	s_abs_i32 s13, s10
	v_cvt_f32_u32_e32 v1, s13
	s_sub_i32 s17, 0, s13
	s_mov_b64 s[24:25], s[6:7]
	s_load_dword s7, s[0:1], 0x38
	s_load_dwordx2 s[2:3], s[0:1], 0x40
	s_load_dword s6, s[0:1], 0x48
	v_rcp_f32_e32 v1, v1
	s_abs_i32 s0, s16
	s_xor_b32 s1, s16, s10
	s_ashr_i32 s1, s1, 31
	v_mul_f32_e32 v1, 0x4f7ffffe, v1
	v_cvt_u32_f32_e32 v1, v1
	v_lshlrev_b32_e32 v2, 1, v0
	v_and_b32_e32 v2, 0x70, v2
	v_and_b32_e32 v3, 63, v0
	v_readfirstlane_b32 s19, v1
	s_mul_i32 s17, s17, s19
	s_mul_hi_u32 s17, s19, s17
	s_add_i32 s19, s19, s17
	s_mul_hi_u32 s17, s0, s19
	s_mul_i32 s19, s17, s13
	s_sub_i32 s0, s0, s19
	s_add_i32 s22, s17, 1
	s_sub_i32 s19, s0, s13
	s_cmp_ge_u32 s0, s13
	s_cselect_b32 s17, s22, s17
	s_cselect_b32 s0, s19, s0
	s_add_i32 s19, s17, 1
	s_cmp_ge_u32 s0, s13
	s_cselect_b32 s0, s19, s17
	s_xor_b32 s0, s0, s1
	s_sub_i32 s1, s0, s1
	s_mul_i32 s0, s1, s10
	s_sub_i32 s10, s16, s0
	s_lshr_b32 s16, s11, 6
	v_or_b32_e32 v4, s16, v2
	v_and_b32_e32 v2, 15, v0
	v_or_b32_e32 v8, 16, v2
	s_lshl_b32 s0, s1, 7
	s_abs_i32 s13, s12
	v_or_b32_e32 v22, s0, v8
	v_cvt_f32_u32_e32 v8, s13
	v_or_b32_e32 v10, 48, v2
	s_sub_i32 s17, 0, s13
	v_or_b32_e32 v9, 32, v2
	v_rcp_f32_e32 v8, v8
	v_or_b32_e32 v15, s0, v4
	v_or_b32_e32 v26, s0, v10
	s_bfe_i32 s1, s1, 0x10018
	v_mul_f32_e32 v8, 0x4f7ffffe, v8
	v_cvt_u32_f32_e32 v8, v8
	v_or_b32_e32 v24, s0, v9
	v_add_u32_e32 v9, s1, v15
	v_xor_b32_e32 v9, s1, v9
	v_mul_lo_u32 v10, s17, v8
	v_mul_hi_u32 v10, v8, v10
	v_add_u32_e32 v8, v8, v10
	v_mul_hi_u32 v10, v9, v8
	v_mul_lo_u32 v10, v10, s13
	v_sub_u32_e32 v9, v9, v10
	v_subrev_u32_e32 v10, s13, v9
	v_cmp_le_u32_e32 vcc, s13, v9
	v_or_b32_e32 v5, 4, v4
	v_or_b32_e32 v16, s0, v5
	v_cndmask_b32_e32 v9, v9, v10, vcc
	v_subrev_u32_e32 v10, s13, v9
	v_cmp_le_u32_e32 vcc, s13, v9
	v_or_b32_e32 v11, 64, v2
	v_or_b32_e32 v28, s0, v11
	v_cndmask_b32_e32 v9, v9, v10, vcc
	v_add_u32_e32 v10, s1, v16
	v_xor_b32_e32 v10, s1, v10
	v_mul_hi_u32 v11, v10, v8
	v_mul_lo_u32 v11, v11, s13
	v_sub_u32_e32 v10, v10, v11
	v_subrev_u32_e32 v11, s13, v10
	v_cmp_le_u32_e32 vcc, s13, v10
	v_or_b32_e32 v6, 8, v4
	v_or_b32_e32 v17, s0, v6
	v_cndmask_b32_e32 v10, v10, v11, vcc
	v_subrev_u32_e32 v11, s13, v10
	v_cmp_le_u32_e32 vcc, s13, v10
	v_or_b32_e32 v12, 0x50, v2
	v_or_b32_e32 v30, s0, v12
	v_cndmask_b32_e32 v10, v10, v11, vcc
	v_add_u32_e32 v11, s1, v17
	v_xor_b32_e32 v11, s1, v11
	v_mul_hi_u32 v12, v11, v8
	v_mul_lo_u32 v12, v12, s13
	v_sub_u32_e32 v11, v11, v12
	v_subrev_u32_e32 v12, s13, v11
	v_cmp_le_u32_e32 vcc, s13, v11
	v_or_b32_e32 v7, 12, v4
	v_or_b32_e32 v18, s0, v7
	v_cndmask_b32_e32 v11, v11, v12, vcc
	v_subrev_u32_e32 v12, s13, v11
	v_cmp_le_u32_e32 vcc, s13, v11
	v_or_b32_e32 v13, 0x60, v2
	v_or_b32_e32 v32, s0, v13
	v_cndmask_b32_e32 v11, v11, v12, vcc
	v_add_u32_e32 v12, s1, v18
	v_xor_b32_e32 v12, s1, v12
	v_mul_hi_u32 v13, v12, v8
	v_mul_lo_u32 v13, v13, s13
	v_sub_u32_e32 v12, v12, v13
	v_subrev_u32_e32 v13, s13, v12
	v_cmp_le_u32_e32 vcc, s13, v12
	v_or_b32_e32 v20, s0, v2
	v_or_b32_e32 v14, 0x70, v2
	v_cndmask_b32_e32 v12, v12, v13, vcc
	v_subrev_u32_e32 v13, s13, v12
	v_cmp_le_u32_e32 vcc, s13, v12
	v_or_b32_e32 v34, s0, v14
	v_accvgpr_write_b32 a32, v20
	v_cndmask_b32_e32 v12, v12, v13, vcc
	v_add_u32_e32 v13, s1, v20
	v_xor_b32_e32 v13, s1, v13
	v_mul_hi_u32 v14, v13, v8
	v_mul_lo_u32 v14, v14, s13
	v_sub_u32_e32 v13, v13, v14
	v_subrev_u32_e32 v14, s13, v13
	v_cmp_le_u32_e32 vcc, s13, v13
	v_accvgpr_write_b32 a34, v22
	s_and_b32 s11, s11, 0xc0
	v_cndmask_b32_e32 v13, v13, v14, vcc
	v_subrev_u32_e32 v14, s13, v13
	v_cmp_le_u32_e32 vcc, s13, v13
	v_or_b32_e32 v1, s11, v3
	v_xor_b32_e32 v9, s1, v9
	v_cndmask_b32_e32 v13, v13, v14, vcc
	v_xor_b32_e32 v13, s1, v13
	v_subrev_u32_e32 v16, s1, v13
	v_add_u32_e32 v13, s1, v22
	v_xor_b32_e32 v13, s1, v13
	v_mul_hi_u32 v14, v13, v8
	v_mul_lo_u32 v14, v14, s13
	v_sub_u32_e32 v13, v13, v14
	v_subrev_u32_e32 v14, s13, v13
	v_cmp_le_u32_e32 vcc, s13, v13
	v_xor_b32_e32 v10, s1, v10
	v_xor_b32_e32 v11, s1, v11
	v_cndmask_b32_e32 v13, v13, v14, vcc
	v_subrev_u32_e32 v14, s13, v13
	v_cmp_le_u32_e32 vcc, s13, v13
	v_xor_b32_e32 v12, s1, v12
	v_subrev_u32_e32 v9, s1, v9
	v_cndmask_b32_e32 v13, v13, v14, vcc
	v_xor_b32_e32 v13, s1, v13
	v_subrev_u32_e32 v17, s1, v13
	v_add_u32_e32 v13, s1, v24
	v_xor_b32_e32 v13, s1, v13
	v_mul_hi_u32 v14, v13, v8
	v_mul_lo_u32 v14, v14, s13
	v_sub_u32_e32 v13, v13, v14
	v_subrev_u32_e32 v14, s13, v13
	v_cmp_le_u32_e32 vcc, s13, v13
	v_subrev_u32_e32 v10, s1, v10
	v_subrev_u32_e32 v11, s1, v11
	v_cndmask_b32_e32 v13, v13, v14, vcc
	v_subrev_u32_e32 v14, s13, v13
	v_cmp_le_u32_e32 vcc, s13, v13
	v_subrev_u32_e32 v12, s1, v12
	v_accvgpr_write_b32 a36, v24
	v_cndmask_b32_e32 v13, v13, v14, vcc
	v_xor_b32_e32 v13, s1, v13
	v_subrev_u32_e32 v18, s1, v13
	v_add_u32_e32 v13, s1, v26
	v_xor_b32_e32 v13, s1, v13
	v_mul_hi_u32 v14, v13, v8
	v_mul_lo_u32 v14, v14, s13
	v_sub_u32_e32 v13, v13, v14
	v_subrev_u32_e32 v14, s13, v13
	v_cmp_le_u32_e32 vcc, s13, v13
	v_accvgpr_write_b32 a38, v26
	v_accvgpr_write_b32 a40, v28
	v_cndmask_b32_e32 v13, v13, v14, vcc
	v_subrev_u32_e32 v14, s13, v13
	v_cmp_le_u32_e32 vcc, s13, v13
	v_accvgpr_write_b32 a42, v30
	s_and_b32 s29, s29, 0xffff
	v_cndmask_b32_e32 v13, v13, v14, vcc
	v_xor_b32_e32 v13, s1, v13
	v_subrev_u32_e32 v19, s1, v13
	v_add_u32_e32 v13, s1, v28
	v_xor_b32_e32 v13, s1, v13
	v_mul_hi_u32 v14, v13, v8
	v_mul_lo_u32 v14, v14, s13
	v_sub_u32_e32 v13, v13, v14
	v_subrev_u32_e32 v14, s13, v13
	v_cmp_le_u32_e32 vcc, s13, v13
	s_mov_b32 s31, 0x27000
	s_mov_b32 s30, 0x7ffffffe
	v_cndmask_b32_e32 v13, v13, v14, vcc
	v_subrev_u32_e32 v14, s13, v13
	v_cmp_le_u32_e32 vcc, s13, v13
	s_and_b32 s5, s5, 0xffff
	s_and_b32 s9, s9, 0xffff
	v_cndmask_b32_e32 v13, v13, v14, vcc
	v_xor_b32_e32 v13, s1, v13
	v_subrev_u32_e32 v20, s1, v13
	v_add_u32_e32 v13, s1, v30
	v_xor_b32_e32 v13, s1, v13
	v_mul_hi_u32 v14, v13, v8
	v_mul_lo_u32 v14, v14, s13
	v_sub_u32_e32 v13, v13, v14
	v_subrev_u32_e32 v14, s13, v13
	v_cmp_le_u32_e32 vcc, s13, v13
	s_and_b32 s21, s21, 0xffff
	s_mov_b32 s22, s30
	v_cndmask_b32_e32 v13, v13, v14, vcc
	v_subrev_u32_e32 v14, s13, v13
	v_cmp_le_u32_e32 vcc, s13, v13
	s_mov_b32 s23, s31
	s_mov_b32 s18, 0
	v_cndmask_b32_e32 v13, v13, v14, vcc
	v_xor_b32_e32 v13, s1, v13
	v_subrev_u32_e32 v21, s1, v13
	v_add_u32_e32 v13, s1, v32
	v_xor_b32_e32 v13, s1, v13
	v_mul_hi_u32 v14, v13, v8
	v_mul_lo_u32 v14, v14, s13
	v_sub_u32_e32 v13, v13, v14
	v_subrev_u32_e32 v14, s13, v13
	v_cmp_le_u32_e32 vcc, s13, v13
	v_accvgpr_write_b32 a44, v32
	v_accvgpr_write_b32 a46, v34
	v_cndmask_b32_e32 v13, v13, v14, vcc
	v_subrev_u32_e32 v14, s13, v13
	v_cmp_le_u32_e32 vcc, s13, v13
	v_lshlrev_b32_e32 v177, 5, v2
	v_mov_b32_e32 v158, 0
	v_cndmask_b32_e32 v13, v13, v14, vcc
	v_xor_b32_e32 v13, s1, v13
	v_subrev_u32_e32 v22, s1, v13
	v_add_u32_e32 v13, s1, v34
	v_xor_b32_e32 v13, s1, v13
	v_mul_hi_u32 v8, v13, v8
	v_mul_lo_u32 v8, v8, s13
	v_sub_u32_e32 v8, v13, v8
	v_subrev_u32_e32 v13, s13, v8
	v_cmp_le_u32_e32 vcc, s13, v8
	v_mov_b32_e32 v159, 0
	v_mov_b32_e32 v156, 0
	v_cndmask_b32_e32 v8, v8, v13, vcc
	v_subrev_u32_e32 v13, s13, v8
	v_cmp_le_u32_e32 vcc, s13, v8
	v_mov_b32_e32 v157, 0
	v_mov_b32_e32 v154, 0
	v_cndmask_b32_e32 v8, v8, v13, vcc
	v_xor_b32_e32 v8, s1, v8
	v_subrev_u32_e32 v23, s1, v8
	v_mov_b32_e32 v8, 0xf0
	v_bitop3_b32 v175, s11, v8, v3 bitop3:0xc8
	s_abs_i32 s11, s26
	v_cvt_f32_u32_e32 v3, s11
	s_lshl_b32 s1, s10, 8
	s_sub_i32 s13, 0, s11
	v_or_b32_e32 v4, s1, v4
	v_rcp_f32_e32 v3, v3
	s_bfe_i32 s10, s10, 0x10017
	v_add_u32_e32 v4, s10, v4
	v_xor_b32_e32 v13, s10, v4
	v_mul_f32_e32 v3, 0x4f7ffffe, v3
	v_cvt_u32_f32_e32 v3, v3
	v_or_b32_e32 v5, s1, v5
	v_add_u32_e32 v5, s10, v5
	v_xor_b32_e32 v5, s10, v5
	v_mul_lo_u32 v14, s13, v3
	v_mul_hi_u32 v14, v3, v14
	v_add_u32_e32 v3, v3, v14
	v_mul_hi_u32 v14, v13, v3
	v_mul_lo_u32 v14, v14, s11
	v_sub_u32_e32 v13, v13, v14
	v_subrev_u32_e32 v14, s11, v13
	v_cmp_le_u32_e32 vcc, s11, v13
	v_or_b32_e32 v6, s1, v6
	v_add_u32_e32 v6, s10, v6
	v_cndmask_b32_e32 v13, v13, v14, vcc
	v_subrev_u32_e32 v14, s11, v13
	v_cmp_le_u32_e32 vcc, s11, v13
	v_xor_b32_e32 v6, s10, v6
	v_or_b32_e32 v7, s1, v7
	v_cndmask_b32_e32 v13, v13, v14, vcc
	v_xor_b32_e32 v13, s10, v13
	v_subrev_u32_e32 v14, s10, v13
	v_mul_hi_u32 v13, v5, v3
	v_mul_lo_u32 v13, v13, s11
	v_sub_u32_e32 v5, v5, v13
	v_subrev_u32_e32 v13, s11, v5
	v_cmp_le_u32_e32 vcc, s11, v5
	v_or_b32_e32 v8, s1, v1
	s_mul_i32 s13, s16, 0x420
	v_cndmask_b32_e32 v5, v5, v13, vcc
	v_subrev_u32_e32 v13, s11, v5
	v_cmp_le_u32_e32 vcc, s11, v5
	v_mov_b32_e32 v155, 0
	v_mov_b32_e32 v152, 0
	v_cndmask_b32_e32 v5, v5, v13, vcc
	v_mul_hi_u32 v13, v6, v3
	v_mul_lo_u32 v13, v13, s11
	v_sub_u32_e32 v6, v6, v13
	v_subrev_u32_e32 v13, s11, v6
	v_cmp_le_u32_e32 vcc, s11, v6
	v_xor_b32_e32 v5, s10, v5
	v_subrev_u32_e32 v5, s10, v5
	v_cndmask_b32_e32 v6, v6, v13, vcc
	v_subrev_u32_e32 v13, s11, v6
	v_cmp_le_u32_e32 vcc, s11, v6
	v_mov_b32_e32 v153, 0
	v_mov_b32_e32 v150, 0
	v_cndmask_b32_e32 v6, v6, v13, vcc
	v_xor_b32_e32 v6, s10, v6
	v_subrev_u32_e32 v24, s10, v6
	v_add_u32_e32 v6, s10, v7
	v_xor_b32_e32 v6, s10, v6
	v_mul_hi_u32 v7, v6, v3
	v_mul_lo_u32 v7, v7, s11
	v_sub_u32_e32 v6, v6, v7
	v_subrev_u32_e32 v7, s11, v6
	v_cmp_le_u32_e32 vcc, s11, v6
	v_mov_b32_e32 v151, 0
	v_mov_b32_e32 v148, 0
	v_cndmask_b32_e32 v6, v6, v7, vcc
	v_subrev_u32_e32 v7, s11, v6
	v_cmp_le_u32_e32 vcc, s11, v6
	v_mov_b32_e32 v149, 0
	v_mov_b32_e32 v146, 0
	v_cndmask_b32_e32 v6, v6, v7, vcc
	v_xor_b32_e32 v6, s10, v6
	v_subrev_u32_e32 v25, s10, v6
	v_add_u32_e32 v6, 0x80, v4
	v_xor_b32_e32 v6, s10, v6
	v_mul_hi_u32 v7, v6, v3
	v_mul_lo_u32 v7, v7, s11
	v_sub_u32_e32 v6, v6, v7
	v_subrev_u32_e32 v7, s11, v6
	v_cmp_le_u32_e32 vcc, s11, v6
	v_mov_b32_e32 v147, 0
	v_mov_b32_e32 v144, 0
	v_cndmask_b32_e32 v6, v6, v7, vcc
	v_subrev_u32_e32 v7, s11, v6
	v_cmp_le_u32_e32 vcc, s11, v6
	v_mov_b32_e32 v145, 0
	v_mov_b32_e32 v142, 0
	v_cndmask_b32_e32 v6, v6, v7, vcc
	v_xor_b32_e32 v6, s10, v6
	v_subrev_u32_e32 v26, s10, v6
	v_add_u32_e32 v6, 0x84, v4
	v_xor_b32_e32 v6, s10, v6
	v_mul_hi_u32 v7, v6, v3
	v_mul_lo_u32 v7, v7, s11
	v_sub_u32_e32 v6, v6, v7
	v_subrev_u32_e32 v7, s11, v6
	v_cmp_le_u32_e32 vcc, s11, v6
	v_mov_b32_e32 v143, 0
	v_mov_b32_e32 v140, 0
	v_cndmask_b32_e32 v6, v6, v7, vcc
	v_subrev_u32_e32 v7, s11, v6
	v_cmp_le_u32_e32 vcc, s11, v6
	v_mov_b32_e32 v141, 0
	v_mov_b32_e32 v138, 0
	v_cndmask_b32_e32 v6, v6, v7, vcc
	v_xor_b32_e32 v6, s10, v6
	v_subrev_u32_e32 v27, s10, v6
	v_add_u32_e32 v6, 0x88, v4
	v_xor_b32_e32 v6, s10, v6
	v_mul_hi_u32 v7, v6, v3
	v_mul_lo_u32 v7, v7, s11
	v_sub_u32_e32 v6, v6, v7
	v_subrev_u32_e32 v7, s11, v6
	v_cmp_le_u32_e32 vcc, s11, v6
	v_add_u32_e32 v4, 0x8c, v4
	v_xor_b32_e32 v4, s10, v4
	v_cndmask_b32_e32 v6, v6, v7, vcc
	v_subrev_u32_e32 v7, s11, v6
	v_cmp_le_u32_e32 vcc, s11, v6
	v_mov_b32_e32 v139, 0
	v_mov_b32_e32 v136, 0
	v_cndmask_b32_e32 v6, v6, v7, vcc
	v_xor_b32_e32 v6, s10, v6
	v_subrev_u32_e32 v28, s10, v6
	v_mul_hi_u32 v6, v4, v3
	v_mul_lo_u32 v6, v6, s11
	v_sub_u32_e32 v4, v4, v6
	v_subrev_u32_e32 v6, s11, v4
	v_cmp_le_u32_e32 vcc, s11, v4
	v_mov_b32_e32 v137, 0
	v_mov_b32_e32 v134, 0
	v_cndmask_b32_e32 v4, v4, v6, vcc
	v_subrev_u32_e32 v6, s11, v4
	v_cmp_le_u32_e32 vcc, s11, v4
	v_mov_b32_e32 v135, 0
	v_mov_b32_e32 v132, 0
	v_cndmask_b32_e32 v4, v4, v6, vcc
	v_sub_u32_e32 v6, 0, v8
	v_max_i32_e32 v6, v6, v8
	v_mul_hi_u32 v3, v6, v3
	v_mul_lo_u32 v3, v3, s11
	v_sub_u32_e32 v3, v6, v3
	v_subrev_u32_e32 v6, s11, v3
	v_cmp_le_u32_e32 vcc, s11, v3
	v_xor_b32_e32 v4, s10, v4
	v_subrev_u32_e32 v4, s10, v4
	v_cndmask_b32_e32 v3, v3, v6, vcc
	v_subrev_u32_e32 v6, s11, v3
	v_cmp_le_u32_e32 vcc, s11, v3
	v_mov_b32_e32 v133, 0
	v_mov_b32_e32 v130, 0
	v_cndmask_b32_e32 v3, v3, v6, vcc
	v_xor_b32_e32 v3, s10, v3
	v_lshlrev_b32_e32 v6, 4, v0
	v_subrev_u32_e32 v3, s10, v3
	v_and_b32_e32 v30, 0x70, v6
	s_waitcnt lgkmcnt(0)
	v_mad_u64_u32 v[172:173], s[10:11], v4, s7, v[30:31]
	v_ashrrev_i32_e32 v4, 31, v3
	v_lshrrev_b32_e32 v4, 25, v4
	v_mad_u64_u32 v[6:7], s[10:11], v9, s15, v[30:31]
	v_mad_u64_u32 v[8:9], s[10:11], v10, s15, v[30:31]
	v_mad_u64_u32 v[10:11], s[10:11], v11, s15, v[30:31]
	v_mad_u64_u32 v[12:13], s[10:11], v12, s15, v[30:31]
	v_mad_u64_u32 v[14:15], s[10:11], v14, s7, v[30:31]
	v_mad_u64_u32 v[160:161], s[10:11], v5, s7, v[30:31]
	v_mad_u64_u32 v[162:163], s[10:11], v24, s7, v[30:31]
	v_mad_u64_u32 v[164:165], s[10:11], v25, s7, v[30:31]
	v_mad_u64_u32 v[166:167], s[10:11], v26, s7, v[30:31]
	v_mad_u64_u32 v[168:169], s[10:11], v27, s7, v[30:31]
	v_mad_u64_u32 v[170:171], s[10:11], v28, s7, v[30:31]
	v_add_u32_e32 v3, v3, v4
	v_ashrrev_i32_e32 v3, 7, v3
	s_add_i32 s10, s13, 0x107e0
	v_cmp_gt_u32_e32 vcc, s14, v30
	v_mul_lo_u32 v169, v3, s6
	s_mov_b32 m0, s10
	v_cndmask_b32_e32 v3, -1, v6, vcc
	buffer_load_dwordx4 v3, s[28:31], 0 offen lds
	s_add_i32 m0, s10, 0x1080
	v_cndmask_b32_e32 v3, -1, v8, vcc
	buffer_load_dwordx4 v3, s[28:31], 0 offen lds
	s_add_i32 m0, s10, 0x2100
	v_cndmask_b32_e32 v3, -1, v10, vcc
	buffer_load_dwordx4 v3, s[28:31], 0 offen lds
	s_add_i32 m0, s10, 0x3180
	v_cndmask_b32_e32 v3, -1, v12, vcc
	buffer_load_dwordx4 v3, s[28:31], 0 offen lds
	s_mov_b32 s6, s30
	s_mov_b32 s7, s31
	s_add_i32 m0, s10, 0xfffef820
	v_cndmask_b32_e32 v3, -1, v14, vcc
	; asyncmark
	buffer_load_dwordx4 v3, s[4:7], 0 offen lds
	s_add_i32 m0, s10, 0xffff08a0
	v_cndmask_b32_e32 v3, -1, v160, vcc
	buffer_load_dwordx4 v3, s[4:7], 0 offen lds
	s_add_i32 m0, s10, 0xffff1920
	v_cndmask_b32_e32 v3, -1, v162, vcc
	buffer_load_dwordx4 v3, s[4:7], 0 offen lds
	s_add_i32 m0, s10, 0xffff29a0
	v_cndmask_b32_e32 v3, -1, v164, vcc
	buffer_load_dwordx4 v3, s[4:7], 0 offen lds
	s_add_i32 m0, s10, 0xffff3a20
	v_cndmask_b32_e32 v3, -1, v166, vcc
	buffer_load_dwordx4 v3, s[4:7], 0 offen lds
	s_add_i32 m0, s10, 0xffff4aa0
	v_cndmask_b32_e32 v3, -1, v168, vcc
	buffer_load_dwordx4 v3, s[4:7], 0 offen lds
	s_add_i32 m0, s10, 0xffff5b20
	v_cndmask_b32_e32 v3, -1, v170, vcc
	v_mul_lo_u32 v9, v16, s3
	buffer_load_dwordx4 v3, s[4:7], 0 offen lds
	s_add_i32 m0, s10, 0xffff6ba0
	v_cndmask_b32_e32 v3, -1, v172, vcc
	v_mul_lo_u32 v11, v17, s3
	v_mul_lo_u32 v13, v18, s3
	v_mul_lo_u32 v15, v19, s3
	v_mul_lo_u32 v161, v20, s3
	v_mul_lo_u32 v163, v21, s3
	v_mul_lo_u32 v165, v22, s3
	v_mul_lo_u32 v167, v23, s3
	buffer_load_dwordx4 v3, s[4:7], 0 offen lds
	s_mov_b32 s10, s30
	s_mov_b32 s11, s31
	v_lshlrev_b32_e32 v3, 2, v9
	; asyncmark
	v_lshlrev_b32_e32 v4, 2, v11
	v_lshlrev_b32_e32 v5, 2, v13
	v_lshlrev_b32_e32 v7, 2, v15
	v_lshlrev_b32_e32 v16, 2, v161
	v_lshlrev_b32_e32 v17, 2, v163
	v_lshlrev_b32_e32 v18, 2, v165
	v_lshlrev_b32_e32 v19, 2, v167
	buffer_load_dword v188, v3, s[8:11], 0 offen
	buffer_load_dword v186, v4, s[8:11], 0 offen
	buffer_load_dword v184, v5, s[8:11], 0 offen
	buffer_load_dword v182, v7, s[8:11], 0 offen
	buffer_load_dword v180, v16, s[8:11], 0 offen
	buffer_load_dword v178, v17, s[8:11], 0 offen
	buffer_load_dword v176, v18, s[8:11], 0 offen
	buffer_load_dword v174, v19, s[8:11], 0 offen
	v_lshlrev_b32_e32 v3, 2, v169
	buffer_load_dword v179, v3, s[20:23], 0 offen
	s_mov_b32 s3, 0x107e0
	v_accvgpr_write_b32 a102, v30
	v_lshlrev_b32_e32 v171, 10, v2
	v_and_b32_e32 v173, 48, v0
	s_lshl_b32 s15, s16, 7
	v_lshlrev_b32_e32 v7, 2, v1
	v_mov_b32_e32 v131, 0
	v_mov_b32_e32 v128, 0
	v_mov_b32_e32 v129, 0
	v_mov_b32_e32 v126, 0
	v_mov_b32_e32 v127, 0
	v_mov_b32_e32 v124, 0
	v_mov_b32_e32 v125, 0
	v_mov_b32_e32 v122, 0
	v_mov_b32_e32 v123, 0
	v_mov_b32_e32 v120, 0
	v_mov_b32_e32 v121, 0
	v_mov_b32_e32 v118, 0
	v_mov_b32_e32 v119, 0
	v_mov_b32_e32 v116, 0
	v_mov_b32_e32 v117, 0
	v_mov_b32_e32 v114, 0
	v_mov_b32_e32 v115, 0
	v_mov_b32_e32 v112, 0
	v_mov_b32_e32 v113, 0
	v_mov_b32_e32 v110, 0
	v_mov_b32_e32 v111, 0
	v_mov_b32_e32 v108, 0
	v_mov_b32_e32 v109, 0
	v_mov_b32_e32 v106, 0
	v_mov_b32_e32 v107, 0
	v_mov_b32_e32 v104, 0
	v_mov_b32_e32 v105, 0
	v_mov_b32_e32 v102, 0
	v_mov_b32_e32 v103, 0
	v_mov_b32_e32 v100, 0
	v_mov_b32_e32 v101, 0
	v_mov_b32_e32 v98, 0
	v_mov_b32_e32 v99, 0
	v_mov_b32_e32 v96, 0
	v_mov_b32_e32 v97, 0
	v_mov_b32_e32 v94, 0
	v_mov_b32_e32 v95, 0
	v_mov_b32_e32 v92, 0
	v_mov_b32_e32 v93, 0
	v_mov_b32_e32 v90, 0
	v_mov_b32_e32 v91, 0
	v_accvgpr_write_b32 a100, 0
	v_accvgpr_write_b32 a101, 0
	v_mov_b32_e32 v86, 0
	v_mov_b32_e32 v87, 0
	v_mov_b32_e32 v84, 0
	v_mov_b32_e32 v85, 0
	v_accvgpr_write_b32 a98, 0
	v_accvgpr_write_b32 a99, 0
	v_accvgpr_write_b32 a96, 0
	v_accvgpr_write_b32 a97, 0
	v_accvgpr_write_b32 a94, 0
	v_accvgpr_write_b32 a95, 0
	v_accvgpr_write_b32 a92, 0
	v_accvgpr_write_b32 a93, 0
	v_accvgpr_write_b32 a90, 0
	v_accvgpr_write_b32 a91, 0
	v_accvgpr_write_b32 a88, 0
	v_accvgpr_write_b32 a89, 0
	v_accvgpr_write_b32 a86, 0
	v_accvgpr_write_b32 a87, 0
	v_accvgpr_write_b32 a84, 0
	v_accvgpr_write_b32 a85, 0
	v_accvgpr_write_b32 a82, 0
	v_accvgpr_write_b32 a83, 0
	v_accvgpr_write_b32 a80, 0
	v_accvgpr_write_b32 a81, 0
	v_accvgpr_write_b32 a78, 0
	v_accvgpr_write_b32 a79, 0
	v_accvgpr_write_b32 a76, 0
	v_accvgpr_write_b32 a77, 0
	v_accvgpr_write_b32 a74, 0
	v_accvgpr_write_b32 a75, 0
	v_accvgpr_write_b32 a72, 0
	v_accvgpr_write_b32 a73, 0
	v_accvgpr_write_b32 a70, 0
	v_accvgpr_write_b32 a71, 0
	v_accvgpr_write_b32 a68, 0
	v_accvgpr_write_b32 a69, 0
	v_accvgpr_write_b32 a66, 0
	v_accvgpr_write_b32 a67, 0
	v_mov_b32_e32 v254, 0
	v_mov_b32_e32 v255, 0
	v_mov_b32_e32 v252, 0
	v_mov_b32_e32 v253, 0
	v_mov_b32_e32 v250, 0
	v_mov_b32_e32 v251, 0
	v_mov_b32_e32 v248, 0
	v_mov_b32_e32 v249, 0
	v_mov_b32_e32 v246, 0
	v_mov_b32_e32 v247, 0
	v_mov_b32_e32 v244, 0
	v_mov_b32_e32 v245, 0
	v_mov_b32_e32 v242, 0
	v_mov_b32_e32 v243, 0
	v_mov_b32_e32 v240, 0
	v_mov_b32_e32 v241, 0
	v_mov_b32_e32 v238, 0
	v_mov_b32_e32 v239, 0
	s_mov_b32 s16, 0
	s_mov_b32 s17, 0
.LBB0_2:                                ; =>This Inner Loop Header: Depth=1
	s_add_i32 s16, s16, 1
	s_cmp_lt_i32 s16, 2
	s_cselect_b32 s16, s16, 0
	s_lshl_b32 s27, s16, 14
	s_lshr_b32 s19, s27, 5
	s_add_i32 s17, s17, 1
	s_add_i32 s27, s27, s19
	s_lshl_b32 s19, s17, 7
	s_mov_b32 s33, s3
	s_add_i32 s3, s27, 0x107e0
	s_sub_i32 s19, s14, s19
	v_accvgpr_read_b32 v0, a102
	v_add_u32_e32 v6, 0x80, v6
	s_add_i32 s27, s3, s13
	v_cmp_gt_i32_e32 vcc, s19, v0
	s_mov_b32 m0, s27
	v_add_u32_e32 v8, 0x80, v8
	v_cndmask_b32_e32 v0, -1, v6, vcc
	s_lshl_b32 s19, s16, 15
	; wait_asyncmark(0)
	s_waitcnt vmcnt(9)
	v_add_u32_e32 v10, 0x80, v10
	s_barrier
	buffer_load_dwordx4 v0, s[28:31], 0 offen lds
	s_add_i32 m0, s27, 0x1080
	v_cndmask_b32_e32 v0, -1, v8, vcc
	s_lshr_b32 s34, s19, 5
	v_add_u32_e32 v12, 0x80, v12
	buffer_load_dwordx4 v0, s[28:31], 0 offen lds
	s_add_i32 m0, s27, 0x2100
	v_cndmask_b32_e32 v0, -1, v10, vcc
	s_add_i32 s19, s19, s34
	v_add_u32_e32 v14, 0x80, v14
	buffer_load_dwordx4 v0, s[28:31], 0 offen lds
	s_add_i32 m0, s27, 0x3180
	v_cndmask_b32_e32 v0, -1, v12, vcc
	s_add_i32 s27, s19, s13
	v_add_u32_e32 v160, 0x80, v160
	buffer_load_dwordx4 v0, s[28:31], 0 offen lds
	s_mov_b32 m0, s27
	v_cndmask_b32_e32 v0, -1, v14, vcc
	v_add_u32_e32 v162, 0x80, v162
	; asyncmark
	buffer_load_dwordx4 v0, s[4:7], 0 offen lds
	s_add_i32 m0, s27, 0x1080
	v_cndmask_b32_e32 v0, -1, v160, vcc
	v_add_u32_e32 v164, 0x80, v164
	buffer_load_dwordx4 v0, s[4:7], 0 offen lds
	s_add_i32 m0, s27, 0x2100
	v_cndmask_b32_e32 v0, -1, v162, vcc
	v_add_u32_e32 v166, 0x80, v166
	buffer_load_dwordx4 v0, s[4:7], 0 offen lds
	s_add_i32 m0, s27, 0x3180
	v_cndmask_b32_e32 v0, -1, v164, vcc
	v_add_u32_e32 v168, 0x80, v168
	buffer_load_dwordx4 v0, s[4:7], 0 offen lds
	s_add_i32 m0, s27, 0x4200
	v_cndmask_b32_e32 v0, -1, v166, vcc
	v_add_u32_e32 v170, 0x80, v170
	buffer_load_dwordx4 v0, s[4:7], 0 offen lds
	s_add_i32 m0, s27, 0x5280
	v_cndmask_b32_e32 v0, -1, v168, vcc
	v_add_u32_e32 v172, 0x80, v172
	v_add_u32_e32 v1, s33, v171
	buffer_load_dwordx4 v0, s[4:7], 0 offen lds
	s_add_i32 m0, s27, 0x6300
	v_cndmask_b32_e32 v0, -1, v170, vcc
	v_add3_u32 v1, v1, v173, v177
	buffer_load_dwordx4 v0, s[4:7], 0 offen lds
	s_add_i32 m0, s27, 0x7380
	v_cndmask_b32_e32 v0, -1, v172, vcc
	s_add_i32 s18, s15, s18
	ds_read_b128 v[20:23], v1
	ds_read_b128 v[24:27], v1 offset:64
	ds_read_b128 v[28:31], v1 offset:128
	ds_read_b128 v[32:35], v1 offset:192
	ds_read_b128 v[36:39], v1 offset:256
	ds_read_b128 v[40:43], v1 offset:320
	ds_read_b128 v[44:47], v1 offset:384
	ds_read_b128 v[48:51], v1 offset:448
	ds_read_b128 v[52:55], v1 offset:512
	ds_read_b128 v[56:59], v1 offset:576
	ds_read_b128 v[60:63], v1 offset:640
	ds_read_b128 v[64:67], v1 offset:704
	ds_read_b128 v[68:71], v1 offset:768
	ds_read_b128 v[72:75], v1 offset:832
	ds_read_b128 a[0:3], v1 offset:896
	ds_read_b128 a[4:7], v1 offset:960
	buffer_load_dwordx4 v0, s[4:7], 0 offen lds
	v_add_u32_e32 v0, s18, v171
	v_add3_u32 v0, v0, v173, v177
	; asyncmark
	ds_read_b128 v[76:79], v0
	ds_read_b128 v[80:83], v0 offset:64
	ds_read_b128 a[16:19], v0 offset:512
	ds_read_b128 a[20:23], v0 offset:576
	ds_read_b128 a[24:27], v0 offset:16896
	ds_read_b128 a[28:31], v0 offset:16960
	ds_read_b128 a[8:11], v0 offset:17408
	ds_read_b128 a[12:15], v0 offset:17472
	s_waitcnt lgkmcnt(6)
	v_mfma_f32_16x16x128_f8f6f4 v[0:3], v[76:83], v[20:27], 0
	v_accvgpr_write_b32 a56, v246
	v_accvgpr_write_b32 a57, v247
	v_accvgpr_write_b32 a58, v248
	v_accvgpr_write_b32 a59, v249
	v_accvgpr_write_b32 a48, v238
	v_accvgpr_write_b32 a49, v239
	v_accvgpr_write_b32 a50, v240
	s_waitcnt lgkmcnt(4)
	v_mfma_f32_16x16x128_f8f6f4 v[16:19], a[16:23], v[20:27], 0
	v_accvgpr_write_b32 a51, v241
	v_accvgpr_write_b32 a64, v254
	v_accvgpr_write_b32 a65, v255
	v_accvgpr_write_b32 a60, v250
	s_waitcnt vmcnt(19)
	v_pk_mul_f32 v[230:231], v[188:189], v[0:1] op_sel_hi:[0,1]
	v_pk_mul_f32 v[232:233], v[188:189], v[2:3] op_sel_hi:[0,1]
	v_accvgpr_write_b32 a61, v251
	s_waitcnt lgkmcnt(2)
	v_mfma_f32_16x16x128_f8f6f4 v[0:3], a[24:31], v[20:27], 0
	v_accvgpr_write_b32 a62, v252
	v_accvgpr_write_b32 a63, v253
	v_accvgpr_write_b32 a52, v242
	v_accvgpr_write_b32 a53, v243
	v_mul_f32_e64 v210, v188, v16
	v_mul_f32_e64 v211, v188, v17
	v_pk_mul_f32 v[212:213], v[188:189], v[18:19] op_sel_hi:[0,1]
	v_accvgpr_write_b32 a54, v244
	s_waitcnt lgkmcnt(0)
	v_mfma_f32_16x16x128_f8f6f4 v[16:19], a[8:15], v[20:27], 0
	v_accvgpr_write_b32 a55, v245
	v_add_u32_e32 v169, 1, v169
	v_add_u32_e32 v9, 1, v9
	v_add_u32_e32 v11, 1, v11
	v_mul_f32_e64 v198, v188, v0
	v_mul_f32_e64 v199, v188, v1
	v_pk_mul_f32 v[200:201], v[188:189], v[2:3] op_sel_hi:[0,1]
	v_add_u32_e32 v13, 1, v13
	v_mfma_f32_16x16x128_f8f6f4 v[0:3], v[76:83], v[28:35], 0
	v_add_u32_e32 v15, 1, v15
	v_add_u32_e32 v161, 1, v161
	v_add_u32_e32 v163, 1, v163
	v_add_u32_e32 v165, 1, v165
	v_mul_f32_e64 v190, v188, v16
	v_mul_f32_e64 v191, v188, v17
	v_pk_mul_f32 v[192:193], v[188:189], v[18:19] op_sel_hi:[0,1]
	v_add_u32_e32 v167, 1, v167
	v_mfma_f32_16x16x128_f8f6f4 v[16:19], a[16:23], v[28:35], 0
	s_mov_b32 s18, s19
	s_cmp_lg_u32 s17, 32
	s_waitcnt vmcnt(18)
	v_mul_f32_e64 v246, v186, v0
	v_mul_f32_e64 v247, v186, v1
	v_pk_mul_f32 v[248:249], v[186:187], v[2:3] op_sel_hi:[0,1]
	v_mfma_f32_16x16x128_f8f6f4 v[0:3], a[24:31], v[28:35], 0
	s_nop 4
	v_mul_f32_e64 v222, v186, v16
	v_mul_f32_e64 v223, v186, v17
	v_mul_f32_e64 v224, v186, v18
	v_mul_f32_e64 v225, v186, v19
	v_mfma_f32_16x16x128_f8f6f4 v[16:19], a[8:15], v[28:35], 0
	s_nop 1
	v_mul_f32_e64 v206, v186, v0
	v_mul_f32_e64 v207, v186, v1
	v_mul_f32_e64 v208, v186, v2
	v_mul_f32_e64 v209, v186, v3
	v_mfma_f32_16x16x128_f8f6f4 v[0:3], v[76:83], v[36:43], 0
	s_nop 4
	v_mul_f32_e64 v194, v186, v16
	v_mul_f32_e64 v195, v186, v17
	v_mul_f32_e64 v196, v186, v18
	v_mul_f32_e64 v197, v186, v19
	v_mfma_f32_16x16x128_f8f6f4 v[16:19], a[16:23], v[36:43], 0
	s_waitcnt vmcnt(17)
	s_nop 0
	v_mul_f32_e64 v22, v184, v0
	v_mul_f32_e64 v23, v184, v1
	v_mul_f32_e64 v24, v184, v2
	v_mul_f32_e64 v25, v184, v3
	v_mfma_f32_16x16x128_f8f6f4 v[0:3], a[24:31], v[36:43], 0
	s_nop 4
	v_mul_f32_e64 v238, v184, v16
	v_mul_f32_e64 v239, v184, v17
	v_mul_f32_e64 v240, v184, v18
	v_mul_f32_e64 v241, v184, v19
	v_mfma_f32_16x16x128_f8f6f4 v[16:19], a[8:15], v[36:43], 0
	s_nop 1
	v_mul_f32_e64 v218, v184, v0
	v_mul_f32_e64 v219, v184, v1
	v_mul_f32_e64 v220, v184, v2
	v_mul_f32_e64 v221, v184, v3
	v_mfma_f32_16x16x128_f8f6f4 v[0:3], v[76:83], v[44:51], 0
	s_nop 4
	v_mul_f32_e64 v202, v184, v16
	v_mul_f32_e64 v203, v184, v17
	v_mul_f32_e64 v204, v184, v18
	v_mul_f32_e64 v205, v184, v19
	v_mfma_f32_16x16x128_f8f6f4 v[16:19], a[16:23], v[44:51], 0
	s_waitcnt vmcnt(16)
	s_nop 0
	v_mul_f32_e64 v32, v182, v0
	v_mul_f32_e64 v33, v182, v1
	v_mul_f32_e64 v34, v182, v2
	v_mul_f32_e64 v35, v182, v3
	v_mfma_f32_16x16x128_f8f6f4 v[0:3], a[24:31], v[44:51], 0
	s_nop 4
	v_mul_f32_e64 v254, v182, v16
	v_mul_f32_e64 v255, v182, v17
	v_mul_f32_e64 v16, v182, v18
	v_mul_f32_e64 v17, v182, v19
	v_mfma_f32_16x16x128_f8f6f4 v[18:21], a[8:15], v[44:51], 0
	s_nop 1
	v_mul_f32_e64 v234, v182, v0
	v_mul_f32_e64 v235, v182, v1
	v_mul_f32_e64 v236, v182, v2
	v_mul_f32_e64 v237, v182, v3
	v_mfma_f32_16x16x128_f8f6f4 v[0:3], v[76:83], v[52:59], 0
	s_nop 4
	v_mul_f32_e64 v214, v182, v18
	v_mul_f32_e64 v215, v182, v19
	v_mul_f32_e64 v216, v182, v20
	v_mul_f32_e64 v217, v182, v21
	s_waitcnt vmcnt(15)
	s_nop 1
	v_pk_mul_f32 v[44:45], v[180:181], v[0:1] op_sel_hi:[0,1]
	v_pk_mul_f32 v[46:47], v[180:181], v[2:3] op_sel_hi:[0,1]
	v_mfma_f32_16x16x128_f8f6f4 v[0:3], a[16:23], v[52:59], 0
	s_nop 11
	v_pk_mul_f32 v[30:31], v[180:181], v[0:1] op_sel_hi:[0,1]
	v_pk_mul_f32 v[4:5], v[180:181], v[2:3] op_sel_hi:[0,1]
	v_mfma_f32_16x16x128_f8f6f4 v[0:3], a[24:31], v[52:59], 0
	s_nop 11
	v_pk_mul_f32 v[250:251], v[180:181], v[0:1] op_sel_hi:[0,1]
	v_pk_mul_f32 v[252:253], v[180:181], v[2:3] op_sel_hi:[0,1]
	v_mfma_f32_16x16x128_f8f6f4 v[0:3], a[8:15], v[52:59], 0
	s_nop 11
	v_pk_mul_f32 v[226:227], v[180:181], v[0:1] op_sel_hi:[0,1]
	v_pk_mul_f32 v[228:229], v[180:181], v[2:3] op_sel_hi:[0,1]
	v_mfma_f32_16x16x128_f8f6f4 v[0:3], v[76:83], v[60:67], 0
	v_add_u32_e32 v181, 0x18c00, v175
	s_waitcnt vmcnt(12)
	s_nop 9
	v_pk_mul_f32 v[52:53], v[178:179], v[0:1] op_sel_hi:[0,1]
	v_pk_mul_f32 v[54:55], v[178:179], v[2:3] op_sel_hi:[0,1]
	v_mfma_f32_16x16x128_f8f6f4 v[0:3], a[16:23], v[60:67], 0
	s_nop 11
	v_pk_mul_f32 v[40:41], v[178:179], v[0:1] op_sel_hi:[0,1]
	v_pk_mul_f32 v[42:43], v[178:179], v[2:3] op_sel_hi:[0,1]
	v_mfma_f32_16x16x128_f8f6f4 v[0:3], a[24:31], v[60:67], 0
	s_nop 11
	v_pk_mul_f32 v[26:27], v[178:179], v[0:1] op_sel_hi:[0,1]
	v_pk_mul_f32 v[28:29], v[178:179], v[2:3] op_sel_hi:[0,1]
	v_mfma_f32_16x16x128_f8f6f4 v[0:3], a[8:15], v[60:67], 0
	s_nop 11
	v_pk_mul_f32 v[242:243], v[178:179], v[0:1] op_sel_hi:[0,1]
	v_pk_mul_f32 v[244:245], v[178:179], v[2:3] op_sel_hi:[0,1]
	v_mfma_f32_16x16x128_f8f6f4 v[0:3], v[76:83], v[68:75], 0
	s_nop 11
	v_pk_mul_f32 v[60:61], v[176:177], v[0:1] op_sel_hi:[0,1]
	v_pk_mul_f32 v[62:63], v[176:177], v[2:3] op_sel_hi:[0,1]
	v_mfma_f32_16x16x128_f8f6f4 v[0:3], a[16:23], v[68:75], 0
	s_nop 11
	v_pk_mul_f32 v[48:49], v[176:177], v[0:1] op_sel_hi:[0,1]
	v_pk_mul_f32 v[50:51], v[176:177], v[2:3] op_sel_hi:[0,1]
	v_mfma_f32_16x16x128_f8f6f4 v[0:3], a[24:31], v[68:75], 0
	s_nop 11
	v_pk_mul_f32 v[36:37], v[176:177], v[0:1] op_sel_hi:[0,1]
	v_pk_mul_f32 v[38:39], v[176:177], v[2:3] op_sel_hi:[0,1]
	v_mfma_f32_16x16x128_f8f6f4 v[0:3], a[8:15], v[68:75], 0
	s_nop 11
	v_pk_mul_f32 v[18:19], v[176:177], v[0:1] op_sel_hi:[0,1]
	v_pk_mul_f32 v[20:21], v[176:177], v[2:3] op_sel_hi:[0,1]
	v_mfma_f32_16x16x128_f8f6f4 v[0:3], v[76:83], a[0:7], 0
	v_lshlrev_b32_e32 v76, 2, v161
	v_lshlrev_b32_e32 v77, 2, v163
	v_lshlrev_b32_e32 v78, 2, v165
	v_lshlrev_b32_e32 v79, 2, v167
	s_nop 7
	v_pk_mul_f32 v[64:65], v[174:175], v[0:1] op_sel_hi:[0,1]
	v_pk_mul_f32 v[66:67], v[174:175], v[2:3] op_sel_hi:[0,1]
	v_mfma_f32_16x16x128_f8f6f4 v[0:3], a[16:23], a[0:7], 0
	s_nop 11
	v_pk_mul_f32 v[56:57], v[174:175], v[0:1] op_sel_hi:[0,1]
	v_pk_mul_f32 v[58:59], v[174:175], v[2:3] op_sel_hi:[0,1]
	v_mfma_f32_16x16x128_f8f6f4 v[0:3], a[24:31], a[0:7], 0
	s_nop 11
	v_pk_mul_f32 v[68:69], v[174:175], v[0:1] op_sel_hi:[0,1]
	v_pk_mul_f32 v[70:71], v[174:175], v[2:3] op_sel_hi:[0,1]
	v_mfma_f32_16x16x128_f8f6f4 v[0:3], a[8:15], a[0:7], 0
	v_accvgpr_write_b32 a0, v84
	v_accvgpr_write_b32 a1, v85
	v_accvgpr_write_b32 a2, v86
	v_accvgpr_write_b32 a3, v87
	s_nop 7
	v_pk_mul_f32 v[72:73], v[174:175], v[0:1] op_sel_hi:[0,1]
	v_lshlrev_b32_e32 v0, 2, v169
	v_mov_b32_e32 v1, v179
	buffer_load_dword v179, v0, s[20:23], 0 offen
	v_add_u32_e32 v0, 0x18c00, v7
	ds_write_b32 v0, v1
	v_lshlrev_b32_e32 v0, 2, v9
	v_pk_mul_f32 v[74:75], v[174:175], v[2:3] op_sel_hi:[0,1]
	v_lshlrev_b32_e32 v1, 2, v11
	v_lshlrev_b32_e32 v2, 2, v13
	v_lshlrev_b32_e32 v3, 2, v15
	buffer_load_dword v188, v0, s[8:11], 0 offen
	buffer_load_dword v186, v1, s[8:11], 0 offen
	buffer_load_dword v184, v2, s[8:11], 0 offen
	buffer_load_dword v182, v3, s[8:11], 0 offen
	buffer_load_dword v180, v76, s[8:11], 0 offen
	buffer_load_dword v178, v77, s[8:11], 0 offen
	buffer_load_dword v176, v78, s[8:11], 0 offen
	buffer_load_dword v174, v79, s[8:11], 0 offen
	s_waitcnt lgkmcnt(0)
	s_barrier
	ds_read_b128 v[0:3], v181
	s_waitcnt lgkmcnt(0)
	v_pk_mul_f32 v[230:231], v[230:231], v[0:1]
	v_pk_mul_f32 v[246:247], v[246:247], v[0:1]
	v_pk_mul_f32 v[76:77], v[22:23], v[0:1]
	v_pk_mul_f32 v[78:79], v[24:25], v[2:3]
	v_pk_mul_f32 v[80:81], v[32:33], v[0:1]
	v_pk_mul_f32 v[44:45], v[44:45], v[0:1]
	v_pk_mul_f32 v[32:33], v[52:53], v[0:1]
	v_pk_mul_f32 v[22:23], v[60:61], v[0:1]
	v_pk_mul_f32 v[24:25], v[62:63], v[2:3]
	v_pk_mul_f32 v[0:1], v[64:65], v[0:1]
	ds_read_b128 v[62:65], v181 offset:256
	v_pk_mul_f32 v[82:83], v[34:35], v[2:3]
	v_pk_mul_f32 v[34:35], v[54:55], v[2:3]
	v_pk_add_f32 v[94:95], v[94:95], v[44:45]
	v_accvgpr_read_b32 v44, a100
	s_waitcnt lgkmcnt(0)
	v_pk_mul_f32 v[210:211], v[210:211], v[62:63]
	v_pk_mul_f32 v[212:213], v[212:213], v[64:65]
	v_pk_mul_f32 v[222:223], v[222:223], v[62:63]
	v_pk_mul_f32 v[224:225], v[224:225], v[64:65]
	v_pk_mul_f32 v[238:239], v[238:239], v[62:63]
	v_pk_mul_f32 v[240:241], v[240:241], v[64:65]
	v_pk_mul_f32 v[254:255], v[254:255], v[62:63]
	v_pk_mul_f32 v[84:85], v[16:17], v[64:65]
	v_pk_mul_f32 v[54:55], v[30:31], v[62:63]
	v_pk_mul_f32 v[60:61], v[4:5], v[64:65]
	v_pk_mul_f32 v[52:53], v[40:41], v[62:63]
	v_pk_mul_f32 v[42:43], v[42:43], v[64:65]
	v_pk_mul_f32 v[30:31], v[48:49], v[62:63]
	v_pk_mul_f32 v[40:41], v[50:51], v[64:65]
	v_pk_mul_f32 v[4:5], v[56:57], v[62:63]
	v_pk_mul_f32 v[16:17], v[58:59], v[64:65]
	ds_read_b128 v[62:65], v181 offset:512
	v_accvgpr_read_b32 v45, a101
	v_pk_add_f32 v[44:45], v[44:45], v[60:61]
	v_accvgpr_write_b32 a101, v45
	v_accvgpr_write_b32 a100, v44
	s_waitcnt lgkmcnt(0)
	v_pk_mul_f32 v[86:87], v[198:199], v[62:63]
	v_pk_mul_f32 v[88:89], v[200:201], v[64:65]
	ds_read_b128 v[198:201], v181 offset:768
	v_pk_mul_f32 v[50:51], v[28:29], v[64:65]
	v_pk_mul_f32 v[28:29], v[70:71], v[64:65]
	v_accvgpr_read_b32 v44, a98
	v_accvgpr_read_b32 v45, a99
	s_waitcnt lgkmcnt(0)
	v_pk_mul_f32 v[70:71], v[192:193], v[200:201]
	v_pk_mul_f32 v[192:193], v[194:195], v[198:199]
	v_pk_mul_f32 v[194:195], v[196:197], v[200:201]
	v_pk_mul_f32 v[196:197], v[202:203], v[198:199]
	v_pk_mul_f32 v[202:203], v[204:205], v[200:201]
	v_pk_mul_f32 v[204:205], v[214:215], v[198:199]
	v_pk_mul_f32 v[214:215], v[216:217], v[200:201]
	v_pk_mul_f32 v[216:217], v[226:227], v[198:199]
	v_pk_add_f32 v[44:45], v[44:45], v[216:217]
	v_pk_mul_f32 v[226:227], v[228:229], v[200:201]
	v_accvgpr_write_b32 a99, v45
	v_accvgpr_write_b32 a98, v44
	v_accvgpr_read_b32 v44, a96
	v_accvgpr_read_b32 v45, a97
	v_pk_add_f32 v[44:45], v[44:45], v[226:227]
	v_accvgpr_write_b32 a97, v45
	v_accvgpr_write_b32 a96, v44
	v_accvgpr_read_b32 v44, a94
	v_accvgpr_read_b32 v45, a95
	v_pk_add_f32 v[44:45], v[44:45], v[32:33]
	v_accvgpr_read_b32 v32, a92
	v_accvgpr_read_b32 v33, a93
	v_pk_add_f32 v[32:33], v[32:33], v[34:35]
	v_accvgpr_write_b32 a93, v33
	v_accvgpr_write_b32 a92, v32
	v_accvgpr_read_b32 v32, a90
	v_accvgpr_read_b32 v33, a91
	v_pk_add_f32 v[32:33], v[32:33], v[52:53]
	v_accvgpr_write_b32 a91, v33
	v_accvgpr_write_b32 a90, v32
	v_accvgpr_read_b32 v32, a88
	v_accvgpr_read_b32 v33, a89
	v_pk_add_f32 v[32:33], v[32:33], v[42:43]
	v_pk_mul_f32 v[48:49], v[26:27], v[62:63]
	v_accvgpr_write_b32 a89, v33
	v_accvgpr_write_b32 a88, v32
	v_accvgpr_read_b32 v32, a86
	v_accvgpr_read_b32 v33, a87
	v_pk_add_f32 v[32:33], v[32:33], v[48:49]
	v_accvgpr_write_b32 a87, v33
	v_accvgpr_write_b32 a86, v32
	v_accvgpr_read_b32 v32, a84
	v_accvgpr_read_b32 v33, a85
	v_pk_add_f32 v[32:33], v[32:33], v[50:51]
	v_pk_mul_f32 v[232:233], v[232:233], v[2:3]
	v_pk_mul_f32 v[248:249], v[248:249], v[2:3]
	v_pk_mul_f32 v[46:47], v[46:47], v[2:3]
	v_pk_mul_f32 v[2:3], v[66:67], v[2:3]
	v_pk_mul_f32 v[66:67], v[242:243], v[198:199]
	v_accvgpr_write_b32 a85, v33
	v_accvgpr_write_b32 a84, v32
	v_accvgpr_read_b32 v32, a82
	v_accvgpr_read_b32 v33, a83
	v_pk_add_f32 v[32:33], v[32:33], v[66:67]
	v_pk_mul_f32 v[26:27], v[68:69], v[62:63]
	v_pk_mul_f32 v[68:69], v[190:191], v[198:199]
	v_pk_mul_f32 v[190:191], v[244:245], v[200:201]
	v_accvgpr_write_b32 a83, v33
	v_accvgpr_write_b32 a82, v32
	v_accvgpr_read_b32 v32, a80
	v_accvgpr_read_b32 v33, a81
	v_pk_add_f32 v[32:33], v[32:33], v[190:191]
	v_accvgpr_write_b32 a81, v33
	v_accvgpr_write_b32 a80, v32
	v_accvgpr_read_b32 v32, a78
	v_accvgpr_read_b32 v33, a79
	v_pk_add_f32 v[32:33], v[32:33], v[22:23]
	v_accvgpr_read_b32 v22, a76
	v_accvgpr_read_b32 v23, a77
	v_pk_add_f32 v[22:23], v[22:23], v[24:25]
	v_accvgpr_write_b32 a77, v23
	v_accvgpr_write_b32 a76, v22
	v_accvgpr_read_b32 v22, a74
	v_accvgpr_read_b32 v23, a75
	v_pk_add_f32 v[22:23], v[22:23], v[30:31]
	v_accvgpr_write_b32 a75, v23
	v_accvgpr_write_b32 a74, v22
	v_accvgpr_read_b32 v22, a72
	v_accvgpr_read_b32 v23, a73
	v_pk_add_f32 v[22:23], v[22:23], v[40:41]
	v_pk_mul_f32 v[36:37], v[36:37], v[62:63]
	v_accvgpr_write_b32 a73, v23
	v_accvgpr_write_b32 a72, v22
	v_accvgpr_read_b32 v22, a70
	v_accvgpr_read_b32 v23, a71
	v_pk_add_f32 v[22:23], v[22:23], v[36:37]
	v_pk_mul_f32 v[38:39], v[38:39], v[64:65]
	v_accvgpr_write_b32 a71, v23
	v_accvgpr_write_b32 a70, v22
	v_accvgpr_read_b32 v22, a68
	v_accvgpr_read_b32 v23, a69
	v_pk_add_f32 v[22:23], v[22:23], v[38:39]
	v_pk_mul_f32 v[206:207], v[206:207], v[62:63]
	v_pk_mul_f32 v[218:219], v[218:219], v[62:63]
	v_pk_mul_f32 v[234:235], v[234:235], v[62:63]
	v_pk_mul_f32 v[56:57], v[250:251], v[62:63]
	v_pk_mul_f32 v[62:63], v[18:19], v[198:199]
	v_accvgpr_write_b32 a69, v23
	v_accvgpr_write_b32 a68, v22
	v_accvgpr_read_b32 v22, a66
	v_accvgpr_read_b32 v23, a67
	v_pk_mul_f32 v[208:209], v[208:209], v[64:65]
	v_pk_mul_f32 v[220:221], v[220:221], v[64:65]
	v_pk_mul_f32 v[236:237], v[236:237], v[64:65]
	v_accvgpr_read_b32 v251, a61
	v_accvgpr_read_b32 v250, a60
	v_pk_mul_f32 v[58:59], v[252:253], v[64:65]
	v_accvgpr_read_b32 v253, a63
	v_accvgpr_read_b32 v252, a62
	v_accvgpr_read_b32 v243, a53
	v_accvgpr_read_b32 v242, a52
	v_accvgpr_read_b32 v245, a55
	v_accvgpr_read_b32 v244, a54
	v_pk_mul_f32 v[64:65], v[20:21], v[200:201]
	v_pk_mul_f32 v[18:19], v[72:73], v[198:199]
	v_pk_mul_f32 v[20:21], v[74:75], v[200:201]
	v_pk_add_f32 v[150:151], v[150:151], v[86:87]
	v_accvgpr_read_b32 v87, a3
	v_accvgpr_read_b32 v86, a2
	v_pk_add_f32 v[142:143], v[142:143], v[246:247]
	v_accvgpr_read_b32 v247, a57
	v_accvgpr_read_b32 v246, a56
	v_pk_add_f32 v[140:141], v[140:141], v[248:249]
	v_accvgpr_read_b32 v249, a59
	v_accvgpr_read_b32 v248, a58
	v_pk_add_f32 v[122:123], v[122:123], v[238:239]
	v_accvgpr_read_b32 v239, a49
	v_accvgpr_read_b32 v238, a48
	v_pk_add_f32 v[120:121], v[120:121], v[240:241]
	v_accvgpr_read_b32 v241, a51
	v_accvgpr_read_b32 v240, a50
	v_pk_add_f32 v[106:107], v[106:107], v[254:255]
	v_accvgpr_read_b32 v255, a65
	v_accvgpr_read_b32 v254, a64
	v_pk_add_f32 v[104:105], v[104:105], v[84:85]
	v_accvgpr_read_b32 v85, a1
	v_accvgpr_read_b32 v84, a0
	v_pk_add_f32 v[22:23], v[22:23], v[62:63]
	v_pk_add_f32 v[158:159], v[158:159], v[230:231]
	v_pk_add_f32 v[156:157], v[156:157], v[232:233]
	v_pk_add_f32 v[154:155], v[154:155], v[210:211]
	v_pk_add_f32 v[152:153], v[152:153], v[212:213]
	v_pk_add_f32 v[148:149], v[148:149], v[88:89]
	v_pk_add_f32 v[146:147], v[146:147], v[68:69]
	v_pk_add_f32 v[144:145], v[144:145], v[70:71]
	v_pk_add_f32 v[138:139], v[138:139], v[222:223]
	v_pk_add_f32 v[136:137], v[136:137], v[224:225]
	v_pk_add_f32 v[134:135], v[134:135], v[206:207]
	v_pk_add_f32 v[132:133], v[132:133], v[208:209]
	v_pk_add_f32 v[130:131], v[130:131], v[192:193]
	v_pk_add_f32 v[128:129], v[128:129], v[194:195]
	v_pk_add_f32 v[126:127], v[126:127], v[76:77]
	v_pk_add_f32 v[124:125], v[124:125], v[78:79]
	v_pk_add_f32 v[118:119], v[118:119], v[218:219]
	v_pk_add_f32 v[116:117], v[116:117], v[220:221]
	v_pk_add_f32 v[114:115], v[114:115], v[196:197]
	v_pk_add_f32 v[112:113], v[112:113], v[202:203]
	v_pk_add_f32 v[110:111], v[110:111], v[80:81]
	v_pk_add_f32 v[108:109], v[108:109], v[82:83]
	v_pk_add_f32 v[102:103], v[102:103], v[234:235]
	v_pk_add_f32 v[100:101], v[100:101], v[236:237]
	v_pk_add_f32 v[98:99], v[98:99], v[204:205]
	v_pk_add_f32 v[96:97], v[96:97], v[214:215]
	v_pk_add_f32 v[92:93], v[92:93], v[46:47]
	v_pk_add_f32 v[90:91], v[90:91], v[54:55]
	v_pk_add_f32 v[86:87], v[86:87], v[56:57]
	v_pk_add_f32 v[84:85], v[84:85], v[58:59]
	v_accvgpr_write_b32 a95, v45
	v_accvgpr_write_b32 a94, v44
	v_accvgpr_write_b32 a79, v33
	v_accvgpr_write_b32 a78, v32
	v_accvgpr_write_b32 a67, v23
	v_accvgpr_write_b32 a66, v22
	v_pk_add_f32 v[254:255], v[254:255], v[64:65]
	v_pk_add_f32 v[252:253], v[252:253], v[0:1]
	v_pk_add_f32 v[250:251], v[250:251], v[2:3]
	v_pk_add_f32 v[248:249], v[248:249], v[4:5]
	v_pk_add_f32 v[246:247], v[246:247], v[16:17]
	v_pk_add_f32 v[244:245], v[244:245], v[26:27]
	v_pk_add_f32 v[242:243], v[242:243], v[28:29]
	v_pk_add_f32 v[240:241], v[240:241], v[18:19]
	v_pk_add_f32 v[238:239], v[238:239], v[20:21]
	s_cbranch_scc1 .LBB0_2
; %bb.3:
	v_add_u32_e32 v0, s3, v171
	v_add_u32_e32 v1, s15, v171
	v_add3_u32 v0, v0, v173, v177
	v_add3_u32 v1, v1, v173, v177
	; wait_asyncmark(0)
	s_waitcnt vmcnt(9)
	s_barrier
	ds_read_b128 v[206:209], v1
	ds_read_b128 v[210:213], v1 offset:64
	ds_read_b128 v[198:201], v1 offset:512
	ds_read_b128 v[202:205], v1 offset:576
	ds_read_b128 v[190:193], v1 offset:16896
	ds_read_b128 v[194:197], v1 offset:16960
	ds_read_b128 v[164:167], v1 offset:17408
	ds_read_b128 v[168:171], v1 offset:17472
	ds_read_b128 v[44:47], v0 offset:128
	ds_read_b128 v[48:51], v0 offset:192
	ds_read_b128 v[60:63], v0 offset:256
	ds_read_b128 v[64:67], v0 offset:320
	ds_read_b128 v[8:11], v0
	ds_read_b128 v[12:15], v0 offset:64
	s_waitcnt lgkmcnt(4)
	v_mfma_f32_16x16x128_f8f6f4 v[40:43], v[190:197], v[44:51], 0
	ds_read_b128 v[68:71], v0 offset:384
	ds_read_b128 v[72:75], v0 offset:448
	ds_read_b128 v[76:79], v0 offset:512
	ds_read_b128 v[80:83], v0 offset:576
	ds_read_b128 v[214:217], v0 offset:640
	ds_read_b128 v[218:221], v0 offset:704
	ds_read_b128 v[222:225], v0 offset:768
	ds_read_b128 v[226:229], v0 offset:832
	ds_read_b128 v[230:233], v0 offset:896
	ds_read_b128 v[234:237], v0 offset:960
	v_add_u32_e32 v0, 0x18c00, v7
	s_waitcnt vmcnt(8)
	ds_write_b32 v0, v179
	v_add_u32_e32 v0, 0x18c00, v175
	s_waitcnt lgkmcnt(0)
	s_barrier
	v_mfma_f32_16x16x128_f8f6f4 v[32:35], v[206:213], v[44:51], 0
	s_waitcnt vmcnt(6)
	v_mul_f32_e64 v40, v186, v40
	v_mul_f32_e64 v41, v186, v41
	v_mul_f32_e64 v42, v186, v42
	v_mul_f32_e64 v43, v186, v43
	s_ashr_i32 s0, s0, 31
	v_lshrrev_b32_e32 v161, 2, v175
	v_or_b32_e32 v162, 0xc0, v161
	s_ashr_i32 s13, s12, 31
	v_mfma_f32_16x16x128_f8f6f4 v[36:39], v[198:205], v[44:51], 0
	s_ashr_i32 s27, s26, 31
	v_or_b32_e32 v160, 64, v161
	v_or_b32_e32 v163, 0x80, v161
	s_and_b32 s25, s25, 0xffff
	v_mul_f32_e64 v34, v186, v34
	v_mul_f32_e64 v35, v186, v35
	v_pk_mul_f32 v[32:33], v[186:187], v[32:33] op_sel_hi:[0,1]
	v_mfma_f32_16x16x128_f8f6f4 v[44:47], v[164:171], v[44:51], 0
	s_nop 3
	v_mul_f32_e64 v38, v186, v38
	v_mul_f32_e64 v39, v186, v39
	v_mul_f32_e64 v36, v186, v36
	v_mul_f32_e64 v37, v186, v37
	v_mfma_f32_16x16x128_f8f6f4 v[48:51], v[206:213], v[60:67], 0
	s_nop 2
	v_mul_f32_e64 v46, v186, v46
	v_mul_f32_e64 v47, v186, v47
	v_mul_f32_e64 v44, v186, v44
	v_mul_f32_e64 v45, v186, v45
	v_mfma_f32_16x16x128_f8f6f4 v[16:19], v[206:213], v[8:15], 0
	s_waitcnt vmcnt(5)
	s_nop 2
	v_mul_f32_e64 v48, v184, v48
	v_mul_f32_e64 v49, v184, v49
	v_mul_f32_e64 v50, v184, v50
	v_mul_f32_e64 v51, v184, v51
	v_mfma_f32_16x16x128_f8f6f4 v[20:23], v[198:205], v[8:15], 0
	s_nop 2
	v_mul_f32_e64 v16, v188, v16
	v_mul_f32_e64 v17, v188, v17
	v_mul_f32_e64 v18, v188, v18
	v_mul_f32_e64 v19, v188, v19
	v_mfma_f32_16x16x128_f8f6f4 v[24:27], v[190:197], v[8:15], 0
	s_nop 3
	v_mul_f32_e64 v20, v188, v20
	v_mul_f32_e64 v21, v188, v21
	v_mul_f32_e64 v22, v188, v22
	v_mul_f32_e64 v23, v188, v23
	v_mfma_f32_16x16x128_f8f6f4 v[28:31], v[164:171], v[8:15], 0
	ds_read_b128 v[12:15], v0
	ds_read_b128 v[8:11], v0 offset:256
	ds_read_b128 v[4:7], v0 offset:512
	ds_read_b128 v[0:3], v0 offset:768
	v_mul_f32_e64 v24, v188, v24
	v_mul_f32_e64 v25, v188, v25
	s_waitcnt lgkmcnt(3)
	v_pk_mul_f32 v[48:49], v[48:49], v[12:13]
	v_pk_add_f32 v[48:49], v[126:127], v[48:49]
	s_waitcnt lgkmcnt(1)
	v_pk_mul_f32 v[40:41], v[40:41], v[4:5]
	v_pk_mul_f32 v[42:43], v[42:43], v[6:7]
	v_pk_add_f32 v[40:41], v[134:135], v[40:41]
	v_mfma_f32_16x16x128_f8f6f4 v[52:55], v[198:205], v[60:67], 0
	v_add_f32_e64 v42, v132, v42
	v_add_f32_e64 v43, v133, v43
	s_waitcnt lgkmcnt(0)
	v_mul_f32_e64 v46, v46, v2
	v_mul_f32_e64 v47, v47, v3
	v_pk_add_f32 v[46:47], v[128:129], v[46:47]
	v_pk_mul_f32 v[50:51], v[50:51], v[14:15]
	v_pk_add_f32 v[50:51], v[124:125], v[50:51]
	v_pk_mul_f32 v[44:45], v[44:45], v[0:1]
	v_pk_add_f32 v[44:45], v[130:131], v[44:45]
	v_mfma_f32_16x16x128_f8f6f4 v[132:135], v[206:213], v[68:75], 0
	v_mul_f32_e64 v38, v38, v10
	v_mul_f32_e64 v39, v39, v11
	v_add_f32_e64 v38, v136, v38
	v_add_f32_e64 v39, v137, v39
	v_mul_f32_e64 v36, v36, v8
	v_mul_f32_e64 v37, v37, v9
	v_pk_add_f32 v[36:37], v[138:139], v[36:37]
	v_pk_mul_f32 v[52:53], v[184:185], v[52:53] op_sel_hi:[0,1]
	v_pk_mul_f32 v[52:53], v[52:53], v[8:9]
	v_pk_add_f32 v[52:53], v[122:123], v[52:53]
	v_mfma_f32_16x16x128_f8f6f4 v[56:59], v[190:197], v[60:67], 0
	v_mul_f32_e64 v54, v184, v54
	v_mul_f32_e64 v55, v184, v55
	v_mul_f32_e64 v54, v54, v10
	v_mul_f32_e64 v55, v55, v11
	v_add_f32_e64 v54, v120, v54
	v_add_f32_e64 v55, v121, v55
	v_pk_mul_f32 v[34:35], v[34:35], v[14:15]
	v_pk_add_f32 v[34:35], v[140:141], v[34:35]
	v_pk_mul_f32 v[16:17], v[16:17], v[12:13]
	v_pk_mul_f32 v[32:33], v[32:33], v[12:13]
	v_mfma_f32_16x16x128_f8f6f4 v[126:129], v[198:205], v[68:75], 0
	v_add_f32_e64 v32, v142, v32
	v_add_f32_e64 v33, v143, v33
	v_mul_f32_e64 v18, v18, v14
	v_mul_f32_e64 v19, v19, v15
	v_mul_f32_e64 v20, v20, v8
	v_mul_f32_e64 v21, v21, v9
	v_pk_mul_f32 v[24:25], v[24:25], v[4:5]
	v_pk_mul_f32 v[56:57], v[184:185], v[56:57] op_sel_hi:[0,1]
	v_pk_mul_f32 v[56:57], v[56:57], v[4:5]
	v_pk_add_f32 v[56:57], v[118:119], v[56:57]
	v_mfma_f32_16x16x128_f8f6f4 v[60:63], v[164:171], v[60:67], 0
	s_waitcnt vmcnt(4)
	v_mul_f32_e64 v64, v182, v132
	v_mul_f32_e64 v65, v182, v133
	v_mul_f32_e64 v64, v64, v12
	v_mul_f32_e64 v65, v65, v13
	v_pk_add_f32 v[66:67], v[110:111], v[64:65]
	v_pk_mul_f32 v[64:65], v[182:183], v[134:135] op_sel_hi:[0,1]
	v_pk_mul_f32 v[64:65], v[64:65], v[14:15]
	v_pk_add_f32 v[108:109], v[108:109], v[64:65]
	v_pk_mul_f32 v[64:65], v[182:183], v[126:127] op_sel_hi:[0,1]
	v_mfma_f32_16x16x128_f8f6f4 v[122:125], v[190:197], v[68:75], 0
	v_mul_f32_e64 v64, v64, v8
	v_mul_f32_e64 v65, v65, v9
	v_add_f32_e64 v106, v106, v64
	v_add_f32_e64 v107, v107, v65
	v_mul_f32_e64 v64, v182, v128
	v_mul_f32_e64 v65, v182, v129
	v_pk_mul_f32 v[64:65], v[64:65], v[10:11]
	v_pk_mul_f32 v[60:61], v[184:185], v[60:61] op_sel_hi:[0,1]
	v_pk_mul_f32 v[62:63], v[184:185], v[62:63] op_sel_hi:[0,1]
	v_pk_mul_f32 v[60:61], v[60:61], v[0:1]
	v_mfma_f32_16x16x128_f8f6f4 v[118:121], v[164:171], v[68:75], 0
	v_mul_f32_e64 v62, v62, v2
	v_mul_f32_e64 v63, v63, v3
	v_add_f32_e64 v60, v114, v60
	v_add_f32_e64 v61, v115, v61
	v_add_f32_e64 v62, v112, v62
	v_add_f32_e64 v63, v113, v63
	v_pk_add_f32 v[88:89], v[104:105], v[64:65]
	v_pk_mul_f32 v[64:65], v[182:183], v[122:123] op_sel_hi:[0,1]
	v_pk_mul_f32 v[64:65], v[64:65], v[4:5]
	v_pk_add_f32 v[102:103], v[102:103], v[64:65]
	v_mfma_f32_16x16x128_f8f6f4 v[112:115], v[206:213], v[76:83], 0
	v_mul_f32_e64 v64, v182, v124
	v_mul_f32_e64 v65, v182, v125
	v_mul_f32_e64 v64, v64, v6
	v_mul_f32_e64 v65, v65, v7
	v_add_f32_e64 v104, v100, v64
	v_add_f32_e64 v105, v101, v65
	v_pk_mul_f32 v[58:59], v[184:185], v[58:59] op_sel_hi:[0,1]
	v_pk_mul_f32 v[64:65], v[182:183], v[118:119] op_sel_hi:[0,1]
	v_pk_mul_f32 v[64:65], v[64:65], v[0:1]
	v_pk_add_f32 v[110:111], v[98:99], v[64:65]
	v_mfma_f32_16x16x128_f8f6f4 v[130:133], v[198:205], v[76:83], 0
	v_mul_f32_e64 v64, v182, v120
	v_mul_f32_e64 v65, v182, v121
	v_mul_f32_e64 v58, v58, v6
	v_mul_f32_e64 v59, v59, v7
	v_mul_f32_e64 v64, v64, v2
	v_mul_f32_e64 v65, v65, v3
	v_pk_add_f32 v[58:59], v[116:117], v[58:59]
	v_pk_add_f32 v[116:117], v[96:97], v[64:65]
	s_waitcnt vmcnt(3)
	v_pk_mul_f32 v[64:65], v[180:181], v[112:113] op_sel_hi:[0,1]
	v_pk_mul_f32 v[64:65], v[64:65], v[12:13]
	v_mfma_f32_16x16x128_f8f6f4 v[126:129], v[190:197], v[76:83], 0
	v_add_f32_e64 v112, v94, v64
	v_add_f32_e64 v113, v95, v65
	v_mul_f32_e64 v64, v180, v114
	v_mul_f32_e64 v65, v180, v115
	v_mul_f32_e64 v64, v64, v14
	v_mul_f32_e64 v65, v65, v15
	v_pk_add_f32 v[114:115], v[92:93], v[64:65]
	v_pk_mul_f32 v[64:65], v[180:181], v[130:131] op_sel_hi:[0,1]
	v_pk_mul_f32 v[64:65], v[64:65], v[8:9]
	v_pk_add_f32 v[118:119], v[90:91], v[64:65]
	v_mfma_f32_16x16x128_f8f6f4 v[98:101], v[164:171], v[76:83], 0
	v_mul_f32_e64 v64, v180, v132
	v_mul_f32_e64 v65, v180, v133
	v_mul_f32_e64 v64, v64, v10
	v_mul_f32_e64 v65, v65, v11
	v_accvgpr_read_b32 v68, a100
	v_accvgpr_read_b32 v69, a101
	v_pk_add_f32 v[120:121], v[68:69], v[64:65]
	v_pk_mul_f32 v[64:65], v[180:181], v[126:127] op_sel_hi:[0,1]
	v_pk_mul_f32 v[64:65], v[64:65], v[4:5]
	v_mfma_f32_16x16x128_f8f6f4 v[94:97], v[206:213], v[214:221], 0
	v_add_f32_e64 v122, v86, v64
	v_add_f32_e64 v123, v87, v65
	v_mul_f32_e64 v64, v180, v128
	v_mul_f32_e64 v65, v180, v129
	v_mul_f32_e64 v64, v64, v6
	v_mul_f32_e64 v65, v65, v7
	v_pk_add_f32 v[124:125], v[84:85], v[64:65]
	v_pk_mul_f32 v[64:65], v[180:181], v[98:99] op_sel_hi:[0,1]
	v_pk_mul_f32 v[64:65], v[64:65], v[0:1]
	v_accvgpr_read_b32 v68, a98
	v_mfma_f32_16x16x128_f8f6f4 v[90:93], v[198:205], v[214:221], 0
	v_accvgpr_read_b32 v69, a99
	v_add_f32_e64 v98, v68, v64
	v_add_f32_e64 v99, v69, v65
	v_mul_f32_e64 v64, v180, v100
	v_mul_f32_e64 v65, v180, v101
	v_pk_mul_f32 v[64:65], v[64:65], v[2:3]
	v_accvgpr_read_b32 v68, a96
	v_accvgpr_read_b32 v69, a97
	v_pk_add_f32 v[100:101], v[68:69], v[64:65]
	v_mfma_f32_16x16x128_f8f6f4 v[84:87], v[190:197], v[214:221], 0
	s_waitcnt vmcnt(2)
	v_mul_f32_e64 v64, v178, v94
	v_mul_f32_e64 v65, v178, v95
	v_mul_f32_e64 v64, v64, v12
	v_mul_f32_e64 v65, v65, v13
	v_accvgpr_read_b32 v68, a94
	v_accvgpr_read_b32 v69, a95
	v_pk_add_f32 v[94:95], v[68:69], v[64:65]
	v_pk_mul_f32 v[64:65], v[178:179], v[96:97] op_sel_hi:[0,1]
	v_pk_mul_f32 v[64:65], v[64:65], v[14:15]
	v_accvgpr_read_b32 v68, a92
	v_accvgpr_read_b32 v69, a93
	v_mfma_f32_16x16x128_f8f6f4 v[80:83], v[164:171], v[214:221], 0
	v_add_f32_e64 v96, v68, v64
	v_add_f32_e64 v97, v69, v65
	v_mul_f32_e64 v64, v178, v90
	v_mul_f32_e64 v65, v178, v91
	v_mul_f32_e64 v64, v64, v8
	v_mul_f32_e64 v65, v65, v9
	v_accvgpr_read_b32 v68, a90
	v_accvgpr_read_b32 v69, a91
	v_pk_add_f32 v[90:91], v[68:69], v[64:65]
	v_pk_mul_f32 v[64:65], v[178:179], v[92:93] op_sel_hi:[0,1]
	v_pk_mul_f32 v[64:65], v[64:65], v[10:11]
	v_accvgpr_read_b32 v68, a88
	v_accvgpr_read_b32 v69, a89
	v_mfma_f32_16x16x128_f8f6f4 v[76:79], v[206:213], v[222:229], 0
	v_add_f32_e64 v92, v68, v64
	v_add_f32_e64 v93, v69, v65
	v_mul_f32_e64 v64, v178, v84
	v_mul_f32_e64 v65, v178, v85
	v_mul_f32_e64 v64, v64, v4
	v_mul_f32_e64 v65, v65, v5
	v_accvgpr_read_b32 v68, a86
	v_accvgpr_read_b32 v69, a87
	v_pk_add_f32 v[84:85], v[68:69], v[64:65]
	v_pk_mul_f32 v[64:65], v[178:179], v[86:87] op_sel_hi:[0,1]
	v_pk_mul_f32 v[64:65], v[64:65], v[6:7]
	v_accvgpr_read_b32 v68, a84
	v_accvgpr_read_b32 v69, a85
	v_mfma_f32_16x16x128_f8f6f4 v[70:73], v[198:205], v[222:229], 0
	v_add_f32_e64 v86, v68, v64
	v_add_f32_e64 v87, v69, v65
	v_mul_f32_e64 v64, v178, v80
	v_mul_f32_e64 v65, v178, v81
	v_mul_f32_e64 v64, v64, v0
	v_mul_f32_e64 v65, v65, v1
	v_accvgpr_read_b32 v68, a82
	v_accvgpr_read_b32 v69, a83
	v_pk_add_f32 v[126:127], v[68:69], v[64:65]
	v_pk_mul_f32 v[64:65], v[178:179], v[82:83] op_sel_hi:[0,1]
	v_pk_mul_f32 v[64:65], v[64:65], v[2:3]
	v_accvgpr_read_b32 v68, a80
	v_accvgpr_read_b32 v69, a81
	v_mfma_f32_16x16x128_f8f6f4 v[80:83], v[190:197], v[222:229], 0
	v_add_f32_e64 v128, v68, v64
	v_add_f32_e64 v129, v69, v65
	s_waitcnt vmcnt(1)
	v_mul_f32_e64 v64, v176, v76
	v_mul_f32_e64 v65, v176, v77
	v_pk_mul_f32 v[64:65], v[64:65], v[12:13]
	v_accvgpr_read_b32 v68, a78
	v_accvgpr_read_b32 v69, a79
	v_pk_add_f32 v[130:131], v[68:69], v[64:65]
	v_pk_mul_f32 v[64:65], v[176:177], v[78:79] op_sel_hi:[0,1]
	v_pk_mul_f32 v[64:65], v[64:65], v[14:15]
	v_accvgpr_read_b32 v68, a76
	v_accvgpr_read_b32 v69, a77
	v_mfma_f32_16x16x128_f8f6f4 v[74:77], v[164:171], v[222:229], 0
	v_add_f32_e64 v132, v68, v64
	v_add_f32_e64 v133, v69, v65
	v_mul_f32_e64 v64, v176, v70
	v_mul_f32_e64 v65, v176, v71
	v_mul_f32_e64 v64, v64, v8
	v_mul_f32_e64 v65, v65, v9
	v_accvgpr_read_b32 v68, a74
	v_accvgpr_read_b32 v69, a75
	v_pk_add_f32 v[134:135], v[68:69], v[64:65]
	v_pk_mul_f32 v[64:65], v[176:177], v[72:73] op_sel_hi:[0,1]
	v_pk_mul_f32 v[64:65], v[64:65], v[10:11]
	v_accvgpr_read_b32 v68, a72
	v_accvgpr_read_b32 v69, a73
	v_pk_add_f32 v[136:137], v[68:69], v[64:65]
	v_mfma_f32_16x16x128_f8f6f4 v[68:71], v[206:213], v[230:237], 0
	v_mul_f32_e64 v64, v176, v80
	v_mul_f32_e64 v65, v176, v81
	v_mul_f32_e64 v64, v64, v4
	v_mul_f32_e64 v65, v65, v5
	v_accvgpr_read_b32 v73, a71
	v_accvgpr_read_b32 v72, a70
	v_pk_add_f32 v[80:81], v[72:73], v[64:65]
	v_pk_mul_f32 v[64:65], v[176:177], v[82:83] op_sel_hi:[0,1]
	v_pk_mul_f32 v[64:65], v[64:65], v[6:7]
	v_accvgpr_read_b32 v73, a69
	v_accvgpr_read_b32 v72, a68
	v_pk_add_f32 v[82:83], v[72:73], v[64:65]
	v_pk_mul_f32 v[64:65], v[176:177], v[74:75] op_sel_hi:[0,1]
	v_mfma_f32_16x16x128_f8f6f4 v[72:75], v[198:205], v[230:237], 0
	v_mul_f32_e64 v64, v64, v0
	v_mul_f32_e64 v65, v65, v1
	v_accvgpr_read_b32 v79, a67
	v_accvgpr_read_b32 v78, a66
	v_add_f32_e64 v138, v78, v64
	v_add_f32_e64 v139, v79, v65
	v_pk_mul_f32 v[64:65], v[176:177], v[76:77] op_sel_hi:[0,1]
	v_pk_mul_f32 v[64:65], v[64:65], v[2:3]
	v_pk_add_f32 v[140:141], v[254:255], v[64:65]
	s_waitcnt vmcnt(0)
	v_pk_mul_f32 v[64:65], v[174:175], v[68:69] op_sel_hi:[0,1]
	v_pk_mul_f32 v[12:13], v[64:65], v[12:13]
	v_mfma_f32_16x16x128_f8f6f4 v[76:79], v[190:197], v[230:237], 0
	v_add_f32_e64 v142, v252, v12
	v_add_f32_e64 v143, v253, v13
	v_mul_f32_e64 v12, v174, v70
	v_mul_f32_e64 v13, v174, v71
	v_mul_f32_e64 v12, v12, v14
	v_mul_f32_e64 v13, v13, v15
	v_pk_add_f32 v[70:71], v[250:251], v[12:13]
	v_pk_mul_f32 v[12:13], v[174:175], v[72:73] op_sel_hi:[0,1]
	v_pk_mul_f32 v[8:9], v[12:13], v[8:9]
	v_pk_add_f32 v[72:73], v[248:249], v[8:9]
	v_mfma_f32_16x16x128_f8f6f4 v[12:15], v[164:171], v[230:237], 0
	v_mul_f32_e64 v8, v174, v74
	v_mul_f32_e64 v9, v174, v75
	v_mul_f32_e64 v8, v8, v10
	v_mul_f32_e64 v9, v9, v11
	v_add_f32_e64 v74, v246, v8
	v_add_f32_e64 v75, v247, v9
	v_pk_mul_f32 v[28:29], v[188:189], v[28:29] op_sel_hi:[0,1]
	v_pk_mul_f32 v[8:9], v[174:175], v[76:77] op_sel_hi:[0,1]
	v_pk_mul_f32 v[4:5], v[8:9], v[4:5]
	v_pk_add_f32 v[76:77], v[244:245], v[4:5]
	v_pk_mul_f32 v[4:5], v[174:175], v[78:79] op_sel_hi:[0,1]
	v_pk_mul_f32 v[4:5], v[4:5], v[6:7]
	v_pk_add_f32 v[78:79], v[242:243], v[4:5]
	v_pk_mul_f32 v[28:29], v[28:29], v[0:1]
	v_pk_mul_f32 v[30:31], v[188:189], v[30:31] op_sel_hi:[0,1]
	v_pk_mul_f32 v[4:5], v[174:175], v[12:13] op_sel_hi:[0,1]
	v_pk_mul_f32 v[0:1], v[4:5], v[0:1]
	v_pk_mul_f32 v[4:5], v[174:175], v[14:15] op_sel_hi:[0,1]
	v_pk_mul_f32 v[26:27], v[188:189], v[26:27] op_sel_hi:[0,1]
	v_pk_mul_f32 v[30:31], v[30:31], v[2:3]
	v_pk_mul_f32 v[2:3], v[4:5], v[2:3]
	v_pk_mul_f32 v[22:23], v[22:23], v[10:11]
	v_pk_mul_f32 v[26:27], v[26:27], v[6:7]
	v_pk_add_f32 v[28:29], v[146:147], v[28:29]
	v_pk_add_f32 v[30:31], v[144:145], v[30:31]
	v_pk_add_f32 v[144:145], v[238:239], v[2:3]
	v_cvt_pk_bf16_f32 v69, v46, v47
	v_cvt_pk_bf16_f32 v64, v48, v49
	v_cvt_pk_bf16_f32 v49, v62, v63
	v_cvt_pk_bf16_f32 v46, v66, v67
	v_cvt_pk_bf16_f32 v10, v80, v81
	v_cvt_pk_bf16_f32 v7, v70, v71
	v_cvt_pk_bf16_f32 v4, v72, v73
	v_cvt_pk_bf16_f32 v5, v74, v75
	v_cvt_pk_bf16_f32 v2, v76, v77
	v_cvt_pk_bf16_f32 v3, v78, v79
	v_mov_b32_e32 v63, s0
	v_mov_b32_e32 v67, s0
	v_mov_b32_e32 v71, s0
	v_mov_b32_e32 v73, s0
	v_mov_b32_e32 v75, s0
	v_mov_b32_e32 v77, s0
	v_mov_b32_e32 v79, s0
	v_mov_b32_e32 v81, s0
	s_ashr_i32 s0, s1, 31
	v_pk_add_f32 v[20:21], v[154:155], v[20:21]
	v_pk_add_f32 v[22:23], v[152:153], v[22:23]
	v_cvt_pk_bf16_f32 v152, v28, v29
	v_accvgpr_read_b32 v62, a32
	v_or_b32_e32 v28, s1, v161
	v_mov_b32_e32 v29, s0
	v_pk_add_f32 v[26:27], v[148:149], v[26:27]
	v_cvt_pk_bf16_f32 v148, v20, v21
	v_cvt_pk_bf16_f32 v52, v52, v53
	v_cvt_pk_bf16_f32 v53, v54, v55
	v_accvgpr_read_b32 v66, a34
	v_accvgpr_read_b32 v70, a36
	v_accvgpr_read_b32 v72, a38
	v_accvgpr_read_b32 v74, a40
	v_accvgpr_read_b32 v76, a42
	v_accvgpr_read_b32 v78, a44
	v_accvgpr_read_b32 v80, a46
	v_or_b32_e32 v20, s1, v162
	v_mov_b32_e32 v21, s0
	v_mul_lo_u32 v54, v62, s2
	v_cmp_gt_i64_e64 s[22:23], s[12:13], v[62:63]
	v_cmp_gt_i64_e64 s[6:7], s[26:27], v[28:29]
	v_pk_add_f32 v[16:17], v[158:159], v[16:17]
	v_pk_add_f32 v[18:19], v[156:157], v[18:19]
	v_pk_add_f32 v[24:25], v[150:151], v[24:25]
	v_cvt_pk_bf16_f32 v149, v22, v23
	v_cvt_pk_bf16_f32 v151, v26, v27
	v_or_b32_e32 v26, s1, v160
	v_mov_b32_e32 v27, s0
	v_or_b32_e32 v22, s1, v163
	v_mov_b32_e32 v23, s0
	v_cmp_gt_i64_e64 s[20:21], s[12:13], v[66:67]
	v_cmp_gt_i64_e64 s[18:19], s[12:13], v[70:71]
	v_cmp_gt_i64_e64 s[16:17], s[12:13], v[72:73]
	v_cmp_gt_i64_e64 s[14:15], s[12:13], v[74:75]
	v_cmp_gt_i64_e64 s[10:11], s[12:13], v[76:77]
	v_cmp_gt_i64_e64 s[8:9], s[12:13], v[78:79]
	v_cmp_gt_i64_e32 vcc, s[12:13], v[80:81]
	v_cmp_gt_i64_e64 s[0:1], s[26:27], v[20:21]
	v_add_lshl_u32 v21, v28, v54, 1
	s_and_b64 s[12:13], s[6:7], s[22:23]
	v_cvt_pk_bf16_f32 v146, v16, v17
	v_cvt_pk_bf16_f32 v147, v18, v19
	v_cvt_pk_bf16_f32 v65, v50, v51
	v_cvt_pk_bf16_f32 v50, v56, v57
	v_cvt_pk_bf16_f32 v51, v58, v59
	v_cvt_pk_bf16_f32 v48, v60, v61
	v_mul_lo_u32 v55, v66, s2
	v_mul_lo_u32 v56, v70, s2
	v_mul_lo_u32 v57, v72, s2
	v_mul_lo_u32 v58, v74, s2
	v_mul_lo_u32 v59, v76, s2
	v_mul_lo_u32 v60, v78, s2
	v_mul_lo_u32 v61, v80, s2
	v_cmp_gt_i64_e64 s[4:5], s[26:27], v[26:27]
	v_cmp_gt_i64_e64 s[2:3], s[26:27], v[22:23]
	s_mov_b32 s27, 0x27000
	s_mov_b32 s26, 0x7ffffffe
	v_cndmask_b32_e64 v21, -1, v21, s[12:13]
	buffer_store_dwordx2 v[146:147], v21, s[24:27], 0 offen
	v_add_lshl_u32 v21, v26, v54, 1
	s_and_b64 s[12:13], s[4:5], s[22:23]
	v_cndmask_b32_e64 v21, -1, v21, s[12:13]
	buffer_store_dwordx2 v[148:149], v21, s[24:27], 0 offen
	v_add_lshl_u32 v21, v22, v54, 1
	s_and_b64 s[12:13], s[2:3], s[22:23]
	v_cvt_pk_bf16_f32 v150, v24, v25
	v_cndmask_b32_e64 v21, -1, v21, s[12:13]
	buffer_store_dwordx2 v[150:151], v21, s[24:27], 0 offen
	v_add_lshl_u32 v21, v20, v54, 1
	s_and_b64 s[12:13], s[0:1], s[22:23]
	v_cvt_pk_bf16_f32 v153, v30, v31
	v_cndmask_b32_e64 v21, -1, v21, s[12:13]
	buffer_store_dwordx2 v[152:153], v21, s[24:27], 0 offen
	v_add_lshl_u32 v21, v28, v55, 1
	s_and_b64 s[12:13], s[6:7], s[20:21]
	v_cvt_pk_bf16_f32 v154, v32, v33
	v_cvt_pk_bf16_f32 v155, v34, v35
	v_cndmask_b32_e64 v21, -1, v21, s[12:13]
	buffer_store_dwordx2 v[154:155], v21, s[24:27], 0 offen
	v_add_lshl_u32 v21, v26, v55, 1
	s_and_b64 s[12:13], s[4:5], s[20:21]
	v_cvt_pk_bf16_f32 v156, v36, v37
	v_cvt_pk_bf16_f32 v157, v38, v39
	v_cndmask_b32_e64 v21, -1, v21, s[12:13]
	buffer_store_dwordx2 v[156:157], v21, s[24:27], 0 offen
	v_add_lshl_u32 v21, v22, v55, 1
	s_and_b64 s[12:13], s[2:3], s[20:21]
	v_cvt_pk_bf16_f32 v158, v40, v41
	v_cvt_pk_bf16_f32 v159, v42, v43
	v_cndmask_b32_e64 v21, -1, v21, s[12:13]
	buffer_store_dwordx2 v[158:159], v21, s[24:27], 0 offen
	v_add_lshl_u32 v21, v20, v55, 1
	s_and_b64 s[12:13], s[0:1], s[20:21]
	v_cvt_pk_bf16_f32 v68, v44, v45
	v_cndmask_b32_e64 v21, -1, v21, s[12:13]
	buffer_store_dwordx2 v[68:69], v21, s[24:27], 0 offen
	v_add_lshl_u32 v21, v28, v56, 1
	s_and_b64 s[12:13], s[6:7], s[18:19]
	v_cndmask_b32_e64 v21, -1, v21, s[12:13]
	buffer_store_dwordx2 v[64:65], v21, s[24:27], 0 offen
	v_add_lshl_u32 v21, v26, v56, 1
	s_and_b64 s[12:13], s[4:5], s[18:19]
	v_cndmask_b32_e64 v21, -1, v21, s[12:13]
	buffer_store_dwordx2 v[52:53], v21, s[24:27], 0 offen
	v_add_lshl_u32 v21, v22, v56, 1
	s_and_b64 s[12:13], s[2:3], s[18:19]
	v_cndmask_b32_e64 v21, -1, v21, s[12:13]
	buffer_store_dwordx2 v[50:51], v21, s[24:27], 0 offen
	v_add_lshl_u32 v21, v20, v56, 1
	s_and_b64 s[12:13], s[0:1], s[18:19]
	v_cndmask_b32_e64 v21, -1, v21, s[12:13]
	buffer_store_dwordx2 v[48:49], v21, s[24:27], 0 offen
	v_add_lshl_u32 v21, v28, v57, 1
	s_and_b64 s[12:13], s[6:7], s[16:17]
	v_cvt_pk_bf16_f32 v47, v108, v109
	v_cndmask_b32_e64 v21, -1, v21, s[12:13]
	buffer_store_dwordx2 v[46:47], v21, s[24:27], 0 offen
	v_add_lshl_u32 v21, v26, v57, 1
	s_and_b64 s[12:13], s[4:5], s[16:17]
	v_cvt_pk_bf16_f32 v44, v106, v107
	v_cvt_pk_bf16_f32 v45, v88, v89
	v_cndmask_b32_e64 v21, -1, v21, s[12:13]
	buffer_store_dwordx2 v[44:45], v21, s[24:27], 0 offen
	v_add_lshl_u32 v21, v22, v57, 1
	s_and_b64 s[12:13], s[2:3], s[16:17]
	v_cvt_pk_bf16_f32 v42, v102, v103
	v_cvt_pk_bf16_f32 v43, v104, v105
	v_cndmask_b32_e64 v21, -1, v21, s[12:13]
	buffer_store_dwordx2 v[42:43], v21, s[24:27], 0 offen
	v_add_lshl_u32 v21, v20, v57, 1
	s_and_b64 s[12:13], s[0:1], s[16:17]
	v_cvt_pk_bf16_f32 v40, v110, v111
	v_cvt_pk_bf16_f32 v41, v116, v117
	v_cndmask_b32_e64 v21, -1, v21, s[12:13]
	buffer_store_dwordx2 v[40:41], v21, s[24:27], 0 offen
	v_add_lshl_u32 v21, v28, v58, 1
	s_and_b64 s[12:13], s[6:7], s[14:15]
	v_cvt_pk_bf16_f32 v38, v112, v113
	v_cvt_pk_bf16_f32 v39, v114, v115
	v_cndmask_b32_e64 v21, -1, v21, s[12:13]
	buffer_store_dwordx2 v[38:39], v21, s[24:27], 0 offen
	v_add_lshl_u32 v21, v26, v58, 1
	s_and_b64 s[12:13], s[4:5], s[14:15]
	v_cvt_pk_bf16_f32 v36, v118, v119
	v_cvt_pk_bf16_f32 v37, v120, v121
	v_cndmask_b32_e64 v21, -1, v21, s[12:13]
	buffer_store_dwordx2 v[36:37], v21, s[24:27], 0 offen
	v_add_lshl_u32 v21, v22, v58, 1
	s_and_b64 s[12:13], s[2:3], s[14:15]
	v_cvt_pk_bf16_f32 v34, v122, v123
	v_cvt_pk_bf16_f32 v35, v124, v125
	v_cndmask_b32_e64 v21, -1, v21, s[12:13]
	buffer_store_dwordx2 v[34:35], v21, s[24:27], 0 offen
	v_add_lshl_u32 v21, v20, v58, 1
	s_and_b64 s[12:13], s[0:1], s[14:15]
	v_cvt_pk_bf16_f32 v32, v98, v99
	v_cvt_pk_bf16_f32 v33, v100, v101
	v_cndmask_b32_e64 v21, -1, v21, s[12:13]
	buffer_store_dwordx2 v[32:33], v21, s[24:27], 0 offen
	v_add_lshl_u32 v21, v28, v59, 1
	s_and_b64 s[12:13], s[6:7], s[10:11]
	v_cvt_pk_bf16_f32 v30, v94, v95
	v_cvt_pk_bf16_f32 v31, v96, v97
	v_cndmask_b32_e64 v21, -1, v21, s[12:13]
	buffer_store_dwordx2 v[30:31], v21, s[24:27], 0 offen
	v_add_lshl_u32 v21, v26, v59, 1
	s_and_b64 s[12:13], s[4:5], s[10:11]
	v_cvt_pk_bf16_f32 v24, v90, v91
	v_cvt_pk_bf16_f32 v25, v92, v93
	v_cndmask_b32_e64 v21, -1, v21, s[12:13]
	buffer_store_dwordx2 v[24:25], v21, s[24:27], 0 offen
	v_add_lshl_u32 v21, v22, v59, 1
	s_and_b64 s[12:13], s[2:3], s[10:11]
	v_cvt_pk_bf16_f32 v18, v84, v85
	v_cvt_pk_bf16_f32 v19, v86, v87
	v_cndmask_b32_e64 v21, -1, v21, s[12:13]
	buffer_store_dwordx2 v[18:19], v21, s[24:27], 0 offen
	v_add_lshl_u32 v18, v20, v59, 1
	s_and_b64 s[10:11], s[0:1], s[10:11]
	v_cvt_pk_bf16_f32 v16, v126, v127
	v_cvt_pk_bf16_f32 v17, v128, v129
	v_cndmask_b32_e64 v18, -1, v18, s[10:11]
	buffer_store_dwordx2 v[16:17], v18, s[24:27], 0 offen
	v_add_lshl_u32 v16, v28, v60, 1
	s_and_b64 s[10:11], s[6:7], s[8:9]
	v_cvt_pk_bf16_f32 v14, v130, v131
	v_cvt_pk_bf16_f32 v15, v132, v133
	v_cndmask_b32_e64 v16, -1, v16, s[10:11]
	buffer_store_dwordx2 v[14:15], v16, s[24:27], 0 offen
	v_add_lshl_u32 v14, v26, v60, 1
	s_and_b64 s[10:11], s[4:5], s[8:9]
	v_cvt_pk_bf16_f32 v12, v134, v135
	v_cvt_pk_bf16_f32 v13, v136, v137
	v_cndmask_b32_e64 v14, -1, v14, s[10:11]
	buffer_store_dwordx2 v[12:13], v14, s[24:27], 0 offen
	v_add_lshl_u32 v12, v22, v60, 1
	s_and_b64 s[10:11], s[2:3], s[8:9]
	v_cvt_pk_bf16_f32 v11, v82, v83
	v_cndmask_b32_e64 v12, -1, v12, s[10:11]
	buffer_store_dwordx2 v[10:11], v12, s[24:27], 0 offen
	v_add_lshl_u32 v10, v20, v60, 1
	s_and_b64 s[8:9], s[0:1], s[8:9]
	v_cvt_pk_bf16_f32 v8, v138, v139
	v_cvt_pk_bf16_f32 v9, v140, v141
	v_cndmask_b32_e64 v10, -1, v10, s[8:9]
	buffer_store_dwordx2 v[8:9], v10, s[24:27], 0 offen
	v_add_lshl_u32 v8, v28, v61, 1
	s_and_b64 s[6:7], s[6:7], vcc
	v_cvt_pk_bf16_f32 v6, v142, v143
	v_cndmask_b32_e64 v8, -1, v8, s[6:7]
	buffer_store_dwordx2 v[6:7], v8, s[24:27], 0 offen
	v_add_lshl_u32 v6, v26, v61, 1
	s_and_b64 s[4:5], s[4:5], vcc
	v_cndmask_b32_e64 v6, -1, v6, s[4:5]
	buffer_store_dwordx2 v[4:5], v6, s[24:27], 0 offen
	v_add_lshl_u32 v4, v22, v61, 1
	s_and_b64 s[2:3], s[2:3], vcc
	v_cndmask_b32_e64 v4, -1, v4, s[2:3]
	v_pk_add_f32 v[0:1], v[240:241], v[0:1]
	buffer_store_dwordx2 v[2:3], v4, s[24:27], 0 offen
	v_add_lshl_u32 v2, v20, v61, 1
	s_and_b64 vcc, s[0:1], vcc
	v_cvt_pk_bf16_f32 v0, v0, v1
	v_cvt_pk_bf16_f32 v1, v144, v145
	v_cndmask_b32_e32 v2, -1, v2, vcc
	buffer_store_dwordx2 v[0:1], v2, s[24:27], 0 offen
.LBB0_4:
	s_endpgm
.Lfunc_end0:
	.size	_gemm_a8w8_blockscale_kernel_GROUP_K_128_GROUP_N_128_BLOCK_SIZE_M_128_BLOCK_SIZE_N_256_BLOCK_SIZE_K_128_GROUP_SIZE_M_1_NUM_KSPLIT_1_SPLITK_BLOCK_SIZE_4160_EVEN_K_0_EVEN_SPLITK_1_cache_modifier_NONE, .Lfunc_end0-_gemm_a8w8_blockscale_kernel_GROUP_K_128_GROUP_N_128_BLOCK_SIZE_M_128_BLOCK_SIZE_N_256_BLOCK_SIZE_K_128_GROUP_SIZE_M_1_NUM_KSPLIT_1_SPLITK_BLOCK_SIZE_4160_EVEN_K_0_EVEN_SPLITK_1_cache_modifier_NONE
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel _gemm_a8w8_blockscale_kernel_GROUP_K_128_GROUP_N_128_BLOCK_SIZE_M_128_BLOCK_SIZE_N_256_BLOCK_SIZE_K_128_GROUP_SIZE_M_1_NUM_KSPLIT_1_SPLITK_BLOCK_SIZE_4160_EVEN_K_0_EVEN_SPLITK_1_cache_modifier_NONE
		.amdhsa_group_segment_fixed_size 0
		.amdhsa_private_segment_fixed_size 0
		.amdhsa_kernarg_size 96
		.amdhsa_user_sgpr_count 16
		.amdhsa_user_sgpr_dispatch_ptr 0
		.amdhsa_user_sgpr_queue_ptr 0
		.amdhsa_user_sgpr_kernarg_segment_ptr 1
		.amdhsa_user_sgpr_dispatch_id 0
		.amdhsa_user_sgpr_kernarg_preload_length 14
		.amdhsa_user_sgpr_kernarg_preload_offset 0
		.amdhsa_user_sgpr_private_segment_size 0
		.amdhsa_uses_dynamic_stack 0
		.amdhsa_enable_private_segment 0
		.amdhsa_system_sgpr_workgroup_id_x 1
		.amdhsa_system_sgpr_workgroup_id_y 0
		.amdhsa_system_sgpr_workgroup_id_z 0
		.amdhsa_system_sgpr_workgroup_info 0
		.amdhsa_system_vgpr_workitem_id 0
		.amdhsa_next_free_vgpr 359
		.amdhsa_next_free_sgpr 96
		.amdhsa_accum_offset 256
		.amdhsa_reserve_vcc 1
		.amdhsa_reserve_xnack_mask 1
		.amdhsa_float_round_mode_32 0
		.amdhsa_float_round_mode_16_64 0
		.amdhsa_float_denorm_mode_32 3
		.amdhsa_float_denorm_mode_16_64 3
		.amdhsa_dx10_clamp 1
		.amdhsa_ieee_mode 1
		.amdhsa_fp16_overflow 0
		.amdhsa_tg_split 0
		.amdhsa_exception_fp_ieee_invalid_op 0
		.amdhsa_exception_fp_denorm_src 0
		.amdhsa_exception_fp_ieee_div_zero 0
		.amdhsa_exception_fp_ieee_overflow 0
		.amdhsa_exception_fp_ieee_underflow 0
		.amdhsa_exception_fp_ieee_inexact 0
		.amdhsa_exception_int_div_zero 0
	.end_amdhsa_kernel
	.text
                                        ; -- End function
	.set .L_gemm_a8w8_blockscale_kernel_GROUP_K_128_GROUP_N_128_BLOCK_SIZE_M_128_BLOCK_SIZE_N_256_BLOCK_SIZE_K_128_GROUP_SIZE_M_1_NUM_KSPLIT_1_SPLITK_BLOCK_SIZE_4160_EVEN_K_0_EVEN_SPLITK_1_cache_modifier_NONE.num_vgpr, 256
	.set .L_gemm_a8w8_blockscale_kernel_GROUP_K_128_GROUP_N_128_BLOCK_SIZE_M_128_BLOCK_SIZE_N_256_BLOCK_SIZE_K_128_GROUP_SIZE_M_1_NUM_KSPLIT_1_SPLITK_BLOCK_SIZE_4160_EVEN_K_0_EVEN_SPLITK_1_cache_modifier_NONE.num_agpr, 103
	.set .L_gemm_a8w8_blockscale_kernel_GROUP_K_128_GROUP_N_128_BLOCK_SIZE_M_128_BLOCK_SIZE_N_256_BLOCK_SIZE_K_128_GROUP_SIZE_M_1_NUM_KSPLIT_1_SPLITK_BLOCK_SIZE_4160_EVEN_K_0_EVEN_SPLITK_1_cache_modifier_NONE.numbered_sgpr, 35
	.set .L_gemm_a8w8_blockscale_kernel_GROUP_K_128_GROUP_N_128_BLOCK_SIZE_M_128_BLOCK_SIZE_N_256_BLOCK_SIZE_K_128_GROUP_SIZE_M_1_NUM_KSPLIT_1_SPLITK_BLOCK_SIZE_4160_EVEN_K_0_EVEN_SPLITK_1_cache_modifier_NONE.num_named_barrier, 0
	.set .L_gemm_a8w8_blockscale_kernel_GROUP_K_128_GROUP_N_128_BLOCK_SIZE_M_128_BLOCK_SIZE_N_256_BLOCK_SIZE_K_128_GROUP_SIZE_M_1_NUM_KSPLIT_1_SPLITK_BLOCK_SIZE_4160_EVEN_K_0_EVEN_SPLITK_1_cache_modifier_NONE.private_seg_size, 0
	.set .L_gemm_a8w8_blockscale_kernel_GROUP_K_128_GROUP_N_128_BLOCK_SIZE_M_128_BLOCK_SIZE_N_256_BLOCK_SIZE_K_128_GROUP_SIZE_M_1_NUM_KSPLIT_1_SPLITK_BLOCK_SIZE_4160_EVEN_K_0_EVEN_SPLITK_1_cache_modifier_NONE.uses_vcc, 1
	.set .L_gemm_a8w8_blockscale_kernel_GROUP_K_128_GROUP_N_128_BLOCK_SIZE_M_128_BLOCK_SIZE_N_256_BLOCK_SIZE_K_128_GROUP_SIZE_M_1_NUM_KSPLIT_1_SPLITK_BLOCK_SIZE_4160_EVEN_K_0_EVEN_SPLITK_1_cache_modifier_NONE.uses_flat_scratch, 0
	.set .L_gemm_a8w8_blockscale_kernel_GROUP_K_128_GROUP_N_128_BLOCK_SIZE_M_128_BLOCK_SIZE_N_256_BLOCK_SIZE_K_128_GROUP_SIZE_M_1_NUM_KSPLIT_1_SPLITK_BLOCK_SIZE_4160_EVEN_K_0_EVEN_SPLITK_1_cache_modifier_NONE.has_dyn_sized_stack, 0
	.set .L_gemm_a8w8_blockscale_kernel_GROUP_K_128_GROUP_N_128_BLOCK_SIZE_M_128_BLOCK_SIZE_N_256_BLOCK_SIZE_K_128_GROUP_SIZE_M_1_NUM_KSPLIT_1_SPLITK_BLOCK_SIZE_4160_EVEN_K_0_EVEN_SPLITK_1_cache_modifier_NONE.has_recursion, 0
	.set .L_gemm_a8w8_blockscale_kernel_GROUP_K_128_GROUP_N_128_BLOCK_SIZE_M_128_BLOCK_SIZE_N_256_BLOCK_SIZE_K_128_GROUP_SIZE_M_1_NUM_KSPLIT_1_SPLITK_BLOCK_SIZE_4160_EVEN_K_0_EVEN_SPLITK_1_cache_modifier_NONE.has_indirect_call, 0
	.section	.AMDGPU.csdata,"",@progbits
; Kernel info:
; codeLenInByte = 12168
; TotalNumSgprs: 41
; NumVgprs: 256
; NumAgprs: 103
; TotalNumVgprs: 359
; ScratchSize: 0
; MemoryBound: 0
; FloatMode: 240
; IeeeMode: 1
; LDSByteSize: 0 bytes/workgroup (compile time only)
; SGPRBlocks: 12
; VGPRBlocks: 44
; NumSGPRsForWavesPerEU: 102
; NumVGPRsForWavesPerEU: 359
; AccumOffset: 256
; Occupancy: 1
; WaveLimiterHint : 0
; COMPUTE_PGM_RSRC2:SCRATCH_EN: 0
; COMPUTE_PGM_RSRC2:USER_SGPR: 16
; COMPUTE_PGM_RSRC2:TRAP_HANDLER: 0
; COMPUTE_PGM_RSRC2:TGID_X_EN: 1
; COMPUTE_PGM_RSRC2:TGID_Y_EN: 0
; COMPUTE_PGM_RSRC2:TGID_Z_EN: 0
; COMPUTE_PGM_RSRC2:TIDIG_COMP_CNT: 0
; COMPUTE_PGM_RSRC3_GFX90A:ACCUM_OFFSET: 63
; COMPUTE_PGM_RSRC3_GFX90A:TG_SPLIT: 0
	.text
	.p2alignl 6, 3212836864
	.fill 256, 4, 3212836864
	.section	.AMDGPU.gpr_maximums,"",@progbits
	.set amdgpu.max_num_vgpr, 0
	.set amdgpu.max_num_agpr, 0
	.set amdgpu.max_num_sgpr, 0
	.set amdgpu.max_num_named_barrier, 0
	.text
	.ident	"Triton version 3.9.0+gitfeb5e186"
	.ident	"LLVM version 24.0.0git (18f9e623e4c891ba31ff817c07197707ac9bc593)"
	.section	".note.GNU-stack","",@progbits
	.amdgpu_metadata
---
amdhsa.kernels:
  - .agpr_count:     103
    .args:
      - .address_space:  global
        .offset:         0
        .size:           8
        .value_kind:     global_buffer
      - .address_space:  global
        .offset:         8
        .size:           8
        .value_kind:     global_buffer
      - .address_space:  global
        .offset:         16
        .size:           8
        .value_kind:     global_buffer
      - .address_space:  global
        .offset:         24
        .size:           8
        .value_kind:     global_buffer
      - .address_space:  global
        .offset:         32
        .size:           8
        .value_kind:     global_buffer
      - .offset:         40
        .size:           4
        .value_kind:     by_value
      - .offset:         44
        .size:           4
        .value_kind:     by_value
      - .offset:         48
        .size:           4
        .value_kind:     by_value
      - .offset:         52
        .size:           4
        .value_kind:     by_value
      - .offset:         56
        .size:           4
        .value_kind:     by_value
      - .offset:         60
        .size:           4
        .value_kind:     by_value
      - .offset:         64
        .size:           4
        .value_kind:     by_value
      - .offset:         68
        .size:           4
        .value_kind:     by_value
      - .offset:         72
        .size:           4
        .value_kind:     by_value
      - .address_space:  global
        .offset:         80
        .size:           8
        .value_kind:     global_buffer
      - .address_space:  global
        .offset:         88
        .size:           8
        .value_kind:     global_buffer
    .group_segment_fixed_size: 0
    .kernarg_segment_align: 8
    .kernarg_segment_size: 96
    .max_flat_workgroup_size: 256
    .name:           _gemm_a8w8_blockscale_kernel_GROUP_K_128_GROUP_N_128_BLOCK_SIZE_M_128_BLOCK_SIZE_N_256_BLOCK_SIZE_K_128_GROUP_SIZE_M_1_NUM_KSPLIT_1_SPLITK_BLOCK_SIZE_4160_EVEN_K_0_EVEN_SPLITK_1_cache_modifier_NONE
    .private_segment_fixed_size: 0
    .sgpr_count:     41
    .sgpr_spill_count: 0
    .symbol:         _gemm_a8w8_blockscale_kernel_GROUP_K_128_GROUP_N_128_BLOCK_SIZE_M_128_BLOCK_SIZE_N_256_BLOCK_SIZE_K_128_GROUP_SIZE_M_1_NUM_KSPLIT_1_SPLITK_BLOCK_SIZE_4160_EVEN_K_0_EVEN_SPLITK_1_cache_modifier_NONE.kd
    .uniform_work_group_size: 1
    .uses_dynamic_stack: false
    .vgpr_count:     359
    .vgpr_spill_count: 0
    .wavefront_size: 64
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...

	.end_amdgpu_metadata
