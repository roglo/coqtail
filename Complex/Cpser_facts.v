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

Require Import Rpser_facts.
Require Import Rsequence.
Require Import Rsequence_facts.
Require Import Csequence.
Require Import Rseries.
Require Import Tools.
Require Import Rseries_facts.
Require Import Cpser_def.
Require Import Csequence.
Require Import Csequence_facts.
Require Import Cmet.
Require Import Cnorm.
Require Import Cprop_base.

Open Local Scope C_scope.

Lemma Rseq_norm_abs_Cre : 
forall (An : nat -> C), {l | Rseq_cv (fun n => sum_f_R0 (fun n =>(Cnorm (An n))) n) l} -> 
{l | Rseq_cv (fun n => sum_f_R0 (fun n =>(Rabs (Cre (An n))))n) l}.
Proof.
intros An H.
apply Rseries_CV_comp with (fun n0 : nat => Cnorm (An n0)) .
intros n. split.
apply Rabs_pos. 
apply Cre_le_Cnorm.
exact H.
Qed.

Lemma Rseq_norm_abs_Cim : 
forall (An : nat -> C), {l | Rseq_cv (fun n => sum_f_R0 (fun n =>(Cnorm (An n)))n) l} -> 
{l | Rseq_cv (fun n => sum_f_R0 (fun n =>(Rabs (Cim (An n))))n) l}.
Proof.
intros An H.
apply Rseries_CV_comp with (fun n0 : nat => Cnorm (An n0)) .
intros n. split.
apply Rabs_pos. 
apply Cim_le_Cnorm.
exact H.
Qed.

Lemma Cseq_norm_Rseq :
forall (An : nat -> C), {l | Rseq_cv (fun n => sum_f_R0 (fun n =>(Cnorm (An n)))n) l} -> 
{l | Cseq_cv (fun n => sum_f_C0 (fun n =>((An n)))n) l}.
Proof.
intros An H.
generalize (Rseq_norm_abs_Cim An H).
generalize (Rseq_norm_abs_Cre An H).
intros Hre Him.
assert ( H1 : {l : R |
      Rseq_cv
        (fun n : nat => sum_f_R0 (fun n0 : nat => Cim (An n0)) n) l}).
apply (Rser_abs_cv_cv  (fun n0 : nat => Cim (An n0))).
unfold Rser_abs_cv.
unfold Rseq_abs.
apply Him.
assert ( H2 : {l : R |
      Rseq_cv
        (fun n : nat => sum_f_R0 (fun n0 : nat => Cre (An n0)) n) l}).
apply (Rser_abs_cv_cv  (fun n0 : nat => Cre (An n0))).
unfold Rser_abs_cv.
unfold Rseq_abs.
apply Hre.
destruct H1 as (lim, H1).
destruct H2 as (lre, H2).
exists (lre +i lim).
apply <- Cseq_Rseq_Rseq_equiv.
split. simpl.
assert ((fun n : nat => Cre (sum_f_C0 (fun n0 : nat => An n0) n)) ==
(fun n : nat => sum_f_R0 (fun n0 : nat => Cre (An n0)) n)).
unfold "==".
intros n. rewrite <- sum_f_C0_Cre_compat. reflexivity.
apply (Rseq_cv_eq_compat (fun n : nat => sum_f_R0 (fun n0 : nat => Cre (An n0)) n)
(fun n : nat => Cre (sum_f_C0 (fun n0 : nat => An n0) n))).
apply Rseq_eq_sym. assumption.
assumption.
assert ((fun n : nat => Cim (sum_f_C0 (fun n0 : nat => An n0) n)) ==
(fun n : nat => sum_f_R0 (fun n0 : nat => Cim (An n0)) n)).
unfold "==".
intros n. rewrite <- sum_f_C0_Cim_compat. reflexivity.
apply (Rseq_cv_eq_compat (fun n : nat => sum_f_R0 (fun n0 : nat => Cim (An n0)) n)
(fun n : nat => Cim (sum_f_C0 (fun n0 : nat => An n0) n))).
apply Rseq_eq_sym. assumption.
assumption.
Qed.
 

