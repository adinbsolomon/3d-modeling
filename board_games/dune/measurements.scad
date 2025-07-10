
include <../../common/units.scad>

// TODO
// - Measure many stacks of randomly distributed sleeved cards and average the average card thicknesses
// - Add counts for various kinds of cards, small cards, tech tiles, contracts to enable organizing in
//   sections instead of requiring the whole. This could enable easier setup, but if organizing into
//   those categories is necessary on cleanup that might present an annoying cost.

// Box Measurements
// - These are internal measurements
// - Box is square
// - Both base game boxes are the same
// - Expansion boxes are half-height (needs to be double-checked)
_m_box_length = 11 * inch; // 11 inch = 279.4 mm
_m_box_height = 79;
_m_box_wall_thickness = 1; // TODO

// Rulebook Measurements
// - I don't think optimizing for rulebook thickness and placement matters
//   enough because it would make packing the game really annoying.
// - All rulebooks will just be in a stack on top
// - The functional impact of the rulebooks is to reduce box height
_m_rulebook_thickness = 3;

// Board Measurements
// - Version shorthand:
//   - di = Dune Imperium
//   - ix = Rise of Ix
//   - im = Immortality
//   - up = Dune Imperium Uprising
//   - bl = Bloodlines
_m_board_thickness = 2.5; // all boards have this thickness
_m_board_main_thickness = 4 * _m_board_thickness; // folded twice
_m_board_uprising_thickness = 4 * _m_board_thickness; // folded twice
_m_board_uprising_6p_length = 5.5 * inch;
_m_board_uprising_6p_width = 5.7 * inch;
_m_board_ix_shipping_thickness = 2 * _m_board_thickness; // folded once
_m_board_ix_shipping_length = 117;
_m_board_ix_shipping_width = 7.25 * inch;
_m_board_ix_tech_length = 7.3 * inch;
_m_board_ix_tech_width = 7.3 * inch;
_m_board_im_length = 10 * inch;
_m_board_im_width = 180;
_m_board_bl_length = 51 + 5.5 * inch; // ~190
_m_board_bl_width = 87;

// Leader Card Measurements
_m_leader_length = 146;
_m_leader_width = 102;
_m_leader_stack_thickness = 13;

// Tile Measurements
// - Counts for different versions are based on whether the version's mechanics are required
_m_tile_thickness = 0; // TOOD
_m_tile_tech_length = 45; // TODO
_m_tile_tech_width = 30; // TODO
_m_tile_tech_stack_thickness = 0; // TODO
_m_tile_tech_ix_count = 0; // TODO
_m_tile_tech_bl_count = 0; // TODO
_m_tile_contract_length = 54;
_m_tile_contract_width = 34;
_m_tile_contract_stack_thickness = 80;
_m_tile_contract_up_count = 0; // TODO
_m_tile_contract_ix_count = 0; // TODO
_m_tile_contract_im_count = 0; // TODO
_m_tile_sardukar_length = 46;
_m_tile_sardukar_width = 46;
_m_tile_sardukar_width_2 = 0; // TODO
_m_tile_sardukar_stack_thickness = 30;

// Card Measurements
// - These are measured with dragonsheild sleeves on
// - Counts for different versions are based on release
// - Static cards are Arrakis Liason, Spice Must Flow, Foldspace, and Prepare the Way
_m_card_length = 99.1;
_m_card_width = 66.3;
_m_card_thickness = 0; // TODO
_m_card_starter_di_count = 0; // TODO
_m_card_starter_ix_count = 0; // TODO
_m_card_starter_im_count = 0; // TODO
_m_card_starter_up_count = 0; // TODO
_m_card_static_di_count = 0; // TODO
_m_card_static_up_count = 0; // TODO
_m_card_imperium_di_count = 0; // TODO
_m_card_imperium_ix_count = 0; // TODO
_m_card_imperium_im_count = 0; // TODO
_m_card_imperium_up_count = 0; // TODO
_m_card_imperium_bl_count = 0; // TODO
_m_card_tleilax_count = 0; // TODO
_m_card_up_6p_count = 0; // TODO
_m_card_length_unsleeved = 0; // TODO
_m_card_width_unsleeved = 0; // TODO
_m_card_thickness_unsleeved = 0; // TODO
_m_card_hagal_count = 0; // TODO - no version categories needed because use is uncommon
_m_card_rival_count = 0; // TODO - no version categories needed because use is uncommon

// Small Card Measurements
_m_scard_length = 0; // TODO
_m_scard_width = 0; // TODO
_m_scard_intrigue_stack_thickness = 0; // TODO
_m_scard_conflict_stack_thickness = 0; // TODO
_m_scard_navigation_stack_thickness = 0; // TODO

// Game Piece Measurements
// - TODO - all of this :)
