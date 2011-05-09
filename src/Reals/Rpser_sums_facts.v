Require Import Reals Fourier.
Require Import Rsequence_def.
Require Import Rpser_def Rpser_sums Rpser_base_facts Rpser_cv_facts.

Require Import Ranalysis_def Rfunction_def Rextensionality.

Open Local Scope R_scope.

(** * Unfolding sums. *)

Lemma sum_r_unfold : forall An r r' (pr1 : finite_cv_radius An r)
  (pr2 : Cv_radius_weak An r') x, Rabs x < r -> Rabs x < r' ->
  sum_r An r pr1 x = weaksum_r An r' pr2 x.
Proof.
intros An r r' pr1 pr2 x x_bd x_bd' ; unfold sum_r ;
 destruct (Rlt_le_dec (Rabs x) r) as [H1 | Hf] ; [| exfalso ; fourier].
 apply weaksum_r_unique_strong ; [apply middle_is_in_the_middle |] ;
 assumption.
Qed.

(** * Compatibility of sum with the common operations. *)
Section sum_compatibilities.

Variables An Bn : Rseq.
Hypotheses
  (rAn : infinite_cv_radius An)
  (rBn : infinite_cv_radius Bn).

Lemma sum_scal_compat : forall (r : R) (rAn' : infinite_cv_radius (r * An)%Rseq),
  sum (r * An)%Rseq rAn' == ((fun _ => r) * sum An rAn)%F.
Proof.
intros r rAn' x.
 assert (H1 := sum_sums (r * An)%Rseq rAn' x) ;
 assert (H2 := Rpser_scal_compat r _ _ _ (sum_sums An rAn x)) ;
 eapply Rpser_unique ; eassumption.
Qed.

Lemma sum_opp_compat : forall (rAn' : infinite_cv_radius (- An)),
  sum (- An)%Rseq rAn' == (- sum An rAn)%F.
Proof.
intros rAn' x.
 assert (H1 := sum_sums (- An)%Rseq rAn' x) ;
 assert (H2 := Rpser_opp_compat _ _ _ (sum_sums An rAn x)) ;
 eapply Rpser_unique ; eassumption.
Qed.

Lemma sum_plus_compat : forall (rAnBn : infinite_cv_radius (An + Bn)),
  sum (An + Bn)%Rseq rAnBn == (sum An rAn + sum Bn rBn)%F.
Proof.
intros rAnBn x.
 assert (Ha := sum_sums An rAn x) ;
 assert (Hb := sum_sums Bn rBn x) ;
 assert (H1 := sum_sums (An + Bn)%Rseq rAnBn x) ;
 assert (H2 := Rpser_add_compat _ _ _ _ _ Ha Hb) ;
 eapply Rpser_unique ; eassumption.
Qed.

Lemma sum_minus_compat : forall (rAnBn : infinite_cv_radius (An - Bn)),
  sum (An - Bn)%Rseq rAnBn == (sum An rAn - sum Bn rBn)%F.
Proof.
intros rAnBn x.
 assert (Ha := sum_sums An rAn x) ;
 assert (Hb := sum_sums Bn rBn x) ;
 assert (H1 := sum_sums (An - Bn)%Rseq rAnBn x) ;
 assert (H2 := Rpser_minus_compat _ _ _ _ _ Ha Hb) ;
 eapply Rpser_unique ; eassumption.
Qed.

End sum_compatibilities.