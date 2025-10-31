%builtins range_check bitwise poseidon range_check96 add_mod mul_mod

from starkware.cairo.common.cairo_builtins import PoseidonBuiltin, ModBuiltin, UInt384, BitwiseBuiltin
from starkware.cairo.common.uint256 import Uint256
from groth16.vk_constants_sp1 import verify_sp1_groth16_bn254
from definitions import G1Point, G2Point
from starkware.cairo.common.alloc import alloc
from sha import SHA256
from utils import pow2alloc128

func main{
    range_check_ptr,
    bitwise_ptr: BitwiseBuiltin*,
    poseidon_ptr: PoseidonBuiltin*,
    range_check96_ptr: felt*,
    add_mod_ptr: ModBuiltin*,
    mul_mod_ptr: ModBuiltin*,
}() {
    alloc_locals;
    // Allocate public values buffer
    let (pv_ptr) = alloc();
    local n_words;
    // Locals for points and scalars to be filled via hints
    local a: G1Point;
    local b: G2Point;
    local c: G1Point;
    local vkey: Uint256;

    %{
        import json
        from garaga.hints.io import to_int, fill_uint256, fill_g1_point, bigint_fill, fill_felt_ptr

        DEFAULT_PROOF_JSON = (
            "tests/fustat_programs/test_sp1_verify.json"
        )
        proof_path = (
            program_input.get("sp1_proof_path")
            or program_input.get("proof_path")
            or DEFAULT_PROOF_JSON
        )
        data = json.loads(open(proof_path, "r").read())

        # vkey
        vkey_int = to_int(data["vkey"])
        fill_uint256(vkey_int, ids.vkey)

        # proof -> coordinates
        proof_hex = data["proof"]
        b = bytes.fromhex(proof_hex[2:] if proof_hex.startswith("0x") else proof_hex)
        assert len(b) >= 4 + 32 * 8, "Unexpected SP1 proof length"
        b = b[4:]  # skip selector
        ax = int.from_bytes(b[0:32], "big")
        ay = int.from_bytes(b[32:64], "big")
        # G2 ordering as in tools/make/gen_sp1_test_program.py
        bx0 = int.from_bytes(b[96:128], "big")
        bx1 = int.from_bytes(b[64:96], "big")
        by0 = int.from_bytes(b[160:192], "big")
        by1 = int.from_bytes(b[128:160], "big")
        cx = int.from_bytes(b[192:224], "big")
        cy = int.from_bytes(b[224:256], "big")

        fill_g1_point((ax, ay), ids.a)
        bigint_fill(bx0, ids.b.x0, 4, 2**96)
        bigint_fill(bx1, ids.b.x1, 4, 2**96)
        bigint_fill(by0, ids.b.y0, 4, 2**96)
        bigint_fill(by1, ids.b.y1, 4, 2**96)
        fill_g1_point((cx, cy), ids.c)

        # public values -> u32 words (big-endian)
        pv_hex = data["publicValues"]
        pv_bytes = bytes.fromhex(pv_hex[2:] if pv_hex.startswith("0x") else pv_hex)
        assert len(pv_bytes) % 4 == 0
        words = [int.from_bytes(pv_bytes[i:i+4], "big") for i in range(0, len(pv_bytes), 4)]
        fill_felt_ptr(words, memory, ids.pv_ptr)
        ids.n_words = len(words)
    %}

    let (pow2_array) = pow2alloc128();
    let (sha256_ptr, sha256_ptr_start) = SHA256.init();
    with sha256_ptr, pow2_array {
        let (ok) = verify_sp1_groth16_bn254(
            vkey=vkey,
            public_values_len_words=n_words,
            public_values_words=pv_ptr,
            proof_a=a,
            proof_b=b,
            proof_c=c,
        );
    }
    SHA256.finalize(sha256_ptr_start, sha256_ptr);
    assert ok = 1;
    return ();
}
