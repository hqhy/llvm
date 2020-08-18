; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn-amd-amdhsa -mcpu=gfx908 -verify-machineinstrs < %s | FileCheck -enable-var-scope -check-prefixes=GFX908 %s

define void @global_atomic_fadd_f32(float addrspace(1)* %ptr, float %data) {
; GFX908-LABEL: global_atomic_fadd_f32:
; GFX908:       ; %bb.0:
; GFX908-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX908-NEXT:    global_atomic_add_f32 v[0:1], v2, off
; GFX908-NEXT:    s_waitcnt vmcnt(0)
; GFX908-NEXT:    s_setpc_b64 s[30:31]
  call void @llvm.amdgcn.global.atomic.fadd.p1f32.f32(float addrspace(1)* %ptr, float %data)
  ret void
}

define void @global_atomic_fadd_f32_off_2048(float addrspace(1)* %ptr, float %data) {
; GFX908-LABEL: global_atomic_fadd_f32_off_2048:
; GFX908:       ; %bb.0:
; GFX908-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX908-NEXT:    s_movk_i32 s4, 0x800
; GFX908-NEXT:    s_mov_b32 s5, 0
; GFX908-NEXT:    v_mov_b32_e32 v3, s4
; GFX908-NEXT:    v_mov_b32_e32 v4, s5
; GFX908-NEXT:    v_add_co_u32_e32 v0, vcc, v0, v3
; GFX908-NEXT:    v_addc_co_u32_e32 v1, vcc, v1, v4, vcc
; GFX908-NEXT:    global_atomic_add_f32 v[0:1], v2, off
; GFX908-NEXT:    s_waitcnt vmcnt(0)
; GFX908-NEXT:    s_setpc_b64 s[30:31]
  %gep = getelementptr float, float addrspace(1)* %ptr, i64 512
  call void @llvm.amdgcn.global.atomic.fadd.p1f32.f32(float addrspace(1)* %gep, float %data)
  ret void
}

define void @global_atomic_fadd_f32_off_neg2047(float addrspace(1)* %ptr, float %data) {
; GFX908-LABEL: global_atomic_fadd_f32_off_neg2047:
; GFX908:       ; %bb.0:
; GFX908-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX908-NEXT:    s_mov_b32 s4, 0xfffff804
; GFX908-NEXT:    s_mov_b32 s5, -1
; GFX908-NEXT:    v_mov_b32_e32 v3, s4
; GFX908-NEXT:    v_mov_b32_e32 v4, s5
; GFX908-NEXT:    v_add_co_u32_e32 v0, vcc, v0, v3
; GFX908-NEXT:    v_addc_co_u32_e32 v1, vcc, v1, v4, vcc
; GFX908-NEXT:    global_atomic_add_f32 v[0:1], v2, off
; GFX908-NEXT:    s_waitcnt vmcnt(0)
; GFX908-NEXT:    s_setpc_b64 s[30:31]
  %gep = getelementptr float, float addrspace(1)* %ptr, i64 -511
  call void @llvm.amdgcn.global.atomic.fadd.p1f32.f32(float addrspace(1)* %gep, float %data)
  ret void
}

define amdgpu_kernel void @global_atomic_fadd_f32_off_ss(float addrspace(1)* %ptr, float %data) {
; GFX908-LABEL: global_atomic_fadd_f32_off_ss:
; GFX908:       ; %bb.0:
; GFX908-NEXT:    s_load_dwordx2 s[0:1], s[4:5], 0x0
; GFX908-NEXT:    s_load_dword s2, s[4:5], 0x8
; GFX908-NEXT:    s_waitcnt lgkmcnt(0)
; GFX908-NEXT:    s_add_u32 s0, s0, 0x800
; GFX908-NEXT:    s_addc_u32 s1, s1, 0
; GFX908-NEXT:    v_mov_b32_e32 v0, s0
; GFX908-NEXT:    v_mov_b32_e32 v1, s1
; GFX908-NEXT:    v_mov_b32_e32 v2, s2
; GFX908-NEXT:    global_atomic_add_f32 v[0:1], v2, off
; GFX908-NEXT:    s_endpgm
  %gep = getelementptr float, float addrspace(1)* %ptr, i64 512
  call void @llvm.amdgcn.global.atomic.fadd.p1f32.f32(float addrspace(1)* %gep, float %data)
  ret void
}

define void @global_atomic_fadd_v2f16(<2 x half> addrspace(1)* %ptr, <2 x half> %data) {
; GFX908-LABEL: global_atomic_fadd_v2f16:
; GFX908:       ; %bb.0:
; GFX908-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX908-NEXT:    global_atomic_pk_add_f16 v[0:1], v2, off
; GFX908-NEXT:    s_waitcnt vmcnt(0)
; GFX908-NEXT:    s_setpc_b64 s[30:31]
  call void @llvm.amdgcn.global.atomic.fadd.p1v2f16.v2f16(<2 x half> addrspace(1)* %ptr, <2 x half> %data)
  ret void
}

define void @global_atomic_fadd_v2f16_off_neg2047(<2 x half> addrspace(1)* %ptr, <2 x half> %data) {
; GFX908-LABEL: global_atomic_fadd_v2f16_off_neg2047:
; GFX908:       ; %bb.0:
; GFX908-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX908-NEXT:    s_mov_b32 s4, 0xfffff804
; GFX908-NEXT:    s_mov_b32 s5, -1
; GFX908-NEXT:    v_mov_b32_e32 v3, s4
; GFX908-NEXT:    v_mov_b32_e32 v4, s5
; GFX908-NEXT:    v_add_co_u32_e32 v0, vcc, v0, v3
; GFX908-NEXT:    v_addc_co_u32_e32 v1, vcc, v1, v4, vcc
; GFX908-NEXT:    global_atomic_pk_add_f16 v[0:1], v2, off
; GFX908-NEXT:    s_waitcnt vmcnt(0)
; GFX908-NEXT:    s_setpc_b64 s[30:31]
  %gep = getelementptr <2 x half>, <2 x half> addrspace(1)* %ptr, i64 -511
  call void @llvm.amdgcn.global.atomic.fadd.p1v2f16.v2f16(<2 x half> addrspace(1)* %gep, <2 x half> %data)
  ret void
}

declare void @llvm.amdgcn.global.atomic.fadd.p1f32.f32(float addrspace(1)* nocapture, float) #0
declare void @llvm.amdgcn.global.atomic.fadd.p1v2f16.v2f16(<2 x half> addrspace(1)* nocapture, <2 x half>) #0

attributes #0 = { argmemonly nounwind willreturn }
