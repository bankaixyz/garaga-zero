from starkware.cairo.common.registers import get_fp_and_pc, get_label_location
from modulo_circuit import (
    ExtensionFieldModuloCircuit,
    ModuloCircuit,
    get_void_modulo_circuit,
    get_void_extension_field_modulo_circuit,
)
from definitions import bn, bls

func get_ADD_EC_POINTS_G2_circuit(curve_id: felt) -> (circuit: ModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 0;
    let input_len = 32;
    let witnesses_len = 8;
    let output_len = 16;
    let continuous_output = 0;
    let add_mod_n = 19;
    let mul_mod_n = 10;
    let n_assert_eq = 2;
    let name = 'add_ec_points_g2';
    let curve_id = curve_id;
    local circuit: ModuloCircuit = ModuloCircuit(
        constants_ptr,
        add_offsets_ptr,
        mul_offsets_ptr,
        output_offsets_ptr,
        constants_ptr_len,
        input_len,
        witnesses_len,
        output_len,
        continuous_output,
        add_mod_n,
        mul_mod_n,
        n_assert_eq,
        name,
        curve_id,
    );
    return (&circuit,);

    constants_ptr_loc:

    add_offsets_ptr_loc:
    dw 24;  // Fp2 sub coeff 0/1
    dw 40;
    dw 8;
    dw 28;  // Fp2 sub coeff 1/1
    dw 44;
    dw 12;
    dw 16;  // Fp2 sub coeff 0/1
    dw 48;
    dw 0;
    dw 20;  // Fp2 sub coeff 1/1
    dw 52;
    dw 4;
    dw 32;  // None
    dw 36;
    dw 72;
    dw 36;  // None
    dw 76;
    dw 32;
    dw 84;  // None
    dw 84;
    dw 88;
    dw 0;  // Fp2 sub coeff 0/1
    dw 92;
    dw 80;
    dw 4;  // Fp2 sub coeff 1/1
    dw 96;
    dw 88;
    dw 16;  // Fp2 sub coeff 0/1
    dw 100;
    dw 92;
    dw 20;  // Fp2 sub coeff 1/1
    dw 104;
    dw 96;
    dw 100;  // Fp2 sub coeff 0/1
    dw 108;
    dw 0;
    dw 104;  // Fp2 sub coeff 1/1
    dw 112;
    dw 4;
    dw 120;  // Fp2 mul real part end
    dw 124;
    dw 116;
    dw 128;  // Fp2 mul imag part end
    dw 132;
    dw 136;
    dw 8;  // Fp2 sub coeff 0/1
    dw 140;
    dw 124;
    dw 12;  // Fp2 sub coeff 1/1
    dw 144;
    dw 136;
    dw 40;  // None
    dw 60;
    dw 56;
    dw 64;  // None
    dw 68;
    dw 44;

    mul_offsets_ptr_loc:
    dw 32;  // None
    dw 48;
    dw 56;
    dw 36;  // None
    dw 52;
    dw 60;
    dw 32;  // None
    dw 52;
    dw 64;
    dw 36;  // None
    dw 48;
    dw 68;
    dw 72;  // None
    dw 76;
    dw 80;
    dw 32;  // None
    dw 36;
    dw 84;
    dw 32;  // Fp2 mul start
    dw 108;
    dw 116;
    dw 36;  // None
    dw 112;
    dw 120;
    dw 32;  // None
    dw 112;
    dw 128;
    dw 36;  // None
    dw 108;
    dw 132;

    output_offsets_ptr_loc:
    dw 100;
    dw 104;
    dw 140;
    dw 144;
}

func get_ADD_EC_POINT_circuit(curve_id: felt) -> (circuit: ModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 0;
    let input_len = 16;
    let witnesses_len = 0;
    let output_len = 8;
    let continuous_output = 0;
    let add_mod_n = 6;
    let mul_mod_n = 3;
    let n_assert_eq = 0;
    let name = 'add_ec_point';
    let curve_id = curve_id;
    local circuit: ModuloCircuit = ModuloCircuit(
        constants_ptr,
        add_offsets_ptr,
        mul_offsets_ptr,
        output_offsets_ptr,
        constants_ptr_len,
        input_len,
        witnesses_len,
        output_len,
        continuous_output,
        add_mod_n,
        mul_mod_n,
        n_assert_eq,
        name,
        curve_id,
    );
    return (&circuit,);

    constants_ptr_loc:

    add_offsets_ptr_loc:
    dw 12;  // None
    dw 16;
    dw 4;
    dw 8;  // None
    dw 20;
    dw 0;
    dw 0;  // None
    dw 32;
    dw 28;
    dw 8;  // None
    dw 36;
    dw 32;
    dw 36;  // None
    dw 40;
    dw 0;
    dw 4;  // None
    dw 48;
    dw 44;

    mul_offsets_ptr_loc:
    dw 20;  // None
    dw 24;
    dw 16;
    dw 24;  // None
    dw 24;
    dw 28;
    dw 24;  // None
    dw 40;
    dw 44;

    output_offsets_ptr_loc:
    dw 36;
    dw 48;
}

