// aligned.s and shifted.s differ only by
// the `s_nop 0` before .Lloop (present in shifted.s only). The 320-byte prologue puts .Lloop on a 32-byte boundary in aligned.s.
//
// valu_loop(uint64_t *out, uint32_t iters, uint32_t waves_per_group)
//   Each wave runs `iters` iterations of 64 independent v_pk_mul_f32 and
//   writes the s_memtime cycle count of its loop to out[group * waves_per_group + wave].
	.amdgcn_target "amdgcn-amd-amdhsa--gfx950"
	.amdhsa_code_object_version 5
	.text
	.globl	valu_loop
	.p2align	8
	.type	valu_loop,@function
valu_loop:
	s_load_dwordx4 s[4:7], s[0:1], 0x0          // s[4:5] out, s6 iters, s7 waves_per_group
	v_readfirstlane_b32 s8, v0
	s_lshr_b32 s8, s8, 6                        // s8 = wave index within the group
	v_mov_b32_e32 v0, 1.0
	v_mov_b32_e32 v1, 1.0
	v_mov_b32_e32 v2, 1.0
	v_mov_b32_e32 v3, 1.0
	v_mov_b32_e32 v4, 1.0
	v_mov_b32_e32 v5, 1.0
	v_mov_b32_e32 v6, 1.0
	v_mov_b32_e32 v7, 1.0
	v_mov_b32_e32 v8, 1.0
	v_mov_b32_e32 v9, 1.0
	v_mov_b32_e32 v10, 1.0
	v_mov_b32_e32 v11, 1.0
	v_mov_b32_e32 v12, 1.0
	v_mov_b32_e32 v13, 1.0
	v_mov_b32_e32 v14, 1.0
	v_mov_b32_e32 v15, 1.0
	v_mov_b32_e32 v16, 1.0
	v_mov_b32_e32 v17, 1.0
	v_mov_b32_e32 v18, 1.0
	v_mov_b32_e32 v19, 1.0
	v_mov_b32_e32 v20, 1.0
	v_mov_b32_e32 v21, 1.0
	v_mov_b32_e32 v22, 1.0
	v_mov_b32_e32 v23, 1.0
	v_mov_b32_e32 v24, 1.0
	v_mov_b32_e32 v25, 1.0
	v_mov_b32_e32 v26, 1.0
	v_mov_b32_e32 v27, 1.0
	v_mov_b32_e32 v28, 1.0
	v_mov_b32_e32 v29, 1.0
	v_mov_b32_e32 v30, 1.0
	v_mov_b32_e32 v31, 1.0
	v_mov_b32_e32 v32, 1.0
	v_mov_b32_e32 v33, 1.0
	v_mov_b32_e32 v34, 1.0
	v_mov_b32_e32 v35, 1.0
	v_mov_b32_e32 v36, 1.0
	v_mov_b32_e32 v37, 1.0
	v_mov_b32_e32 v38, 1.0
	v_mov_b32_e32 v39, 1.0
	v_mov_b32_e32 v40, 1.0
	v_mov_b32_e32 v41, 1.0
	v_mov_b32_e32 v42, 1.0
	v_mov_b32_e32 v43, 1.0
	v_mov_b32_e32 v44, 1.0
	v_mov_b32_e32 v45, 1.0
	v_mov_b32_e32 v46, 1.0
	v_mov_b32_e32 v47, 1.0
	v_mov_b32_e32 v48, 1.0
	v_mov_b32_e32 v49, 1.0
	v_mov_b32_e32 v50, 1.0
	v_mov_b32_e32 v51, 1.0
	v_mov_b32_e32 v52, 1.0
	v_mov_b32_e32 v53, 1.0
	v_mov_b32_e32 v54, 1.0
	v_mov_b32_e32 v55, 1.0
	v_mov_b32_e32 v56, 1.0
	v_mov_b32_e32 v57, 1.0
	v_mov_b32_e32 v58, 1.0
	v_mov_b32_e32 v59, 1.0
	v_mov_b32_e32 v60, 1.0
	v_mov_b32_e32 v61, 1.0
	v_mov_b32_e32 v62, 1.0
	v_mov_b32_e32 v63, 1.0
	v_mov_b32_e32 v64, 1.0
	v_mov_b32_e32 v65, 1.0
	v_mov_b32_e32 v66, 1.0
	v_mov_b32_e32 v67, 1.0
	v_mov_b32_e32 v68, 1.0
	v_mov_b32_e32 v69, 1.0
	v_mov_b32_e32 v70, 1.0
	v_mov_b32_e32 v71, 1.0
	s_waitcnt lgkmcnt(0)
	s_memtime s[10:11]
	s_waitcnt lgkmcnt(0)
	s_nop 0                                     // the only difference: +4 bytes
