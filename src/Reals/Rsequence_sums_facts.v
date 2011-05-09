(*
(C) Copyright 2010, COQTAIL team

Project Info: http://sourceforge.net/projects/coqtail/

This library is free software; you can redistribute it and/or modify it
under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation; either version 2.1 of the License, or
(at your option) any later version.

This library is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public
License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
USA.
*)

Require Import Rsequence_def Rsequence_base_facts.
Require Import Rpser_def Rpser_def_simpl.

Open Scope R_scope.
Open Scope Rseq_scope.

Section Rseq_sum_facts.

Lemma Rseq_sum_simpl : forall Un n,
  (Rseq_sum Un (S n) = Rseq_sum Un n + Un (S n))%R.
Proof.
intros ; reflexivity.
Qed.

Lemma Rseq_sum_ext : forall Un Vn,
  Un == Vn ->
  Rseq_sum Un == Rseq_sum Vn.
Proof.
intros Un Vn Hext n ; induction n.
 apply Hext.
 simpl ; rewrite IHn, Hext ; reflexivity.
Qed.

Lemma Rseq_sum_scal_compat_l : forall (l : R) Un,
  Rseq_sum (l * Un) == l * (Rseq_sum Un).
Proof.
intros l Un n ; induction n.
 reflexivity.
 simpl ; rewrite IHn ;
  unfold Rseq_mult, Rseq_constant ;
  simpl ; ring.
Qed.

Lemma Rseq_sum_scal_compat_r : forall (l : R) Un,
  Rseq_sum (Un * l) == Rseq_sum Un * l.
Proof.
intros l Un n ; induction n.
 reflexivity.
 simpl ; rewrite IHn ;
  unfold Rseq_mult, Rseq_constant ;
  simpl ; ring.
Qed.

Lemma Rseq_sum_opp_compat : forall Un,
  Rseq_sum (- Un) == - Rseq_sum Un.
Proof.
intros Un n ; induction n.
 reflexivity.
 simpl ; rewrite IHn ;
  unfold Rseq_opp ;
  simpl ; ring.
Qed.

Lemma Rseq_sum_plus_compat : forall Un Vn,
  Rseq_sum (Un + Vn) == Rseq_sum Un + Rseq_sum Vn.
Proof.
intros Un Vn n ; induction n.
 reflexivity.
 simpl ; rewrite IHn ;
  unfold Rseq_plus ; simpl ;
  ring.
Qed.

Lemma Rseq_sum_minus_compat : forall Un Vn,
  Rseq_sum (Un - Vn) == Rseq_sum Un - Rseq_sum Vn.
Proof.
intros Un Vn n ; rewrite Rseq_sum_ext with (Un - Vn) (Un + (- Vn)) _,
 Rseq_sum_plus_compat.
 unfold Rseq_plus, Rseq_minus ; rewrite Rseq_sum_opp_compat ; reflexivity.
 unfold Rseq_minus ; intro ; reflexivity.
Qed.

Lemma Rseq_sum_shift_compat : forall Un n,
  Rseq_sum (Rseq_shift Un) n = (Rseq_shift (Rseq_sum Un) n - Un O)%R.
Proof.
intros Un n ; induction n ;
 [| simpl ; rewrite IHn] ;
 unfold Rseq_shift, Rseq_minus ; simpl ; ring.
Qed.

Lemma Rseq_sum_shifts_compat : forall Un k n,
  Rseq_sum (Rseq_shifts Un (S k)) n = (Rseq_shifts (Rseq_sum Un) (S k) n - Rseq_sum Un k)%R.
Proof.
intros Un k n ; induction n.
 unfold Rseq_shifts, Rseq_minus ; simpl ; rewrite plus_0_r ; ring.
 simpl ; rewrite IHn ; unfold Rseq_minus, Rseq_shifts ;
  simpl ; rewrite <- (plus_n_Sm k n) ; simpl ; ring.