func get_DECOMPRESS_G1_POINT_circuit(curve_id: felt) -> (circuit: ModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 1;
    let input_len = 8;
    let witnesses_len = 4;
    let output_len = 8;
    let continuous_output = 0;
    let add_mod_n = 2;
    let mul_mod_n = 3;
    let n_assert_eq = 1;
    let name = 'decompress_g1_point';
    let curve_id = curve_id;
    local circuit: ModuloCircuit = ModuloCircuit(
        constants_ptr,
        add_offsets_ptr,
        mul_offsets_ptr,
        output_offsets_ptr,
        constants_ptr_len,
        input_len,
        witnesses_len,
        output_len,
        continuous_output,
        add_mod_n,
        mul_mod_n,
        n_assert_eq,
        name,
        curve_id,
    );
    return (&circuit,);

    constants_ptr_loc:
    dw 0;
    dw 0;
    dw 0;
    dw 0;

    add_offsets_ptr_loc:
    dw 20;  // None
    dw 4;
    dw 24;
    dw 12;  // None
    dw 28;
    dw 0;

    mul_offsets_ptr_loc:
    dw 8;  // None
    dw 8;
    dw 16;
    dw 8;  // None
    dw 16;
    dw 20;
    dw 12;  // Fp sqrt
    dw 12;
    dw 24;

    output_offsets_ptr_loc:
    dw 12;
    dw 28;
}

func get_DERIVE_POINT_FROM_X_circuit(curve_id: felt) -> (circuit: ModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 0;
    let input_len = 16;
    let witnesses_len = 8;
    let output_len = 20;
    let continuous_output = 0;
    let add_mod_n = 2;
    let mul_mod_n = 6;
    let n_assert_eq = 0;
    let name = 'derive_point_from_x';
    let curve_id = curve_id;
    local circuit: ModuloCircuit = ModuloCircuit(
        constants_ptr,
        add_offsets_ptr,
        mul_offsets_ptr,
        output_offsets_ptr,
        constants_ptr_len,
        input_len,
        witnesses_len,
        output_len,
        continuous_output,
        add_mod_n,
        mul_mod_n,
        n_assert_eq,
        name,
        curve_id,
    );
    return (&circuit,);

    constants_ptr_loc:

    add_offsets_ptr_loc:
    dw 32;  // None
    dw 8;
    dw 36;
    dw 28;  // None
    dw 36;
    dw 40;

    mul_offsets_ptr_loc:
    dw 0;  // None
    dw 0;
    dw 24;
    dw 0;  // None
    dw 24;
    dw 28;
    dw 4;  // None
    dw 0;
    dw 32;
    dw 12;  // None
    dw 40;
    dw 44;
    dw 16;  // None
    dw 16;
    dw 48;
    dw 20;  // None
    dw 20;
    dw 52;

    output_offsets_ptr_loc:
    dw 40;
    dw 44;
    dw 48;
    dw 52;
    dw 16;
}

func get_DOUBLE_EC_POINT_circuit(curve_id: felt) -> (circuit: ModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 1;
    let input_len = 12;
    let witnesses_len = 0;
    let output_len = 8;
    let continuous_output = 0;
    let add_mod_n = 6;
    let mul_mod_n = 5;
    let n_assert_eq = 0;
    let name = 'double_ec_point';
    let curve_id = curve_id;
    local circuit: ModuloCircuit = ModuloCircuit(
        constants_ptr,
        add_offsets_ptr,
        mul_offsets_ptr,
        output_offsets_ptr,
        constants_ptr_len,
        input_len,
        witnesses_len,
        output_len,
        continuous_output,
        add_mod_n,
        mul_mod_n,
        n_assert_eq,
        name,
        curve_id,
    );
    return (&circuit,);

    constants_ptr_loc:
    dw 3;
    dw 0;
    dw 0;
    dw 0;

    add_offsets_ptr_loc:
    dw 20;  // None
    dw 12;
    dw 24;
    dw 8;  // None
    dw 8;
    dw 28;
    dw 4;  // None
    dw 40;
    dw 36;
    dw 4;  // None
    dw 44;
    dw 40;
    dw 44;  // None
    dw 48;
    dw 4;
    dw 8;  // None
    dw 56;
    dw 52;

    mul_offsets_ptr_loc:
    dw 4;  // None
    dw 4;
    dw 16;
    dw 0;  // None
    dw 16;
    dw 20;
    dw 28;  // None
    dw 32;
    dw 24;
    dw 32;  // None
    dw 32;
    dw 36;
    dw 32;  // None
    dw 48;
    dw 52;

    output_offsets_ptr_loc:
    dw 44;
    dw 56;
}