.Lloop:
	v_pk_mul_f32 v[0:1], v[0:1], v[64:65]
	v_pk_mul_f32 v[2:3], v[2:3], v[64:65]
	v_pk_mul_f32 v[4:5], v[4:5], v[64:65]
	v_pk_mul_f32 v[6:7], v[6:7], v[64:65]
	v_pk_mul_f32 v[8:9], v[8:9], v[64:65]
	v_pk_mul_f32 v[10:11], v[10:11], v[64:65]
	v_pk_mul_f32 v[12:13], v[12:13], v[64:65]
	v_pk_mul_f32 v[14:15], v[14:15], v[64:65]
	v_pk_mul_f32 v[16:17], v[16:17], v[64:65]
	v_pk_mul_f32 v[18:19], v[18:19], v[64:65]
	v_pk_mul_f32 v[20:21], v[20:21], v[64:65]
	v_pk_mul_f32 v[22:23], v[22:23], v[64:65]
	v_pk_mul_f32 v[24:25], v[24:25], v[64:65]
	v_pk_mul_f32 v[26:27], v[26:27], v[64:65]
	v_pk_mul_f32 v[28:29], v[28:29], v[64:65]
	v_pk_mul_f32 v[30:31], v[30:31], v[64:65]
	v_pk_mul_f32 v[32:33], v[32:33], v[64:65]
	v_pk_mul_f32 v[34:35], v[34:35], v[64:65]
	v_pk_mul_f32 v[36:37], v[36:37], v[64:65]
	v_pk_mul_f32 v[38:39], v[38:39], v[64:65]
	v_pk_mul_f32 v[40:41], v[40:41], v[64:65]
	v_pk_mul_f32 v[42:43], v[42:43], v[64:65]
	v_pk_mul_f32 v[44:45], v[44:45], v[64:65]
	v_pk_mul_f32 v[46:47], v[46:47], v[64:65]
	v_pk_mul_f32 v[48:49], v[48:49], v[64:65]
	v_pk_mul_f32 v[50:51], v[50:51], v[64:65]
	v_pk_mul_f32 v[52:53], v[52:53], v[64:65]
	v_pk_mul_f32 v[54:55], v[54:55], v[64:65]
	v_pk_mul_f32 v[56:57], v[56:57], v[64:65]
	v_pk_mul_f32 v[58:59], v[58:59], v[64:65]
	v_pk_mul_f32 v[60:61], v[60:61], v[64:65]
	v_pk_mul_f32 v[62:63], v[62:63], v[64:65]
	v_pk_mul_f32 v[0:1], v[0:1], v[64:65]
	v_pk_mul_f32 v[2:3], v[2:3], v[64:65]
	v_pk_mul_f32 v[4:5], v[4:5], v[64:65]
	v_pk_mul_f32 v[6:7], v[6:7], v[64:65]
	v_pk_mul_f32 v[8:9], v[8:9], v[64:65]
	v_pk_mul_f32 v[10:11], v[10:11], v[64:65]
	v_pk_mul_f32 v[12:13], v[12:13], v[64:65]
	v_pk_mul_f32 v[14:15], v[14:15], v[64:65]
	v_pk_mul_f32 v[16:17], v[16:17], v[64:65]
	v_pk_mul_f32 v[18:19], v[18:19], v[64:65]
	v_pk_mul_f32 v[20:21], v[20:21], v[64:65]
	v_pk_mul_f32 v[22:23], v[22:23], v[64:65]
	v_pk_mul_f32 v[24:25], v[24:25], v[64:65]
	v_pk_mul_f32 v[26:27], v[26:27], v[64:65]
	v_pk_mul_f32 v[28:29], v[28:29], v[64:65]
	v_pk_mul_f32 v[30:31], v[30:31], v[64:65]
	v_pk_mul_f32 v[32:33], v[32:33], v[64:65]
	v_pk_mul_f32 v[34:35], v[34:35], v[64:65]
	v_pk_mul_f32 v[36:37], v[36:37], v[64:65]
	v_pk_mul_f32 v[38:39], v[38:39], v[64:65]
	v_pk_mul_f32 v[40:41], v[40:41], v[64:65]
	v_pk_mul_f32 v[42:43], v[42:43], v[64:65]
	v_pk_mul_f32 v[44:45], v[44:45], v[64:65]
	v_pk_mul_f32 v[46:47], v[46:47], v[64:65]
	v_pk_mul_f32 v[48:49], v[48:49], v[64:65]
	v_pk_mul_f32 v[50:51], v[50:51], v[64:65]
	v_pk_mul_f32 v[52:53], v[52:53], v[64:65]
	v_pk_mul_f32 v[54:55], v[54:55], v[64:65]
	v_pk_mul_f32 v[56:57], v[56:57], v[64:65]
	v_pk_mul_f32 v[58:59], v[58:59], v[64:65]
	v_pk_mul_f32 v[60:61], v[60:61], v[64:65]
	v_pk_mul_f32 v[62:63], v[62:63], v[64:65]
	s_sub_u32 s6, s6, 1
	s_cmp_lg_u32 s6, 0
	s_cbranch_scc1 .Lloop
	s_memtime s[12:13]
	s_waitcnt lgkmcnt(0)
	s_sub_u32 s12, s12, s10
	s_subb_u32 s13, s13, s11                    // s[12:13] = loop cycles
	s_mul_i32 s14, s2, s7                       // s2 = workgroup id x
	s_add_u32 s14, s14, s8
	s_lshl_b32 s14, s14, 3
	s_add_u32 s4, s4, s14
	s_addc_u32 s5, s5, 0
	v_mov_b32_e32 v0, 0
	v_mov_b32_e32 v2, s12
	v_mov_b32_e32 v3, s13
	s_mov_b64 exec, 1
	global_store_dwordx2 v0, v[2:3], s[4:5]
	s_endpgm