Qed.

End Rseq_sum_facts.

Section Rseq_pps_facts.

Lemma Rseq_pps_simpl : forall An x n,
  Rseq_pps An x (S n) = (Rseq_pps An x n + (An (S n) * pow x (S n)))%R.
Proof.
intros ; reflexivity.
Qed.

Lemma Rseq_pps_0_simpl : forall An n,
 Rseq_pps An 0 n = An O.
Proof.
intros An n ; induction n.
 unfold Rseq_pps, gt_pser, Rseq_mult ; simpl ;
  rewrite Rmult_1_r ; reflexivity.
 rewrite Rseq_pps_simpl, IHn, pow_i ; [ring | omega].
Qed.

Lemma Rseq_pps_O_simpl : forall An x,
  Rseq_pps An x O = An O.
Proof.
intros An x ; unfold Rseq_pps ; apply gt_pser_0.
Qed.

Lemma Rseq_pps_ext : forall An Bn x,
  An == Bn ->
  Rseq_pps An x == Rseq_pps Bn x.
Proof.
intros An Bn x Hext ; apply Rseq_sum_ext ;
 intro n ; unfold gt_pser, Rseq_mult ; rewrite Hext ;
 reflexivity.
Qed.

Lemma Rseq_pps_scal_compat_l : forall (l : R) An x,
  Rseq_pps (l * An) x == l * Rseq_pps An x.
Proof.
intros l An x n ; unfold Rseq_pps ;
 rewrite Rseq_sum_ext with _ (l * (An * (pow x))) _.
 apply Rseq_sum_scal_compat_l.
 clear ; intro n ; unfold gt_pser, Rseq_mult, Rseq_constant ;
  ring.
Qed.

Lemma Rseq_pps_scal_compat_r : forall (l : R) An x,
  Rseq_pps (An * l) x == Rseq_pps An x * l.
Proof.
intros l An x n ; unfold Rseq_pps ;
 rewrite Rseq_sum_ext with _ ((An * (pow x)) * l) _.
 apply Rseq_sum_scal_compat_r.
 clear ; intro n ; unfold gt_pser, Rseq_mult, Rseq_constant ;
  ring.
Qed.

Lemma Rseq_pps_opp_compat : forall An x,
  Rseq_pps (- An) x == - Rseq_pps An x.
Proof.
intros An x n ; unfold Rseq_pps ;
 rewrite Rseq_sum_ext with _ (- (An * (pow x))) _.
 apply Rseq_sum_opp_compat.
 clear ; intro n ; unfold gt_pser, Rseq_mult, Rseq_opp ;
  ring.
Qed.

Lemma Rseq_pps_plus_compat : forall An Bn x,
  Rseq_pps (An + Bn) x == Rseq_pps An x + Rseq_pps Bn x.
Proof.
intros An Bn x n ; unfold Rseq_pps ;
 rewrite Rseq_sum_ext with _ ((An * (pow x)) + (Bn * (pow x))) _.
 apply Rseq_sum_plus_compat.
 clear ; intro n ; unfold gt_pser, Rseq_mult, Rseq_plus ;
  ring.
Qed.

Lemma Rseq_pps_abs_unfold : forall An x,
  Rseq_pps_abs An x == Rseq_pps (| An |) (Rabs x).
Proof.
intros An x ; apply Rseq_sum_ext ; apply gt_abs_pser_unfold.
Qed.

(** * Rpser_abs, Rpser *)

Lemma Rpser_abs_unfold : forall An r l,
  Rpser_abs An r l <-> Rpser (| An |) (Rabs r) l.
Proof.
intros An r l ; split ; intro Hyp ; unfold Rpser, Rpser_abs ;
assert (tmp := Rseq_pps_abs_unfold An r) ; eapply Rseq_cv_eq_compat ;
eauto ; symmetry ; assumption.
Qed.

End Rseq_pps_facts.