Lemma Cpser_abel : forall (An : nat -> C) (r : R), 
     Cv_radius_weak An r -> forall x, Cnorm x < r -> {l | Pser An x l}.
Proof.
intros An r Rho x x_ub.
 case (Req_or_neq r) ; intro r_0.
 exists 0 ; apply False_ind ; rewrite r_0 in x_ub ; assert (0 <= Cnorm x). apply Cnorm_pos. fourier.
assert (Hrew_abs : (Cnorm (x / r) = Cnorm x / r)%R).
 unfold Cdiv, Rdiv ; rewrite Cnorm_Cmult ; apply Rmult_eq_compat_l ;
 replace (/r) with (IRC (/r)). rewrite Cnorm_IRC_Rabs.
 apply Rabs_right.
 left ; apply Rinv_0_lt_compat ; apply Rle_lt_trans with (Cnorm x) ;
 [apply Cnorm_pos | assumption].
 CusingR_f ; assumption.
assert (Rabsx_r_lt_1 : Cnorm x / r < 1).
 apply Rle_lt_trans with (Cnorm x / r * (r / r))%R.
 right ; field ; assumption.
 replace 1%R with (r / r)%R by (field ; assumption).
 unfold Rdiv ; rewrite <- Rmult_assoc.
 apply Rmult_lt_compat_r.
 apply Rinv_0_lt_compat ; apply Rle_lt_trans with (Cnorm x) ;
 [apply Cnorm_pos | assumption].
 rewrite Rmult_assoc ; rewrite Rinv_l ; [| assumption] ; rewrite Rmult_1_r ; assumption.

 assert (Rho' : Rpser_def.Cv_radius_weak (fun n : nat => Cnorm (An n)) r).
 destruct Rho as [M HM] ; exists M.
 intros u [n Hn] ; rewrite Hn ; unfold gt_abs_Pser.
 unfold gt_norm_Pser in HM.
 replace (Rabs (Cnorm (An n) * r ^ n))%R with (Cnorm (An n * r ^ n))%R.
 apply HM ; exists n ; reflexivity.
 rewrite Rabs_mult ; replace (Rabs (r ^ n))%R with (Rabs (Cnorm r ^ n))%R.
 rewrite <- Rabs_mult, <- Cnorm_pow, <- Cnorm_Cmult, Rabs_Cnorm ; reflexivity.
 rewrite <- Cnorm_pow, IRC_pow_compat, Cnorm_IRC_Rabs, Rabs_Rabsolu ;
 reflexivity.
 rewrite <- Rabs_Cnorm in x_ub.
 assert (Cnorm_cauchy := Cauchy_crit_partial_sum
    (fun n => Cnorm (An n)) r Rho' (Cnorm x) x_ub).

assert (T : Rseries.Cauchy_crit (sum_f_R0 (fun n : nat => Cnorm (An n * x ^ n)))).
 intros eps eps_pos ; destruct (Cnorm_cauchy eps eps_pos) as [N HN] ;
 exists N ; intros m n m_lb n_lb.
 
assert (Hrew : forall An x n, sum_f_R0 (fun n0 : nat => Cnorm (An n0 * x ^ n0)) n
      = sum_f_R0 (Rpser_def.gt_Pser (fun n0 : nat => Cnorm (An n0)) (Cnorm x)) n).
 clear ; intros An x n ; induction n.
 unfold Rpser_def.gt_Pser ; simpl ; rewrite Cnorm_Cmult, Cnorm_C1 ;
 reflexivity.
 simpl sum_f_R0 ; rewrite IHn ; apply Rplus_eq_compat_l ;
 unfold Rpser_def.gt_Pser ; simpl ; repeat rewrite Cnorm_Cmult ;
 rewrite Cnorm_pow ; reflexivity.
repeat rewrite Hrew ; rewrite R_dist_sym ; apply HN ; assumption.

 destruct (Cseq_norm_Rseq (fun n => An n * x ^ n) (R_complete _ T)) as [l Hl] ;
 exists l ; apply Hl.
Qed.

(** Definition of the sum of a power serie (0 outside the cv-disc) and proof that it's really the sum *)

Definition sum_r (An : nat -> C) (r : R) (Pr : Cv_radius_weak An r) : C -> C.
Proof.
intros An r Rho x.
 case (Rlt_le_dec (Cnorm x) r) ; intro x_bd.
 destruct (Cpser_abel _ _ Rho _ x_bd) as [y _] ; exact y.
 exact 0.
Defined.

Lemma sum_r_sums : forall (An : nat -> C) (r : R) (Pr : Cv_radius_weak An r) (x : C),
      Cnorm x < r -> Pser An x (sum_r An r Pr x).
Proof.
intros An r Pr x x_bd.
 unfold sum_r ; case (Rlt_le_dec (Cnorm x) r) ; intro s.
 destruct (Cpser_abel An r Pr x s) as (l,Hl) ; simpl ; assumption.
 apply False_ind ; fourier.
Qed.
   
(** Abel's lemma : Normal convergence of the power serie *)
(*
Lemma Cpser_abel2_prelim : forall (An : nat -> C) (r : R), 
     Cv_radius_weak An r -> forall x, Cnorm x < r ->
     { l | Pser_norm An x l}.
Proof.
intros An r Rho x x_bd.
 assert (Rho' := Cv_radius_weak_Cnorm_compat An r Rho).
 pose (l := sum_r (fun n => Cnorm (An n)) r Rho' (Cnorm x)).
 assert (R : Rpser_def.Cv_radius_weak (fun n => Cnorm (An n)) r).
 pose (Rho'' := Rho') ; destruct Rho'' as [B HB] ; exists B ; intros u Hu ;
 destruct Hu as [n Hn] ; rewrite Hn ; unfold gt_abs_Pser ; unfold gt_norm_Pser in HB.
 apply Rle_trans with (Rabs (Cnorm (An n * r ^ n))).
 right ; apply Rabs_eq_compat ; rewrite Cnorm_Cmult ; apply Rmult_eq_compat_l.
 rewrite Cnorm_pow ; rewrite Cnorm_IRC_Rabs, Rabs_right.
 reflexivity.
 apply Rle_ge ; apply Rle_trans with (Cnorm x) ; [apply Cnorm_pos | left ; assumption].
 rewrite <- Cnorm_IRC_Rabs ; apply HB.
 exists n.
 apply Cnorm_eq_compat ; rewrite Cnorm_Cmult, Cnorm_pow.
 rewrite Cnorm_IRC_Rabs, Rabs_right, Cmult_IRC_Rmult, IRC_pow_compat.
 reflexivity.
 apply Rle_ge ; apply Rle_trans with (Cnorm x) ; [apply Cnorm_pos | left ; assumption].
 pose (l' := Rpser_facts.sum_r (fun n => Cnorm (An n)) r R (Cnorm x)).
 exists l'.
 rewrite <- Cnorm_invol, Cnorm_IRC_Rabs in x_bd.
 assert (H := Rpser_facts.sum_r_sums (fun n => Cnorm (An n))
 r R (Cnorm x) x_bd).
 intros eps eps_pos ; destruct (H eps eps_pos) as [N HN] ;
 exists N ; intros n n_lb ; simpl ; unfold C_dist.
 apply Rle_lt_trans with (

Qed.
*)
Lemma Cpser_abel2 : forall (An : nat -> C) (r : R), 
     Cv_radius_weak An r -> forall r0 : posreal, r0 < r ->
     CVN_r (fun n x => gt_Pser An x n) r0.
Proof.
intros An r Pr r0 r0_ub.
 destruct r0 as (a,a_pos).
 assert (a_bd : Rabs a < r).
  rewrite Rabs_right ; [| apply Rgt_ge ; apply Rlt_gt] ; assumption.
 assert (r_pos : 0 < r). 
  apply Rlt_trans with a ; assumption.
 assert (r'_bd : Rabs ((a + r) / 2) < r).
  rewrite Rabs_right.
  assert (Hrew : r = ((r+r)/2)%R) by field ; rewrite Hrew at 2; unfold Rdiv ;
  apply Rmult_lt_compat_r ; [apply Rinv_0_lt_compat ; intuition |] ;
  apply Rplus_lt_compat_r ; rewrite Rabs_right in a_bd ; intuition.
  apply Rle_ge ; unfold Rdiv ; replace 0%R with (0 * /2)%R by field ;
  apply Rmult_le_compat_r ; fourier.
 assert (r'_bd2 : Cnorm (Rabs ((a + r) / 2)) < r).
 rewrite Cnorm_IRC_Rabs, Rabs_Rabsolu ; assumption.
 assert (Pr' := Cv_radius_weak_Cnorm_compat _ _ Pr).
 exists (gt_abs_Pser (fun n => Cnorm (An n)) ((a+r)/2)) ;
 exists (sum_r (fun n => Cnorm (An n)) r Pr' (Rabs ((a+r)/2))) ; split.
 assert (H := sum_r_sums (fun n => Cnorm (An n)) r Pr' (Rabs ((a + r) / 2)) r'_bd2).
 assert (Main := Pser_Cseqcv_link _ _ _ H).
 intros eps eps_pos ; destruct (Main eps eps_pos) as (N, HN) ; exists N.
  assert (Hrew : forall k, IRC (Cnorm (gt_abs_Pser (fun n => Cnorm (An n)) ((a + r) / 2) k))
  = gt_Pser (fun n0 : nat => Cnorm (An n0)) (Rabs ((a + r) / 2)) k).
   intro k ; unfold gt_abs_Pser, gt_Pser.
   rewrite Cnorm_IRC_Rabs, Rabs_Rabsolu, Rabs_mult, <- RPow_abs,
   IRC_pow_compat.
   unfold IRC ; apply (proj1 (Ceq _ _)) ; split.
   simpl ; rewrite Rmult_0_r, Rminus_0_r, Rabs_Cnorm ; reflexivity.
   simpl ; ring.
  assert (Temp : forall n, sum_f_C0 (fun k : nat => Cnorm
            (gt_abs_Pser (fun n => Cnorm (An n)) ((a + r) / 2) k)) n
            = sum_f_C0 (gt_Pser (fun n0 : nat => Cnorm (An n0)) (Rabs ((a + r) / 2))) n).
   intros n ; clear -Hrew ; induction n ; simpl ; rewrite Hrew ; [| rewrite IHn] ; reflexivity.
  intros n n_lb ; rewrite Temp ; apply HN ; assumption.
 intros n y Hyp ; unfold gt_Pser, gt_abs_Pser.
 rewrite Rabs_mult, Rabs_Cnorm ; repeat rewrite Cnorm_Cmult, Cnorm_IRC_Rabs,
 Rabs_mult, Rabs_right.
 apply Rmult_le_compat_l.
 apply Cnorm_pos.
 rewrite Rabs_Rabsolu.
 rewrite <- Cnorm_IRC_Rabs ; rewrite <- IRC_pow_compat ;
 repeat rewrite Cnorm_pow ; apply pow_incr ; split ; [apply Cnorm_pos |].
 unfold Boule in Hyp ; simpl in Hyp ; unfold C_dist in Hyp ;
 rewrite Cnorm_minus_sym, Cminus_0_r in Hyp.
 apply Rle_trans with a ; [left ; assumption |].
 rewrite Cnorm_IRC_Rabs, Rabs_right.
 apply Rle_trans with ((a + a) / 2)%R ; [right ; field | unfold Rdiv ;
 apply Rmult_le_compat_r ; [fourier | apply Rplus_le_compat_l ; left ; assumption]].
 unfold Rdiv ; apply Rle_ge ; apply Rle_mult_inv_pos ; fourier.
 apply Rle_ge ; apply Cnorm_pos.
Qed.

Lemma Rminus_Rlt : forall a b, 0 < a - b -> b < a.
Proof.
intros a b H.
 replace b with (b + 0)%R by ring.
 replace a with (b + (a - b))%R by ring.
 apply Rplus_lt_compat_l ; assumption.
Qed.

Lemma Cpser_alembert_prelim : forall (An : nat -> C) (M : R),
       0 < M -> (forall n : nat, An n <> C0) ->
       Cseq_bound (fun n => (An (S n) / An n)) M -> forall r,
       Rabs r < / M -> Cv_radius_weak An r.
Proof.
intros An M M_pos An_neq An_frac_ub r r_bd.
 assert (r_lb := Rabs_pos r) ; case r_lb ; clear r_lb ; intro rabs_lb.
 assert (my_lam : 0 < /Rabs r - M).
 apply Rgt_minus ; rewrite <- Rinv_involutive.
 apply Rinv_lt_contravar.
 apply Rmult_lt_0_compat ; [| apply Rlt_trans with (Rabs r)] ; assumption.
 assumption.
 apply Rgt_not_eq ; assumption.
 exists (Cnorm (An 0%nat)) ; intros x Hyp ;
  elim Hyp ; intros n Hn ; rewrite Hn ;
  unfold gt_norm_Pser ; rewrite Cnorm_Cmult.
  clear Hn ; induction n.
  simpl ; rewrite Cnorm_C1 ; rewrite Rmult_1_r ; right ; reflexivity.
  apply Rle_trans with (Cnorm (An (S n) / (An n)) * Cnorm (An n) * Cnorm (r ^ S n))%R.
  right ; repeat rewrite <- Cnorm_Cmult ; apply Cnorm_eq_compat ;
  field ; apply An_neq.
  apply Rle_trans with (M * Cnorm (An n) * Cnorm (r ^ S n))%R.
  repeat apply Rmult_le_compat_r ; [| | apply An_frac_ub] ; apply Cnorm_pos.
  simpl ; rewrite Cnorm_Cmult.
  apply Rle_trans with (M * Cnorm (An n) * (/M * Cnorm (r ^ n)))%R.
  repeat rewrite <- Rmult_assoc ; apply Rmult_le_compat_r ; [apply Cnorm_pos |
  repeat rewrite Rmult_assoc ; repeat apply Rmult_le_compat_l].
  left ; assumption.
  apply Cnorm_pos.
  rewrite Cnorm_IRC_Rabs ; left ; assumption.
  apply Rle_trans with (Cnorm (An n) * Cnorm (r ^ n))%R ; [right ; field ;
  apply Rgt_not_eq |] ; assumption.
 exists (Cnorm (An 0%nat)).
  intros x Hx ; destruct Hx as (n,Hn) ; rewrite Hn ; unfold gt_abs_Pser ; destruct n.
  right ; apply Cnorm_eq_compat ; ring.
  destruct (Req_dec r 0) as [Hr | Hf].
  rewrite Hr ; unfold gt_norm_Pser ; rewrite Cnorm_Cmult, Cnorm_pow,
  Cnorm_IRC_Rabs, RPow_abs, pow_i, Rabs_R0, Rmult_0_r ;
  [apply Cnorm_pos | intuition].
  apply False_ind ; assert (T := Rabs_no_R0 _ Hf) ;
  apply T ; symmetry ; assumption.
Qed.

Lemma Cpser_alembert_prelim2 : forall (An : nat -> C) (M : R),
       0 < M -> (forall n : nat, An n <> C0) ->
       Cseq_eventually (fun Un => Cseq_bound Un M) (fun n => (An (S n) / An n)) ->
       forall r, Rabs r < / M -> Cv_radius_weak An r.
Proof.
intros An M M_pos An_neq An_frac_event r r_bd.
destruct An_frac_event as [N HN].
 assert (Rho : Cv_radius_weak (fun n => (An (N + n)%nat)) r).
  apply Cpser_alembert_prelim with M.
  assumption.
  intro n ; apply An_neq.
  intro n ; replace (N + S n)%nat with (S (N + n)) by intuition ; apply HN.
  assumption.
 apply Cv_radius_weak_padding_neg_compat with N ;
 destruct Rho as [T HT] ; exists T ; intros u Hu ; destruct Hu as [n Hn] ;
 rewrite Hn ; unfold gt_norm_Pser ; rewrite plus_comm ; apply HT ;
 exists n ; reflexivity.
Qed.

Lemma Cpser_alembert_prelim3 : forall (An : nat -> C) (lambda : C),
       0 < Cnorm (lambda) -> (forall n : nat, An n <> C0) ->
       Rseq_cv (fun n : nat => Cnorm (An (S n) / An n)) (Cnorm lambda) -> forall r,
       Rabs r < / (Cnorm lambda) -> Cv_radius_weak An r.
Proof.
intros An lam lam_pos An_neq An_frac_cv r r_bd.
 assert (middle_lb := proj1 (middle_is_in_the_middle _ _ r_bd)).
 assert (middle_ub := proj2 (middle_is_in_the_middle _ _ r_bd)).
 assert (middle_pos : 0 < middle (Rabs r) (/Cnorm lam)).
  apply Rle_lt_trans with (Rabs r) ; [apply Rabs_pos | assumption].
 pose (eps := (/ (middle (Rabs r) (/ Cnorm lam)) - Cnorm lam)%R).
 assert (eps_pos : 0 < eps).
  apply Rgt_minus ; rewrite <- Rinv_involutive.
  apply Rinv_lt_contravar.
  apply Rmult_lt_0_compat ; [| apply Rinv_0_lt_compat] ; assumption.
  assumption.
  apply Rgt_not_eq ; assumption.
 apply Cpser_alembert_prelim2 with (Cnorm lam + eps)%R.
 fourier.
 apply An_neq.
 destruct (An_frac_cv (/ (middle (Rabs r) (/ Cnorm lam)) - Cnorm lam))%R as [N HN].
 assumption.
 exists N ; intro n.
 apply Rle_trans with (Cnorm lam + (Cnorm (An (S (N + n)) / An (N + n)%nat)
      - Cnorm lam))%R.
 right ; ring.
 apply Rplus_le_compat_l ; apply Rle_trans with
   (R_dist (Cnorm (An (S (N + n)) / An (N + n)%nat)) (Cnorm lam))%R.
 apply RRle_abs.
 left ; apply HN ; intuition.
 replace (Cnorm lam + eps)%R with (/ (middle (Rabs r) (/ Cnorm lam)))%R.
 rewrite Rinv_involutive ; [| apply Rgt_not_eq] ; assumption.
 unfold eps ; ring.
Qed.

Lemma Cpser_alembert_prelim4 : forall (An : nat -> C),
       (forall n : nat, An n <> C0) ->
       Rseq_cv (fun n : nat => Cnorm (An (S n) / An n)) R0 ->
       infinite_cv_radius An.
Proof.
intros An An_neq An_frac_0 r.
 assert (eps_pos : 0 < /(Rabs r + 1)).
  apply Rinv_0_lt_compat ; apply Rplus_le_lt_0_compat ; [apply Rabs_pos |
  apply Rlt_0_1].
 apply Cpser_alembert_prelim2 with (/(Rabs r + 1))%R.
 assumption.
 apply An_neq.
 destruct (An_frac_0 (/ (Rabs r + 1))%R eps_pos) as [N HN] ; exists N ; intro n.
 apply Rle_trans with (R_dist (Cnorm (An (S (N + n)) / An (N + n)%nat)) 0) ; [right |].
 unfold R_dist in |-* ; rewrite Rminus_0_r, Rabs_right ; [reflexivity | apply Rle_ge ;
 apply Cnorm_pos].
 left ; apply HN ; intuition.
 rewrite Rinv_involutive ; [fourier |] ; apply Rgt_not_eq ;
 apply Rplus_le_lt_0_compat ; [apply Rabs_pos | apply Rlt_0_1].
Qed.

Lemma Cpser_bound_criteria (An : nat -> C) (z l : C) :
    Pser An z l -> Cv_radius_weak An (Cnorm z).
Proof.
intros An z l Hzl.
 destruct Hzl with 1 as (N, HN) ; [fourier |].
 assert (H1 : forall n :  nat, (n >= S N)%nat -> gt_norm_Pser An z n
    <= Rmax 2 (Cnorm (An 0%nat) + 1)).
  intros n Hn ; case_eq n ; unfold gt_norm_Pser.
  intro H ; simpl ; rewrite Cmult_1_r ; apply Rle_trans with (Cnorm (An 0%nat) +1)%R ;
   [intuition | apply RmaxLess2].
   intros m Hrew ; replace (Cnorm (An (S m) * z ^ S m)) with
         (Cnorm ((sum_f_C0 (fun n0 : nat => An n0 * z ^ n0) (S m) - l) +
         (l - sum_f_C0 (fun n0 : nat => An n0 * z ^ n0) m))).
    apply Rle_trans with (Rplus (Cnorm (sum_f_C0 (fun n0 : nat => An n0 * z ^ n0)%C (S m) - l))
          (Cnorm (l - sum_f_C0 (fun n0 : nat => An n0 * z ^ n0) m))).
  apply Cnorm_triang.
   apply Rle_trans with 2 ; [|apply RmaxLess1] ; apply Rlt_le ; apply Rplus_lt_compat ;
   [| rewrite Cnorm_minus_sym].
   apply Rle_lt_trans with (dist C_met (sum_f_C0 (fun n0 : nat => An n0 * z ^ n0)
         (S m)) l).
  right ; simpl ; unfold C_dist ; reflexivity.
  apply HN ; intuition.
  apply Rle_lt_trans with (dist C_met (sum_f_C0 (fun n0 : nat => An n0 * z ^ n0) m) l).
  right ; simpl ; unfold C_dist ; reflexivity.
  apply HN ; intuition.
   simpl sum_f_C0 ; apply Cnorm_eq_compat.
   simpl ; ring.
   destruct (Cseq_partial_bound (gt_Pser An z) (S N)) as (B,HB).
   exists (Rmax B (Rmax 2 (Cnorm (An 0%nat) + 1))).
   intros y Hy ; destruct Hy as [u Hu] ; rewrite Hu.
   case (le_lt_dec u (S N)) ; intro Hu_b.
   apply Rle_trans with B.
   unfold gt_norm_Pser ; rewrite Cnorm_Cmult, Cnorm_pow, Cnorm_invol.
   rewrite <- Cnorm_pow. rewrite <- Cnorm_Cmult.
   apply HB ; assumption.
   apply RmaxLess1.
   unfold gt_norm_Pser ; rewrite Cnorm_Cmult.
   rewrite Cnorm_pow, Cnorm_invol, <- Cnorm_pow, <- Cnorm_Cmult.
   apply Rle_trans with (Rmax 2 (Cnorm (An 0%nat) + 1)) ; [apply H1 | apply RmaxLess2] ; intuition.
Qed.
(*
(** A sufficient condition for the radius of convergence*)
Lemma Cpser_finite_cv_radius_caracterization (An : nat -> C) (z l : C) :
   Pser An z l -> (forall l' : R, ~ Pser_norm An z l')  -> finite_cv_radius An (Cnorm z).
Proof.
intros An z l Hcv Hncv.
 split; intros x Hx.
 apply Rnot_lt_le ; intro Hxx0.
 assert (H : {l : C | Pser_norm An z (Cnorm l)}).

 destruct Hx as (m, Hm) ; exists m ; intros x1 H1 ; apply Hm ;
 destruct H1 as (i, Hi) ; exists i.
 unfold gt_abs_Pser in Hi ; replace (Rabs (Rabs (An i) * x ^ i)) with
       (Rabs ((An i) *x ^ i)) in Hi.
 assumption.
 repeat (rewrite Rabs_mult) ; rewrite Rabs_Rabsolu ; reflexivity.
 rewrite Rabs_Rabsolu ; assumption.
 destruct H as (l0, Hl0) ; apply Hncv with l0 ; exact Hl0.
 apply Hx ; apply Cv_radius_weak_le_compat with (r:=x0).
 rewrite Rabs_Rabsolu ; intuition.
 apply Rpser_bound_criteria with (l:=l) ; assumption.
Qed.

*)