;RUN: llc -march=sparc < %s | FileCheck %s
;RUN: llc -march=sparc -O0 < %s | FileCheck %s -check-prefix=UNOPT


define i32 @test(i32 %a) nounwind {
entry:
; CHECK: test
; CHECK: call bar
; CHECK-NOT: nop
; CHECK: jmp
; CHECK-NEXT: restore
  %0 = tail call i32 @bar(i32 %a) nounwind
  ret i32 %0
}

define i32 @test_jmpl(i32 (i32, i32)* nocapture %f, i32 %a, i32 %b) nounwind {
entry:
; CHECK:      test_jmpl
; CHECK:      call
; CHECK-NOT:  nop
; CHECK:      jmp
; CHECK-NEXT: restore
  %0 = tail call i32 %f(i32 %a, i32 %b) nounwind
  ret i32 %0
}

define i32 @test_loop(i32 %a, i32 %b) nounwind readnone {
; CHECK: test_loop
entry:
  %0 = icmp sgt i32 %b, 0
  br i1 %0, label %bb, label %bb5

bb:                                               ; preds = %entry, %bb
  %a_addr.18 = phi i32 [ %a_addr.0, %bb ], [ %a, %entry ]
  %1 = phi i32 [ %3, %bb ], [ 0, %entry ]
  %tmp9 = mul i32 %1, %b
  %2 = and i32 %1, 1
  %tmp = xor i32 %2, 1
  %.pn = shl i32 %tmp9, %tmp
  %a_addr.0 = add i32 %.pn, %a_addr.18
  %3 = add nsw i32 %1, 1
  %exitcond = icmp eq i32 %3, %b
;CHECK:      subcc
;CHECK:      bne
;CHECK-NOT:  nop
  br i1 %exitcond, label %bb5, label %bb

bb5:                                              ; preds = %bb, %entry
  %a_addr.1.lcssa = phi i32 [ %a, %entry ], [ %a_addr.0, %bb ]
;CHECK:      jmp
;CHECK-NOT: restore
  ret i32 %a_addr.1.lcssa
}

define i32 @test_inlineasm(i32 %a) nounwind {
entry:
;CHECK:      test_inlineasm
;CHECK:      sethi
;CHECK:      !NO_APP
;CHECK-NEXT: subcc
;CHECK-NEXT: bg
;CHECK-NEXT: nop
  tail call void asm sideeffect "sethi 0, %g0", ""() nounwind
  %0 = icmp slt i32 %a, 0
  br i1 %0, label %bb, label %bb1

bb:                                               ; preds = %entry
  %1 = tail call i32 (...)* @foo(i32 %a) nounwind
  ret i32 %1

bb1:                                              ; preds = %entry
  %2 = tail call i32 @bar(i32 %a) nounwind
  ret i32 %2
}

declare i32 @foo(...)

declare i32 @bar(i32)


define i32 @test_implicit_def() nounwind {
entry:
;UNOPT:       test_implicit_def
;UNOPT:       call func
;UNOPT-NEXT:  nop
  %0 = tail call i32 @func(i32* undef) nounwind
  ret i32 0
}

define i32 @prevent_o7_in_call_delay_slot(i32 %i0) {
entry:
;CHECK:       prevent_o7_in_call_delay_slot
;CHECK:       add %i0, 2, %o5
;CHECK:       add %i0, 3, %o7
;CHECK:       add %o5, %o7, %o0
;CHECK:       call bar
;CHECK-NEXT:  nop
  %0 = add nsw i32 %i0, 2
  %1 = add nsw i32 %i0, 3
  tail call void asm sideeffect "", "r,r,~{l0},~{l1},~{l2},~{l3},~{l4},~{l5},~{l6},~{l7},~{i0},~{i1},~{i2},~{i3},~{i4},~{i5},~{i6},~{i7},~{o0},~{o1},~{o2},~{o3},~{o4},~{o6},~{g1},~{g2},~{g3},~{g4},~{g5},~{g6},~{g7}"(i32 %0, i32 %1)
  %2 = add nsw i32 %0, %1
  %3 = tail call i32 @bar(i32 %2)
  ret i32 %3
}


declare i32 @func(i32*)
