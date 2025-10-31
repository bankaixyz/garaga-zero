from starkware.cairo.common.cairo_builtins import PoseidonBuiltin, ModBuiltin, UInt384
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.alloc import alloc

from basic_field_ops import sub_mod_p, assert_eq_mod_p
from definitions import E12D, G1Point, G2Point, G1G2Pair, get_P, bn, bls
from ec_ops import msm, add_ec_points

from bn254.multi_pairing_3 import multi_pairing_3P as bn_multi_pairing_3P
from bn254.multi_pairing_1 import multi_pairing_1P as bn_multi_pairing_1P
from bls12_381.multi_pairing_3 import multi_pairing_3P as bls_multi_pairing_3P
from bls12_381.multi_pairing_1 import multi_pairing_1P as bls_multi_pairing_1P

func negate_g1{
    range_check_ptr, range_check96_ptr: felt*, add_mod_ptr: ModBuiltin*, mul_mod_ptr: ModBuiltin*
}(curve_id: felt, p: G1Point) -> (res: G1Point) {
    let (P) = get_P(curve_id);
    let (yn) = sub_mod_p(P, p.y, P);
    return (res=G1Point(p.x, yn));
}

func negate_g2{
    range_check_ptr, range_check96_ptr: felt*, add_mod_ptr: ModBuiltin*, mul_mod_ptr: ModBuiltin*
}(curve_id: felt, p: G2Point) -> (res: G2Point) {
    let (P) = get_P(curve_id);
    let (y0n) = sub_mod_p(P, p.y0, P);
    let (y1n) = sub_mod_p(P, p.y1, P);
    return (res=G2Point(p.x0, p.x1, y0n, y1n));
}

func assert_eq_E12D_modp{
    range_check96_ptr: felt*, add_mod_ptr: ModBuiltin*, mul_mod_ptr: ModBuiltin*
}(curve_id: felt, a: E12D, b: E12D) {
    let (P) = get_P(curve_id);
    assert_eq_mod_p(a.w0, b.w0, P);
    assert_eq_mod_p(a.w1, b.w1, P);
    assert_eq_mod_p(a.w2, b.w2, P);
    assert_eq_mod_p(a.w3, b.w3, P);
    assert_eq_mod_p(a.w4, b.w4, P);
    assert_eq_mod_p(a.w5, b.w5, P);
    assert_eq_mod_p(a.w6, b.w6, P);
    assert_eq_mod_p(a.w7, b.w7, P);
    assert_eq_mod_p(a.w8, b.w8, P);
    assert_eq_mod_p(a.w9, b.w9, P);
    assert_eq_mod_p(a.w10, b.w10, P);
    assert_eq_mod_p(a.w11, b.w11, P);
    return ();
}

func pairing_3P_select{
    range_check_ptr,
    poseidon_ptr: PoseidonBuiltin*,
    range_check96_ptr: felt*,
    add_mod_ptr: ModBuiltin*,
    mul_mod_ptr: ModBuiltin*,
}(curve_id: felt, pairs: G1G2Pair*) -> (res: E12D) {
    if (curve_id == bn.CURVE_ID) {
        let (r) = bn_multi_pairing_3P(pairs);
        return (res=r);
    } else {
        let (r) = bls_multi_pairing_3P(pairs);
        return (res=r);
    }
}

func pairing_1P_select{
    range_check_ptr,
    poseidon_ptr: PoseidonBuiltin*,
    range_check96_ptr: felt*,
    add_mod_ptr: ModBuiltin*,
    mul_mod_ptr: ModBuiltin*,
}(curve_id: felt, pairs: G1G2Pair*) -> (res: E12D) {
    if (curve_id == bn.CURVE_ID) {
        let (r) = bn_multi_pairing_1P(pairs);
        return (res=r);
    } else {
        let (r) = bls_multi_pairing_1P(pairs);
        return (res=r);
    }
}

// Generic Groth16 verification (curve-agnostic):
// - vk_x = ic[0] + MSM(ic[1:], public_inputs)
// - Check: e(vk_x, gamma) * e(C, delta) * e(-A, B) == e(alpha, beta)^{-1}
func verify_groth16_generic{
    range_check_ptr,
    poseidon_ptr: PoseidonBuiltin*,
    range_check96_ptr: felt*,
    add_mod_ptr: ModBuiltin*,
    mul_mod_ptr: ModBuiltin*,
}(
    curve_id: felt,
    n_public_inputs: felt,
    ic: G1Point*,
    alpha_g1: G1Point,
    beta_g2: G2Point,
    gamma_g2: G2Point,
    delta_g2: G2Point,
    proof_a: G1Point,
    proof_b: G2Point,
    proof_c: G1Point,
    public_inputs: Uint256*,
) -> (ok: felt) {
    alloc_locals;
    let (tmp) = msm(curve_id, ic + G1Point.SIZE, public_inputs, n_public_inputs);
    let (local vk_x) = add_ec_points(curve_id, tmp, [ic]);

    let (minus_a) = negate_g1(curve_id, proof_a);
    let (pairs_main: G1G2Pair*) = alloc();
    assert pairs_main[0] = G1G2Pair(vk_x, gamma_g2);
    assert pairs_main[1] = G1G2Pair(proof_c, delta_g2);
    assert pairs_main[2] = G1G2Pair(minus_a, proof_b);
    let (F_total) = pairing_3P_select(curve_id, pairs_main);

    let (minus_beta) = negate_g2(curve_id, beta_g2);
    local minus_beta_stored: G2Point = minus_beta;
    let (pair_ab_inv: G1G2Pair*) = alloc();
    assert pair_ab_inv[0] = G1G2Pair(alpha_g1, minus_beta_stored);
    let (F_ab_inv) = pairing_1P_select(curve_id, pair_ab_inv);

    assert_eq_E12D_modp(curve_id, F_total, F_ab_inv);
    return (ok=1);
}