func get_IS_ON_CURVE_G1_G2_circuit(curve_id: felt) -> (circuit: ModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 0;
    let input_len = 40;
    let witnesses_len = 0;
    let output_len = 12;
    let continuous_output = 1;
    let add_mod_n = 16;
    let mul_mod_n = 13;
    let n_assert_eq = 0;
    let name = 'is_on_curve_g1_g2';
    let curve_id = curve_id;
    local circuit: ModuloCircuit = ModuloCircuit(
        constants_ptr,
        add_offsets_ptr,
        mul_offsets_ptr,
        output_offsets_ptr,
        constants_ptr_len,
        input_len,
        witnesses_len,
        output_len,
        continuous_output,
        add_mod_n,
        mul_mod_n,
        n_assert_eq,
        name,
        curve_id,
    );
    return (&circuit,);

    constants_ptr_loc:

    add_offsets_ptr_loc:
    dw 48;  // None
    dw 28;
    dw 52;
    dw 16;  // None
    dw 20;
    dw 56;
    dw 20;  // None
    dw 60;
    dw 16;
    dw 68;  // None
    dw 68;
    dw 72;
    dw 8;  // None
    dw 12;
    dw 76;
    dw 12;  // None
    dw 80;
    dw 8;
    dw 88;  // None
    dw 88;
    dw 92;
    dw 100;  // Fp2 mul real part end
    dw 104;
    dw 96;
    dw 108;  // Fp2 mul imag part end
    dw 112;
    dw 116;
    dw 120;  // None
    dw 32;
    dw 128;
    dw 124;  // None
    dw 36;
    dw 132;
    dw 104;  // None
    dw 128;
    dw 136;
    dw 116;  // None
    dw 132;
    dw 140;
    dw 52;  // None
    dw 144;
    dw 40;
    dw 136;  // None
    dw 148;
    dw 64;
    dw 140;  // None
    dw 152;
    dw 72;

    mul_offsets_ptr_loc:
    dw 4;  // None
    dw 4;
    dw 40;
    dw 0;  // None
    dw 0;
    dw 44;
    dw 0;  // None
    dw 44;
    dw 48;
    dw 56;  // None
    dw 60;
    dw 64;
    dw 16;  // None
    dw 20;
    dw 68;
    dw 76;  // None
    dw 80;
    dw 84;
    dw 8;  // None
    dw 12;
    dw 88;
    dw 8;  // Fp2 mul start
    dw 84;
    dw 96;
    dw 12;  // None
    dw 92;
    dw 100;
    dw 8;  // None
    dw 92;
    dw 108;
    dw 12;  // None
    dw 84;
    dw 112;
    dw 24;  // None
    dw 8;
    dw 120;
    dw 24;  // None
    dw 12;
    dw 124;

    output_offsets_ptr_loc:
    dw 144;
}

func get_IS_ON_CURVE_G1_circuit(curve_id: felt) -> (circuit: ModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 0;
    let input_len = 16;
    let witnesses_len = 0;
    let output_len = 4;
    let continuous_output = 1;
    let add_mod_n = 3;
    let mul_mod_n = 4;
    let n_assert_eq = 0;
    let name = 'is_on_curve_g1';
    let curve_id = curve_id;
    local circuit: ModuloCircuit = ModuloCircuit(
        constants_ptr,
        add_offsets_ptr,
        mul_offsets_ptr,
        output_offsets_ptr,
        constants_ptr_len,
        input_len,
        witnesses_len,
        output_len,
        continuous_output,
        add_mod_n,
        mul_mod_n,
        n_assert_eq,
        name,
        curve_id,
    );
    return (&circuit,);

    constants_ptr_loc:

    add_offsets_ptr_loc:
    dw 28;  // None
    dw 12;
    dw 32;
    dw 24;  // None
    dw 32;
    dw 36;
    dw 36;  // None
    dw 40;
    dw 16;

    mul_offsets_ptr_loc:
    dw 4;  // None
    dw 4;
    dw 16;
    dw 0;  // None
    dw 0;
    dw 20;
    dw 0;  // None
    dw 20;
    dw 24;
    dw 8;  // None
    dw 0;
    dw 28;

    output_offsets_ptr_loc:
    dw 40;
}
