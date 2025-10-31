from starkware.cairo.common.cairo_builtins import PoseidonBuiltin, ModBuiltin, UInt384, BitwiseBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.uint256 import Uint256

from definitions import G1Point, G2Point, G1G2Pair, bn
from groth16.verifier import verify_groth16_generic
from sha import SHA256, HashUtils
from utils import pow2alloc128, felt_divmod, bitwise_divmod


// ---- SP1 (BN254) VK constants ----

func get_SP1_BN254_N_PUBLIC_INPUTS() -> (res: felt) {
    return (res=2);
}

// IC as contiguous blob of UInt384 limbs: [x0, y0, x1, y1, ..., xN, yN]
func get_SP1_BN254_IC() -> (ic: G1Point*) {
    let (ic_ptr: felt*) = alloc();
    let ic: G1Point* = cast(ic_ptr, G1Point*);
    // ic[0]
    assert ic[0] = G1Point(
        UInt384(0x33db734c451d28b58aa9758e, 0x4ea0a694cd3743ebf5247792, 0x26091e1cafb0ad8a, 0x0),
        UInt384(0xefa65a3e782e7ba70b66690e, 0xca6fdb2690a124f8ce25489f, 0x9ff50a6b8b11c3, 0x0)
    );
    // ic[1]
    assert ic[1] = G1Point(
        UInt384(0xec878755e537c1c48951fb4c, 0x2607c227d090cca750ed36c6, 0x61c3fd0fd3da25d, 0x0),
        UInt384(0x3e6119a212dd09eb51707219, 0xdf7b5c65eff0e107055e9a27, 0xfa17ae9c2033379, 0x0)
    );
    // ic[2]
    assert ic[2] = G1Point(
        UInt384(0xa16028dee020634fd129e71c, 0x7fe0e0e2ead0b2ec4ffdec51, 0x4eab241388a7981, 0x0),
        UInt384(0xca56b18d5544b0889a65c1f5, 0x2f0bdbf95cff83e03ea9e16f, 0x7236256d21c60d0, 0x0)
    );
    return (ic=ic);
}

func get_SP1_BN254_ALPHA_G1() -> (p: G1Point) {
    return (p=G1Point(UInt384(0xb16c643b22f599a2be6df2e2, 0x41749d5507949d05dbea33fb, 0x2d4d9aa7e302d9df, 0x0), UInt384(0x19230301f076caff004d1926, 0x61d8ec60209fe345ce89830a, 0x14bedd503c37ceb0, 0x0)));
}

func get_SP1_BN254_BETA_G2() -> (p: G2Point) {
    return (
        p=G2Point(
            UInt384(0xe071241e0213bc7fc13db7ab, 0x74d0d6732bf501847dd68bc0, 0xe187847ad4c7983, 0x0), UInt384(0x53f2decaa9794cbc3bf3060c, 0xafc985f88877f182d38480a6, 0x967032fcbf776d1, 0x0),
            UInt384(0x3eea05a9d57f06547ad0cec8, 0x313123d24d2f9192f896b7c6, 0x1739c1b1a457a8c7, 0x0), UInt384(0x6b7a0d379da69a4d112346a7, 0x99f5e847d93f8c3caafddec4, 0x304cfbd1e08a704a, 0x0)
        )
    );
}

func get_SP1_BN254_GAMMA_G2() -> (p: G2Point) {
    return (
        p=G2Point(
            UInt384(0xf75edadd46debd5cd992f6ed, 0x426a00665e5c4479674322d4, 0x1800deef121f1e76, 0x0), UInt384(0x35a9e71297e485b7aef312c2, 0x7260bfb731fb5d25f1aa4933, 0x198e9393920d483a, 0x0),
            UInt384(0xc43d37b4ce6cc0166fa7daa, 0x4aab71808dcb408fe3d1e769, 0x12c85ea5db8c6deb, 0x0), UInt384(0x70b38ef355acdadcd122975b, 0xec9e99ad690c3395bc4b3133, 0x90689d0585ff075, 0x0)
        )
    );
}

func get_SP1_BN254_DELTA_G2() -> (p: G2Point) {
    return (
        p=G2Point(
            UInt384(0x777a63b327d736bffb0122ed, 0x2caf27354d28e4b8f83d3b76, 0x3ff41f4ba0c37fe, 0x0), UInt384(0xc020024521998269845f74e6, 0x21f01ecc9b46d236e0865e0c, 0x1cc7cb8de715675f, 0x0),
            UInt384(0x264a04499f7e2f6df690dd85, 0x909b4f1c3d80fcd6865afc4a, 0x17387b4b9cf03927, 0x0), UInt384(0xf614f4fd11b56b3c5e53c44c, 0xd19a3d72dcd590ac85a971de, 0x2ed3b19b5eb39db0, 0x0)
        )
    );
}


// ---- SP1 BN254 verifier wrapper ----

func compute_pub_input_hash_253{
    range_check_ptr,
    bitwise_ptr: BitwiseBuiltin*,
    sha256_ptr: felt*,
    pow2_array: felt*,
}(
    public_values_words: felt*,
    public_values_len_words: felt,
) -> (pub_hash: Uint256) {
    alloc_locals;
    let (digest_ptr) = SHA256.hash_bytes(public_values_words, public_values_len_words * 4);
    let pub_hash_uint = HashUtils.chunks_to_uint256(digest_ptr);
    let (q_high, high_trunc) = bitwise_divmod(pub_hash_uint.high, pow2_array[125]);
    let pub_hash: Uint256 = Uint256(low=pub_hash_uint.low, high=high_trunc);
    return (pub_hash=pub_hash);
}

func verify_sp1_groth16_bn254{
    range_check_ptr,
    bitwise_ptr: BitwiseBuiltin*,
    poseidon_ptr: PoseidonBuiltin*,
    range_check96_ptr: felt*,
    add_mod_ptr: ModBuiltin*,
    mul_mod_ptr: ModBuiltin*,
    pow2_array: felt*,
    sha256_ptr: felt*,
}(
    vkey: Uint256,
    public_values_len_words: felt,
    public_values_words: felt*,
    proof_a: G1Point,
    proof_b: G2Point,
    proof_c: G1Point,
) -> (ok: felt) {
    alloc_locals;
    let (pub_hash) = compute_pub_input_hash_253(public_values_words, public_values_len_words);

    // Assemble scalars [vkey, pub_hash]
    let (scalars: Uint256*) = alloc();
    assert scalars[0] = vkey;
    assert scalars[1] = pub_hash;

    // Load embedded SP1 Groth16 VK
    let (n_pub) = get_SP1_BN254_N_PUBLIC_INPUTS();
    let (ic) = get_SP1_BN254_IC();
    let (alpha_g1) = get_SP1_BN254_ALPHA_G1();
    let (beta_g2) = get_SP1_BN254_BETA_G2();
    let (gamma_g2) = get_SP1_BN254_GAMMA_G2();
    let (delta_g2) = get_SP1_BN254_DELTA_G2();

    let (ok) = verify_groth16_generic(
        curve_id=bn.CURVE_ID,
        n_public_inputs=n_pub,
        ic=ic,
        alpha_g1=alpha_g1,
        beta_g2=beta_g2,
        gamma_g2=gamma_g2,
        delta_g2=delta_g2,
        proof_a=proof_a,
        proof_b=proof_b,
        proof_c=proof_c,
        public_inputs=scalars,
    );
    return (ok=ok);
}



