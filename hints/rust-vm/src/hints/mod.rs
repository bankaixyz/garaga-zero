use std::collections::HashMap;

use cairo_vm_base::default_hints::HintImpl;

pub mod basic_field_ops;
pub mod circuits;
pub mod hash_to_curve;
pub mod utils;

pub fn get_hints() -> HashMap<String, HintImpl> {
    let mut hints = HashMap::<String, HintImpl>::new();
    hints.insert(circuits::HINT_RUN_MODULO_CIRCUIT.into(), circuits::run_modulo_circuit);
    hints.insert(
        circuits::HINT_RUN_EXTENSION_FIELD_MODULO_CIRCUIT.into(),
        circuits::run_extension_field_modulo_circuit,
    );
    hints.insert(utils::HINT_RETRIEVE_OUTPUT.into(), utils::hint_retrieve_output);
    hints.insert(basic_field_ops::HINT_UINT384_IS_LE.into(), basic_field_ops::hint_uint384_is_le);
    hints.insert(basic_field_ops::HINT_ADD_MOD_CIRCUIT.into(), basic_field_ops::hint_add_mod_circuit);
    hints.insert(basic_field_ops::HINT_NOT_ZERO_MOD_P.into(), basic_field_ops::hint_not_zero_mod_p);
    hints.insert(basic_field_ops::HINT_SUM_INV_MOD_P.into(), basic_field_ops::hint_sum_inv_mod_p);
    hints.insert(
        basic_field_ops::HINT_ADD_MUL_MOD_CIRCUIT.into(),
        basic_field_ops::hint_add_mul_mod_circuit,
    );
    hints.insert(basic_field_ops::HINT_IS_ZERO_MOD_P.into(), basic_field_ops::hint_is_zero_mod_p);
    hints.insert(
        basic_field_ops::HINT_ASSERT_NEQ_MOD_P.into(),
        basic_field_ops::hint_assert_neq_mod_p,
    );
    hints.insert(basic_field_ops::HINT_IS_EQ_MOD_P.into(), basic_field_ops::hint_is_eq_mod_p);
    hints.insert(
        basic_field_ops::HINT_IS_OPPOSITE_MOD_P.into(),
        basic_field_ops::hint_is_opposite_mod_p,
    );
    hints.insert(
        basic_field_ops::HINT_ASSERT_NOT_ZERO_MOD_P.into(),
        basic_field_ops::hint_assert_not_zero_mod_p,
    );
    hints.insert(
        utils::HINT_WRITE_FELTS_TO_VALUE_SEGMENT_1.into(),
        utils::hint_write_felts_to_value_segment_1,
    );
    hints.insert(
        utils::HINT_WRITE_FELTS_TO_VALUE_SEGMENT_2.into(),
        utils::hint_write_felts_to_value_segment_2,
    );
    hints.insert(
        utils::HINT_WRITE_FELTS_TO_VALUE_SEGMENT_3.into(),
        utils::hint_write_felts_to_value_segment_3,
    );
    hints.insert(
        utils::HINT_HASH_FULL_TRANSCRIPT_AND_GET_Z_4_LIMBS_1.into(),
        utils::hint_hash_full_transcript_and_get_z_4_limbs_1,
    );
    hints.insert(
        utils::HINT_HASH_FULL_TRANSCRIPT_AND_GET_Z_4_LIMBS_2.into(),
        utils::hint_hash_full_transcript_and_get_z_4_limbs_2,
    );
    hints.insert(hash_to_curve::HINT_MAP_TO_CURVE_G2.into(), hash_to_curve::hint_map_to_curve_g2);

    hints
}
