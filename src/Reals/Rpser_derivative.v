Require Import Reals Rpow_facts Ranalysis_def.
Require Import Fourier.

Require Import Rsequence_facts RFsequence RFsequence_facts.
Require Import Rpser_def Rpser_base_facts Rpser_radius_facts Rpser_sums.

Open Local Scope R_scope.

(** * Definition of the formal derivative *)

(** Caracterization of the cv radius of the formal derivative *)

Lemma Cv_radius_weak_derivable_compat : forall An r,
         Cv_radius_weak An r -> forall r', Rabs r' < Rabs r ->
         Cv_radius_weak (An_deriv An) r'.
Proof.
intros An r rho r' r'_bd.
 assert (Rabsr_pos : 0 < Rabs r).
  apply Rle_lt_trans with (Rabs r') ; [apply Rabs_pos | assumption].
 assert (x_lt_1 : Rabs (r'/ r) < 1).
  unfold Rdiv ; rewrite Rabs_mult ; rewrite Rabs_Rinv.
  replace 1 with (Rabs r *  / Rabs r).
  apply Rmult_lt_compat_r ; [apply Rinv_0_lt_compat |] ; assumption.
  apply Rinv_r ; apply Rgt_not_eq ; assumption.
  intro Hf ; rewrite Hf, Rabs_R0 in Rabsr_pos ; apply (Rlt_irrefl _ Rabsr_pos).
  destruct rho as (B,HB).
  case (Req_or_neq r') ; intro r'_lb.
  exists (Rabs (An 1%nat)) ; intros x Hx ; destruct Hx as (i, Hi) ;
 rewrite Hi ; unfold gt_abs_Pser, An_deriv.
 destruct i.
 simpl ; rewrite Rmult_1_l ; rewrite Rmult_1_r ; apply Rle_refl.
 rewrite r'_lb ; rewrite pow_i ; [| intuition] ; repeat (rewrite Rmult_0_r) ;
 rewrite Rabs_R0 ; apply Rabs_pos.
 assert (Rabsr'_pos : 0 < Rabs r') by (apply Rabs_pos_lt ; assumption). 
 destruct (Rpser_cv_speed_pow_id (r' / r) x_lt_1 (Rabs r') Rabsr'_pos) as (N, HN).
 destruct (Rseq_partial_bound (gt_abs_Pser (An_deriv An) r') N) as (B2, HB2).
 exists (Rmax B B2) ; intros x Hx ; destruct Hx as (i, Hi) ;
 rewrite Hi ; unfold gt_abs_Pser in * ; case (le_lt_dec i N) ; intro H.
 rewrite <- Rabs_Rabsolu ; apply Rle_trans with B2 ; [apply HB2 | apply RmaxLess2] ;
 assumption.
 apply Rle_trans with (Rabs (/r' * (INR (S i) * (r' / r) ^ S i) * An (S i) * r ^ S i)).
 right ; apply Rabs_eq_compat ; unfold An_deriv ; field_simplify.
 unfold Rdiv ; repeat (rewrite Rmult_assoc) ; repeat (apply Rmult_eq_compat_l).
 rewrite Rpow_mult_distr.
 rewrite Rinv_1 ; rewrite Rmult_1_r.
 rewrite Rmult_assoc.
 replace ((/ r) ^ S i * (r ^ S i * / r')) with (/ r').
 simpl ; field ; assumption.
 field_simplify.
 unfold Rdiv ; repeat (rewrite <- Rmult_assoc) ; apply Rmult_eq_compat_r.
 rewrite <- Rinv_pow.
 field.
 apply pow_nonzero.
 intro Hf ; rewrite Hf, Rabs_R0 in r'_bd.
 assert (H0 : 0 < 0).
 apply Rlt_trans with (Rabs r') ; assumption.
 apply (Rlt_irrefl _ H0).
 intro Hf ; rewrite Hf, Rabs_R0 in r'_bd.
 assert (H0 : 0 < 0).
 apply Rlt_trans with (Rabs r') ; assumption.
 apply (Rlt_irrefl _ H0).
 assumption.
 assumption.
 assumption.
 rewrite Rmult_assoc ; rewrite Rabs_mult.
 apply Rle_trans with (Rabs (/ r' * (INR (S i) * (r' / r) ^ S i)) * B).
 apply Rmult_le_compat_l ; [apply Rabs_pos |] ; apply HB ; exists (S i) ; reflexivity.
 apply Rle_trans with (1*B) ; [| rewrite Rmult_1_l ; apply RmaxLess1].
 apply Rmult_le_compat_r.
 apply Rle_trans with (Rabs (An 0%nat * r ^ 0)) ; [apply Rabs_pos |] ;
 apply HB ; exists 0%nat ; reflexivity.
 rewrite Rabs_mult ; apply Rle_trans with (Rabs (/r') * Rabs r').
 apply Rmult_le_compat_l.
 apply Rabs_pos.
 apply Rle_trans with (R_dist (INR (S i) * (r' / r) ^ S i) 0) ;
 [right ; unfold R_dist ; rewrite Rminus_0_r ; reflexivity |] ; left ; apply HN ;
 intuition.
 rewrite <- Rabs_mult ; rewrite Rinv_l ; [| assumption] ; rewrite Rabs_R1 ; right ; trivial.
Qed.

Lemma finite_cv_radius_derivable_compat : forall An r,
         finite_cv_radius An r ->
         finite_cv_radius (An_deriv An) r.
Proof.
intros An r Rho ; split.
 intros r' (r'_lb, r'_ub) ; apply Cv_radius_weak_derivable_compat with
 (r := middle (Rabs r) (Rabs r')).
 apply (proj1 Rho) ; split.
 left ; apply middle_lt_le_pos.
 apply Rabs_pos_lt ; apply Rgt_not_eq ; apply Rlt_gt ;
 apply Rle_lt_trans with r' ; assumption.
 apply Rabs_pos.
 rewrite middle_comm ; apply Rlt_le_trans with (Rabs r).
 eapply middle_is_in_the_middle.
 apply Rle_lt_trans with r' ; [right ; apply Rabs_right ; intuition |].
 apply Rlt_le_trans with r ; [assumption | right ; symmetry ; apply Rabs_right ;
 left ; apply Rle_lt_trans with r' ; assumption].
 right ; apply Rabs_right ; left ; apply Rle_lt_trans with r' ; assumption.
 apply Rle_lt_trans with r'.
 right ; apply Rabs_right ; intuition.
 rewrite Rabs_right.
 apply Rle_lt_trans with (Rabs r') ; [right ; symmetry ;apply Rabs_right ;
 intuition | rewrite middle_comm].
 eapply middle_is_in_the_middle.
 apply Rle_lt_trans with r' ; [right ; apply Rabs_right ; intuition |].
 apply Rlt_le_trans with r ; [assumption | right ; symmetry ; apply Rabs_right ;
 left ; apply Rle_lt_trans with r' ; assumption].
 left ; apply middle_lt_le_pos ;  [apply Rabs_pos_lt ; apply Rgt_not_eq ;
 apply Rlt_gt ; apply Rle_lt_trans with r' ; assumption | apply Rabs_pos].
(* TODO: prove this*)
Admitted.

Lemma infinite_cv_radius_derivable_compat : forall An,
         infinite_cv_radius An ->
         infinite_cv_radius (An_deriv An).
Proof.
intros An Rho r ; apply Cv_radius_weak_derivable_compat with (r := (Rabs r) + 1).
 apply Rho.
 replace (Rabs (Rabs r + 1)) with (Rabs r + 1).
 fourier.
 symmetry ; apply Rabs_right.
 apply Rle_ge ; apply Rle_trans with (Rabs r) ; [apply Rabs_pos | fourier].
Qed.

(** Derivability of partial sums *)

Definition Rpser_partial_sum_derive An n x := match n with
     | 0%nat => 0
     | S _      => sum_f_R0 (gt_Pser (An_deriv An) x) (pred n)
end.

Lemma Rpser_derive_finite_sum : forall An n x,
       derivable_pt_lim (fun x => sum_f_R0 (gt_Pser An x) n) x (Rpser_partial_sum_derive An n x).
Proof.
intros An n x ;
 unfold Rpser_partial_sum_derive, gt_Pser, An_deriv ;
 apply (derivable_pt_lim_finite_sum An x n).
Qed.

(* begin hide *)

Lemma Rpser_derivability_prelim : forall x r, Rabs x < Rabs r ->
      Rabs x < (Rabs x + Rabs r)/2 < Rabs r.
Proof.
intros x r x_bd ; split.
 apply Rle_lt_trans with ((Rabs x + Rabs x)/2).
 apply Rle_trans with (Rabs ((x+x) /2)).
 right ; apply Rabs_eq_compat ; field.
 unfold Rdiv ; rewrite Rabs_mult.
 replace (Rabs (/2)) with (/2).
 apply Rmult_le_compat_r ; intuition.
 apply Rabs_triang.
 rewrite Rabs_right ; intuition ; fourier.
 unfold Rdiv ; apply Rmult_lt_compat_r ; fourier.
 apply Rlt_le_trans with ((Rabs r + Rabs r) / 2).
 unfold Rdiv ; apply Rmult_lt_compat_r ; fourier.
 right ; field.
Qed.

Lemma Rpser_derivability_prelim2 : forall x r, Rabs x < Rabs r ->
      Rabs x < Rabs ((Rabs x + Rabs r)/2) < Rabs r.
Proof.
intros x r x_bd ; replace (Rabs ((Rabs x + Rabs r)/2)) with ((Rabs x + Rabs r)/2).
 apply Rpser_derivability_prelim ; assumption.
 unfold Rdiv ; rewrite Rabs_mult ; replace (Rabs (/2)) with (/2).
 apply Rmult_eq_compat_r.
 symmetry ; rewrite Rabs_right ; [reflexivity |].
 apply Rle_ge ; apply Rplus_le_le_0_compat ; apply Rabs_pos.
 rewrite Rabs_right ; intuition ; fourier.
Qed.

(* end hide *)

(** Sum of the formal derivative *)

Definition weaksum_r_derive : forall (An : nat -> R) (r : R) (Rho : Cv_radius_weak An r) (x : R), R.
Proof.
intros An r Rho x ; case (Rlt_le_dec (Rabs x) r) ; intro x_bd.
 pose (r' := (Rabs x + Rabs r)/2).
 rewrite <- Rabs_right in x_bd by (apply Rle_ge ; apply Rle_trans with (Rabs x) ;
 [apply Rabs_pos | left ; assumption]).
 assert (H := Rpser_derivability_prelim2 _ _ x_bd).
 assert (r'_bd : Rabs r' < Rabs r).
  destruct H ; intuition.
 apply (weaksum_r (An_deriv An) ((Rabs x + Rabs r) / 2)
      (Cv_radius_weak_derivable_compat An r Rho r'
      r'_bd) x).
 apply 0.
Defined.

Definition sum_r_derive : forall (An : nat -> R) (r : R) (Rho : finite_cv_radius An r) (x : R), R.
Proof.
intros An r Rho.
 apply (sum_r (An_deriv An) r (finite_cv_radius_derivable_compat An r Rho)).
Defined.

Definition sum_derive : forall (An : nat -> R) (Rho : infinite_cv_radius An) (z : R), R.
Proof.
intros An Rho.
 apply (sum (An_deriv An) (infinite_cv_radius_derivable_compat An Rho)). 
Defined.

(** Proof that it is really the sum *)

Lemma weaksum_r_derive_sums : forall (An : nat -> R) (r : R) (Pr : Cv_radius_weak An r) (x : R),
      Rabs x < r -> Pser (An_deriv An) x (weaksum_r_derive An r Pr x).
Proof.
intros An r Pr x x_bd.
 unfold weaksum_r_derive ; case (Rlt_le_dec (Rabs x) r) ; intro s.
 rewrite <- Rabs_right in x_bd.
 apply weaksum_r_sums.
 apply (proj1 (Rpser_derivability_prelim _ _ x_bd)).
 apply Rle_ge ; apply Rle_trans with (Rabs x) ;
 [apply Rabs_pos | left ; assumption].
 assert (H : Rabs x < Rabs x) by (apply Rlt_le_trans with r ; assumption) ;
 elim (Rlt_irrefl _ H).
Qed.

Lemma sum_r_derive_sums : forall (An : nat -> R) (r : R) (Pr : finite_cv_radius An r) (z : R),
      Rabs z < r -> Pser (An_deriv An) z (sum_r_derive An r Pr z).
Proof.
intros An r Pr z z_bd ; unfold sum_r_derive ;
 destruct (Rlt_le_dec (Rabs z) r) as [z_bd2 | Hf].
 apply sum_r_sums ; assumption.
 elim (Rlt_irrefl _ (Rlt_le_trans _ _ _ z_bd Hf)).
Qed.

Lemma sum_derive_sums : forall (An : nat -> R) (Pr : infinite_cv_radius An) (z : R),
      Pser (An_deriv An) z (sum_derive An Pr z).
Proof.
intros An Pr ; unfold sum_derive ; apply sum_sums.
Qed.

(** Proof that this derivative is unique *)

Lemma weaksum_r_derive_unique : forall (An : nat -> R) (r : R) (Pr1 Pr2 : Cv_radius_weak An r) (z : R),
      Rabs z < r -> weaksum_r_derive An r Pr1 z = weaksum_r_derive An r Pr2 z .
Proof.
intros An r Pr1 Pr2 z z_bd ;
 assert (T1 := weaksum_r_derive_sums _ _ Pr1 _ z_bd) ;
 assert (T2 := weaksum_r_derive_sums _ _ Pr2 _ z_bd).
 eapply Pser_unique ; eassumption.
Qed.

Lemma sum_r_derive_unique : forall (An : nat -> R) (r : R) (Pr1 Pr2 : finite_cv_radius An r) (z : R),
      Rabs z < r -> sum_r_derive An r Pr1 z = sum_r_derive An r Pr2 z .
Proof.
intros An r Pr1 Pr2 z z_bd ;
 assert (T1 := sum_r_derive_sums _ _ Pr1 _ z_bd) ;
 assert (T2 := sum_r_derive_sums _ _ Pr2 _ z_bd).
 eapply Pser_unique ; eassumption.
Qed.

Lemma sum_derive_unique : forall (An : nat -> R) (Pr1 Pr2 : infinite_cv_radius An) (z : R),
      sum_derive An Pr1 z = sum_derive An Pr2 z .
Proof.
intros An Pr1 Pr2 z ;
 assert (T1 := sum_derive_sums _ Pr1 z) ;
 assert (T2 := sum_derive_sums _ Pr2 z).
 eapply Pser_unique ; eassumption.
Qed.

(** Proof that the formal derivative is the actual derivative within the cv-disk *)

Lemma derivable_pt_lim_weaksum_r : forall (An:nat->R) (r:R) (Pr : Cv_radius_weak An r), forall x,
      Rabs x < r -> derivable_pt_lim (weaksum_r An r Pr) x (weaksum_r_derive An r Pr x).
Proof.
intros An r rho x x_bd.
 assert (x_bd' : Rabs x < Rabs r).
  apply Rlt_le_trans with r ; [assumption | right ; symmetry ; apply Rabs_right].
  apply Rle_ge ; apply Rle_trans with (Rabs x) ; [apply Rabs_pos | left ; assumption].
assert (lb_lt_x : - (Rabs x + Rabs r) / 2 < x).
  apply Rlt_le_trans with (- (Rabs x + Rabs x)/2).
  unfold Rdiv ; apply Rmult_lt_compat_r ; [fourier |] ;
  apply Ropp_gt_lt_contravar ; apply Rplus_lt_compat_l ; assumption.
  unfold Rabs ; case (Rcase_abs x) ; intro H.
  right ; field.
  apply Rle_trans with 0.
  unfold Rdiv ; rewrite Ropp_mult_distr_l_reverse ;
  apply Rge_le ; apply Ropp_0_le_ge_contravar.
  apply Rle_mult_inv_pos ; fourier.
  intuition.
 assert (x_lt_ub : x < (Rabs x + Rabs r) / 2).
  apply Rle_lt_trans with ((Rabs x + Rabs x)/2).
  unfold Rabs ; case (Rcase_abs x) ; intro H.
  apply Rle_trans with 0.
  left ; assumption.
  rewrite <- Ropp_plus_distr.
  unfold Rdiv ; apply Rle_mult_inv_pos.
  fourier.
  fourier.
  right ; field.
  unfold Rdiv ; apply Rmult_lt_compat_r ; [fourier |] ; apply Rplus_lt_compat_l ;
  assumption.
    pose (r' := ((Rabs x + Rabs r)/2 + Rabs r)/2).
    assert (r'_bd1 := proj2 (Rpser_derivability_prelim _ _ x_bd')).
    replace ((Rabs x + Rabs r) / 2) with (Rabs ((Rabs x + Rabs r) / 2)) in r'_bd1 ; [| apply Rabs_right ;
    unfold r' ; apply Rle_ge ; unfold Rdiv ; apply Rle_mult_inv_pos ; [| fourier] ;
    apply Rplus_le_le_0_compat ; apply Rabs_pos].
    assert (r'_bd := proj2 (Rpser_derivability_prelim _ _ r'_bd1)).
    assert (Temp : (Rabs ((Rabs x + Rabs r) / 2) + Rabs r) / 2 = r').
     unfold r' ; unfold Rdiv ; apply Rmult_eq_compat_r ; apply Rplus_eq_compat_r ;
     apply Rabs_right ; apply Rle_ge ; apply Rle_mult_inv_pos ; [| fourier] ;
     apply Rplus_le_le_0_compat ; apply Rabs_pos.
     rewrite Temp in r'_bd ; clear Temp ;
    fold r' in r'_bd ; replace r' with (Rabs r') in r'_bd ; [| apply Rabs_right ;
    unfold r' ; apply Rle_ge ; unfold Rdiv ; apply Rle_mult_inv_pos ; [| fourier] ;
    apply Rplus_le_le_0_compat ; [| apply Rabs_pos] ; unfold Rdiv ;
    apply Rle_mult_inv_pos ; [| fourier] ; apply Rplus_le_le_0_compat ; apply Rabs_pos].
    pose (r'' := ((Rabs x + Rabs r) / 2)).
    assert (r''_pos : 0 < r'').
    unfold r''. apply Rlt_mult_inv_pos ; [| fourier] ;
     apply Rplus_le_lt_0_compat ; [| apply Rle_lt_trans with (Rabs x) ; [| assumption]] ;
     apply Rabs_pos.
    assert (r''_bd : r'' < r').
     unfold r'', r'.
     unfold Rdiv ; apply Rmult_lt_compat_r ; [fourier |] ; apply Rplus_lt_compat_r.
     apply Rabs_def1 ; [| rewrite <- Ropp_mult_distr_l_reverse] ; assumption.
    pose (myR := mkposreal r'' r''_pos).
    assert (myR_ub : myR < r') by intuition.
    assert (Abel2' := Rpser_abel2 (An_deriv An) r'
         (Cv_radius_weak_derivable_compat An r rho r' r'_bd) myR myR_ub).
   assert (cv_interv : forall y : R, Boule 0 (mkposreal_lb_ub x (- (Rabs x + Rabs r) / 2)
         ((Rabs x + Rabs r) / 2) lb_lt_x x_lt_ub) y ->
         {l : R | Un_cv (fun N : nat => SP
         (fun (n : nat) (x : R) => gt_Pser (An_deriv An) x n) N y) l}).
    intros y y_bd.
    exists (weaksum_r_derive An r rho y).
    assert (y_bd2 : Rabs y < r).
     unfold Boule, mkposreal_lb_ub in y_bd ; rewrite Rminus_0_r in y_bd.
     apply Rlt_trans with (((Rabs x + Rabs r) / 2 - - (Rabs x + Rabs r) / 2) / 2).
     assumption.
     apply Rle_lt_trans with ((Rabs x + Rabs r) / 2).
     right ; field.
     destruct (middle_is_in_the_middle _ _ x_bd) as (_, Temp) ; unfold middle in Temp.
     rewrite Rabs_right with r ; [assumption | apply Rle_ge ;
     apply Rle_trans with (Rabs x) ; [apply Rabs_pos | intuition]].
     intros alpha alpha_pos ; destruct (weaksum_r_derive_sums An r rho y y_bd2
           alpha alpha_pos) as (N, HN) ; exists N ; intros n n_lb ; apply HN ;
           assumption.
   assert (CVN : CVN_r (fun (n : nat) (x : R) => gt_Pser (An_deriv An) x n)
         (mkposreal_lb_ub x (- (Rabs x + Rabs r) / 2) ((Rabs x + Rabs r) / 2)
         lb_lt_x x_lt_ub)).
    apply Rpser_abel2 with r'.
    apply Cv_radius_weak_derivable_compat with r ; assumption.
    unfold mkposreal_lb_ub.
    apply Rle_lt_trans with r'' ; [| assumption].
    right ; unfold r'' ; intuition.
     assert (Temp : ((Rabs x + Rabs r) / 2 - - (Rabs x + Rabs r) / 2) / 2
           = (Rabs x + Rabs r) / 2).
       field.
     intuition.
   assert (Main := CVN_CVU_interv (fun n x => gt_Pser (An_deriv An) x n)
          (mkposreal_lb_ub x (- (Rabs x + Rabs r) / 2) ((Rabs x + Rabs r) / 2)
          lb_lt_x x_lt_ub) cv_interv CVN).
   assert (Main2 : RFseq_cvu (Rpser_partial_sum_derive An) (weaksum_r_derive An r rho)
          ((- (Rabs x + Rabs r) / 2 + (Rabs x + Rabs r) / 2) / 2)
          (mkposreal_lb_ub x (- (Rabs x + Rabs r) / 2) ((Rabs x + Rabs r) / 2)
          lb_lt_x x_lt_ub)).
    clear -Main x_bd; intros eps eps_pos ; destruct (Main eps eps_pos) as (N, HN) ;
    exists (S N) ; intros n y n_lb y_bd.
    assert (y_bd2 : Boule 0
         (mkposreal_lb_ub x (- (Rabs x + Rabs r) / 2) ((Rabs x + Rabs r) / 2)
         lb_lt_x x_lt_ub) y).
     unfold Boule in y_bd ; unfold Boule ; replace ((- (Rabs x + Rabs r) / 2
          + (Rabs x + Rabs r) / 2)/2) with 0 in y_bd by field ; assumption.
    assert(n_lb2 : (N <= pred n)%nat) by intuition.
    assert (Temp := HN (pred n) y n_lb2 y_bd2).
    assert (T1 := SFL_interv_right (fun (n : nat) (x : R) => gt_Pser (An_deriv An) x n)
            (mkposreal_lb_ub x (- (Rabs x + Rabs r) / 2)
            ((Rabs x + Rabs r) / 2) lb_lt_x x_lt_ub) cv_interv y y_bd2).
    assert (y_bd3 : Rabs y < r).
     unfold Boule, mkposreal_lb_ub in y_bd2 ; rewrite Rminus_0_r in y_bd2.
     apply Rlt_trans with (((Rabs x + Rabs r) / 2 - - (Rabs x + Rabs r) / 2) / 2).
     assumption.
     apply Rle_lt_trans with ((Rabs x + Rabs r) / 2).
     right ; field.
     destruct (middle_is_in_the_middle _ _ x_bd) as (_, Temp') ; unfold middle in Temp'.
     rewrite Rabs_right with r ; [assumption | apply Rle_ge ;
     apply Rle_trans with (Rabs x) ; [apply Rabs_pos | intuition]].
    assert (T2_temp := weaksum_r_derive_sums An r rho y y_bd3).
    assert (T2 := Pser_Rseqcv_link _ _ _ T2_temp) ; clear T2_temp.
    assert (Hrew : (fun N : nat => sum_f_R0 (gt_Pser (An_deriv An) y) N)
    = (fun N : nat => SP (fun (n : nat) (x : R) => gt_Pser (An_deriv An) x n) N y)).
     unfold SP ; reflexivity.
    rewrite Hrew in T2 ; clear Hrew.
    assert (Lim_eq := UL_sequence _ _ _ T1 T2).
    rewrite <- Lim_eq.
    unfold SP in Temp ; unfold Rpser_partial_sum_derive.
    assert (Hrew : n = S (pred n)).
     apply S_pred with N ; intuition.
    rewrite Hrew.
    unfold R_dist ; rewrite Rabs_minus_sym ; apply Temp.
  assert (Dfn_eq_fn' : forall (x0 : R) (n : nat), - (Rabs x + Rabs r) / 2 < x0 ->
          x0 < (Rabs x + Rabs r) / 2 -> derivable_pt_lim
          ((fun (n0 : nat) (x : R) => sum_f_R0 (gt_Pser An x) n0) n) x0
          (Rpser_partial_sum_derive An n x0)).
   intros y n y_lb y_ub.
   apply derivable_pt_lim_finite_sum.
  assert (fn_cv_f : RFseq_cv_interv (fun (n : nat) (x : R) => sum_f_R0 (gt_Pser An x) n)
          (weaksum_r An r rho) (- (Rabs x + Rabs r) / 2) ((Rabs x + Rabs r) / 2)).
   intros y lb_lt_y y_lt_ub eps eps_pos.
    assert(y_bd1 : - Rabs r < y).
     apply Rlt_trans with (- (Rabs x + Rabs r) / 2) ; [| assumption].
     apply Rle_lt_trans with (- (Rabs r + Rabs r) / 2).
     right ; field.
     unfold Rdiv ; apply Rmult_lt_compat_r ; [fourier |] ; apply Ropp_lt_contravar ;
     apply Rplus_lt_compat_r ; assumption.
    assert(y_bd2 : y < Rabs r).
     apply Rlt_trans with ((Rabs x + Rabs r) / 2) ; [assumption |] ;
     apply Rlt_le_trans with ((Rabs r + Rabs r) / 2) ; [| right ; field].
     unfold Rdiv ; apply Rmult_lt_compat_r ; [fourier |] ; apply Rplus_lt_compat_r ;
     assumption.
   assert (y_bd : Rabs y < Rabs r).
    apply Rabs_def1 ; assumption.
    replace (Rabs r) with r in y_bd ; [| symmetry ; apply Rabs_right ; apply Rle_ge ;
    apply Rle_trans with (Rabs x) ; [apply Rabs_pos | left ; assumption]].
   destruct (weaksum_r_sums An r rho y y_bd eps eps_pos) as (N, HN) ; exists N ;
   intros n n_lb ; apply HN ; assumption.
    apply (RFseq_cvu_derivable (fun n x => sum_f_R0 (gt_Pser An x) n)
         (Rpser_partial_sum_derive An)
         (weaksum_r An r rho) (weaksum_r_derive An r rho) x
         (- (Rabs x + Rabs r)/2) ((Rabs x + Rabs r)/2)
         lb_lt_x x_lt_ub Dfn_eq_fn' fn_cv_f Main2).
   intros y y_lb y_ub.
   apply CVU_continuity with (fn:=Rpser_partial_sum_derive An) (x:=0) (r:=(mkposreal_lb_ub x (- (Rabs x + Rabs r) / 2)
             ((Rabs x + Rabs r) / 2) lb_lt_x x_lt_ub)).
             intros eps eps_pos ; destruct (Main2 eps eps_pos) as (N, HN) ; exists N ; 
             intros n z n_lb z_bd.
             rewrite Rabs_minus_sym ; apply HN.
   assumption.
   replace ((- (Rabs x + Rabs r) / 2 + (Rabs x + Rabs r) / 2) / 2) with 0 by field.
   assumption.
   intros.
   destruct n.
   unfold Rpser_partial_sum_derive.
   apply continuity_const ; unfold constant ; intuition.
   unfold Rpser_partial_sum_derive ; apply continuity_finite_sum.
   unfold Boule ; rewrite Rminus_0_r.
   unfold mkposreal_lb_ub.
   replace (((Rabs x + Rabs r) / 2 - - (Rabs x + Rabs r) / 2) / 2) with
   ((Rabs x + Rabs r) / 2) by field.
   apply Rabs_def1 ; intuition.
   clear -y_lb ; apply Rle_lt_trans with (- (Rabs x + Rabs r) / 2).
   right ; field.
   assumption.
Qed.

Lemma derivable_pt_lim_sum_r : forall (An:nat->R) (r:R) (Pr : finite_cv_radius An r) z,
      Rabs z < r -> derivable_pt_lim (sum_r An r Pr) z (sum_r_derive An r Pr z).
Proof.
intros An r Rho z z_bd eps eps_pos.
 unfold sum_r_derive, sum_r.
 assert (H : 0 <= middle (Rabs z) r < r).
  split.
  left ; apply middle_le_lt_pos ; [| apply Rle_lt_trans with (Rabs z) ; [| assumption]] ;
  apply Rabs_pos.
  eapply middle_is_in_the_middle ; assumption.
 destruct (derivable_pt_lim_weaksum_r _ _ (proj1 Rho (middle (Rabs z) r) H) _
 (proj1 (middle_is_in_the_middle _ _ z_bd)) _ eps_pos) as [delta Hdelta].
 pose (delta' := Rmin delta (((middle (Rabs z) r) - Rabs z) / 2)%R) ;
 assert (delta'_pos : 0 < delta').
  apply Rmin_pos.
   apply delta.
   apply ub_lt_2_pos with (middle (Rabs z) (middle (Rabs z) r)) ;
   apply (middle_is_in_the_middle _ _ (proj1 (middle_is_in_the_middle _ _ z_bd))).
  exists (mkposreal delta' delta'_pos) ; intros h h_neq h_bd.
  assert (Hdelta' := Hdelta h h_neq) ; clear Hdelta.
  unfold weaksum_r_derive in Hdelta'.
  destruct (Rlt_le_dec (Rabs z) r) as [ z_bd2 | Hf].
  destruct (Rlt_le_dec (Rabs (z + h)) r) as [zh_bd | Hf].
  destruct (Rlt_le_dec (Rabs z) (middle (Rabs z) r)) as [z_bd3 | Hf].
  rewrite weaksum_r_unique with (Pr2 := proj1 Rho (middle (Rabs z) r) H).
  rewrite weaksum_r_unique_strong with (r2 := middle (Rabs z) r)
   (Pr2 := proj1 Rho (middle (Rabs z) r) H).
  erewrite weaksum_r_unique_strong with (r2 := (Rabs z + Rabs (middle (Rabs z) r)) / 2)
   (Pr2 := (Cv_radius_weak_derivable_compat An (middle (Rabs z) r) (proj1 Rho (middle (Rabs z) r) H)
        ((Rabs z + Rabs (middle (Rabs z) r)) / 2) match Rpser_derivability_prelim2 z (middle (Rabs z) r)
        (eq_ind_r (Rlt (Rabs z)) z_bd3 (Rabs_right (middle (Rabs z) r) (Rle_ge 0 (middle (Rabs z) r)
        (Rle_trans 0 (Rabs z) (middle (Rabs z) r) (Rabs_pos z) (or_introl (Rabs z = middle (Rabs z) r)
        z_bd3))))) with | conj _ H0 => H0 end)).
  apply Hdelta' ; clear Hdelta'.
  apply Rlt_le_trans with delta' ; [apply h_bd | unfold delta' ; apply Rmin_l].
  eapply middle_is_in_the_middle ; assumption.
  replace ((Rabs z + Rabs (middle (Rabs z) r)) / 2) with (middle (Rabs z) (Rabs (middle (Rabs z) r)))
  by reflexivity.
  eapply middle_is_in_the_middle.
  apply Rlt_le_trans with (middle (Rabs z) r) ; [ eapply middle_is_in_the_middle ; assumption |
  right ; symmetry ; apply Rabs_right ; apply Rle_ge ; left ; apply middle_le_lt_pos ; [| apply Rle_lt_trans
  with (Rabs z) ; [| assumption ]] ; apply Rabs_pos].
  eapply middle_is_in_the_middle ; assumption.
  apply Rle_lt_trans with (Rabs z + Rabs h) ; [apply Rabs_triang |].
  apply Rlt_le_trans with (Rabs z + delta') ; [apply Rplus_lt_compat_l ; apply h_bd |].
  apply Rle_trans with (Rabs z + ((middle (Rabs z) r - Rabs z) / 2)) ; [apply
  Rplus_le_compat_l ; apply Rmin_r |].
  apply Rle_trans with (2 * Rabs z / 2 + (middle (Rabs z) r - Rabs z) / 2) ;
  [right ; field |].
  unfold Rdiv ; rewrite <- Rmult_plus_distr_r ; ring_simplify ;
  rewrite <- Rmult_plus_distr_r ; apply Rle_trans with (middle (Rabs z) (middle (Rabs z) r)) ;
  [right ; reflexivity |].
  left ; do 2 eapply middle_is_in_the_middle ; assumption.
  eapply middle_is_in_the_middle ; assumption.
  apply False_ind ; apply (Rlt_irrefl (Rabs z)).
  apply Rlt_le_trans with (middle (Rabs z) r) ; [ eapply middle_is_in_the_middle |] ; assumption.
  apply False_ind ; apply Rlt_irrefl with (Rabs (z + h)).
  apply Rle_lt_trans with (Rabs z + Rabs h) ; [apply Rabs_triang |].
  apply Rlt_le_trans with (Rabs z + delta') ; [apply Rplus_lt_compat_l ; apply h_bd |].
  apply Rle_trans with (Rabs z + ((middle (Rabs z) r - Rabs z) / 2)) ; [apply
  Rplus_le_compat_l ; apply Rmin_r |].
  apply Rle_trans with (2 * Rabs z / 2 + (middle (Rabs z) r - Rabs z) / 2) ;
  [right ; field |].
  unfold Rdiv ; rewrite <- Rmult_plus_distr_r ; ring_simplify ;
  rewrite <- Rmult_plus_distr_r ; apply Rle_trans with (middle (Rabs z) (middle (Rabs z) r)) ;
  [right ; reflexivity |].
  apply Rle_trans with r ; [| assumption].
  apply Rle_trans with (middle (Rabs z) r) ; [left ; do 2 eapply middle_is_in_the_middle
  | left ; eapply middle_is_in_the_middle] ; assumption.
  elim (Rlt_irrefl _ (Rlt_le_trans _ _ _ z_bd Hf)).
Qed.

Lemma derivable_pt_lim_sum : forall (An:nat->R) (Pr : infinite_cv_radius An), forall z,
      derivable_pt_lim (sum An Pr) z (sum_derive An Pr z).
Proof.
intros An Pr z eps eps_pos. 
 unfold sum_derive, sum.
 assert (z_bd : Rabs z < Rabs z + 1) by fourier. 
 destruct (derivable_pt_lim_weaksum_r _ _ (Pr _) _ z_bd _ eps_pos) as [delta Hdelta].
 pose (delta' := Rmin delta (1 / 2)).
 assert (delta'_pos : 0 < delta').
  unfold Rmin ; apply Rmin_pos ; [apply delta | fourier].
 exists (mkposreal delta' delta'_pos) ; intros h h_neq h_bd.
 rewrite weaksum_r_unique_strong with (r2 := Rabs z + 1) (Pr2 := Pr (Rabs z + 1)).
 unfold weaksum_r_derive in Hdelta.
 destruct (Rlt_le_dec (Rabs z) (Rabs z + 1)) as [tt | Hf].
 rewrite weaksum_r_unique_strong with (r2 :=  ((Rabs z + Rabs (Rabs z + 1)) / 2))
    (Pr2 := (Cv_radius_weak_derivable_compat An (Rabs z + 1)
    (Pr (Rabs z + 1)) ((Rabs z + Rabs (Rabs z + 1)) / 2)
    match Rpser_derivability_prelim2 z (Rabs z + 1)
    (eq_ind_r (Rlt (Rabs z)) tt (Rabs_right (Rabs z + 1)
    (Rle_ge 0 (Rabs z + 1) (Rle_trans 0 (Rabs z) (Rabs z + 1) (Rabs_pos z)
    (or_introl (Rabs z = Rabs z + 1) tt)))))
    with | conj _ H0 => H0 end)).
 apply Hdelta ; [| apply Rlt_le_trans with delta' ; [| apply Rmin_l]] ; assumption.
 fourier.
 apply Rlt_le_trans with (middle (Rabs z) (Rabs z + 1)).
 eapply middle_is_in_the_middle. fourier.
 apply Rle_trans with (middle (Rabs z) (Rabs (Rabs z + 1))).
 replace (Rabs (Rabs z + 1)) with (Rabs z + 1).
 right ; reflexivity.
 symmetry ; apply Rabs_right ; assert (H := Rabs_pos z) ; fourier.
 unfold middle ; right ; reflexivity. 
 elim (Rlt_irrefl _ (Rlt_le_trans _ _ _ z_bd Hf)).
 fourier.
 apply Rle_lt_trans with (Rabs z + Rabs h) ; [apply Rabs_triang 
 | apply Rplus_lt_compat_l ; apply Rlt_trans with (1/2)].
 apply Rlt_le_trans with delta' ; [assumption | apply Rmin_r].
 fourier.
Qed.

(** * Derivabilty / Continuity of the sum within the cv disk *)

Lemma derivable_pt_weaksum_r : forall (An:nat->R) (r:R) (Pr : Cv_radius_weak An r), forall x,
      Rabs x < r -> derivable_pt (weaksum_r An r Pr) x.
Proof.
intros An r rho x x_bd.
 exists (weaksum_r_derive An r rho x) ; apply derivable_pt_lim_weaksum_r ; assumption.
Qed.

Lemma derivable_pt_sum_r : forall (An:nat->R) (r:R) (Pr : finite_cv_radius An r), forall x,
      Rabs x < r -> derivable_pt (sum_r An r Pr) x.
Proof.
intros An r rho x x_bd.
 exists (sum_r_derive An r rho x) ; apply derivable_pt_lim_sum_r ; assumption.
Qed.

Lemma derivable_pt_sum : forall (An:nat->R) (Pr : infinite_cv_radius An) x,
      derivable_pt (sum An Pr) x.
Proof.
intros An rho x.
 exists (sum_derive An rho x) ; apply derivable_pt_lim_sum ; assumption.
Qed.


Lemma continuity_pt_weaksum_r : forall (An:nat->R) (r:R) (Pr : Cv_radius_weak An r) x,
      Rabs x < r -> continuity_pt (weaksum_r An r Pr) x.
Proof.
intros An r rho x x_bd ; apply derivable_continuous_pt ; apply derivable_pt_weaksum_r ;
 assumption.
Qed.

Lemma continuity_pt_sum_r : forall (An:nat->R) (r:R) (Pr : finite_cv_radius An r) x,
      Rabs x < r -> continuity_pt (sum_r An r Pr) x.
Proof.
intros An r rho x x_bd ; apply derivable_continuous_pt ; apply derivable_pt_sum_r ;
 assumption.
Qed.

Lemma continuity_pt_sum : forall (An:nat->R) (Pr : infinite_cv_radius An) x,
      continuity_pt (sum An Pr) x.
Proof.
intros An rho x ; apply derivable_continuous_pt ; apply derivable_pt_sum.
Qed.

(** * Derivability / continuity of the sum when the cv disk as an infinite radius *)

Lemma derivable_sum : forall (An:nat->R) (Pr : infinite_cv_radius An),
      derivable (sum An Pr).
Proof.
intros An rho x ; apply derivable_pt_sum.
Qed.

Lemma continuity_sum : forall (An:nat->R) (Pr : infinite_cv_radius An),
      continuity (sum An Pr).
Proof.
intros An rho x ; apply derivable_continuous ; apply derivable_sum.
Qed.