.Lfunc_end:
	.size	valu_loop, .Lfunc_end-valu_loop

	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel valu_loop
		.amdhsa_group_segment_fixed_size 0
		.amdhsa_private_segment_fixed_size 0
		.amdhsa_kernarg_size 16
		.amdhsa_user_sgpr_count 2
		.amdhsa_user_sgpr_kernarg_segment_ptr 1
		.amdhsa_system_sgpr_workgroup_id_x 1
		.amdhsa_system_vgpr_workitem_id 0
		.amdhsa_next_free_vgpr 72
		.amdhsa_next_free_sgpr 16
		.amdhsa_accum_offset 72
		.amdhsa_reserve_vcc 0
	.end_amdhsa_kernel

	.amdgpu_metadata
---
amdhsa.kernels:
  - .agpr_count:     0
    .args:
      - .address_space:  global
        .offset:         0
        .size:           8
        .value_kind:     global_buffer
      - .offset:         8
        .size:           4
        .value_kind:     by_value
      - .offset:         12
        .size:           4
        .value_kind:     by_value
    .group_segment_fixed_size: 0
    .kernarg_segment_align: 8
    .kernarg_segment_size: 16
    .max_flat_workgroup_size: 1024
    .name:           valu_loop
    .private_segment_fixed_size: 0
    .sgpr_count:     16
    .symbol:         valu_loop.kd
    .vgpr_count:     72
    .wavefront_size: 64
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
