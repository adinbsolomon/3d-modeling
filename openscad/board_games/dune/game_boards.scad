
include <measurements.scad>

module _board_main() {
  cube(
    [
      _m_board_main_length,
      _m_board_main_length,
      _m_board_main_thickness,
    ]
  );
}

module _board_uprising() {
  _board_main();
}

module _board_uprising_6p(both = false, stacked = false) {
  cube(
    [
      _m_board_uprising_6p_length * (both && !stacked ? 2 : 1),
      _m_board_uprising_6p_width,
      _m_board_thickness * (both && stacked ? 2 : 1),
    ]
  );
}

module _board_ix_shipping() {
  cube(
    [
      _m_board_ix_shipping_length,
      _m_board_ix_shipping_width,
      _m_board_ix_shipping_thickness,
    ]
  );
}

module _board_ix_tech() {
  cube(
    [
      _m_board_ix_tech_length,
      _m_board_ix_tech_width,
      _m_board_thickness,
    ]
  );
}

module _board_im() {
  cube(
    [
      _m_board_im_length,
      _m_board_im_width,
      _m_board_thickness,
    ]
  );
}

module _board_bl() {
  cube(
    [
      _m_board_bl_length,
      _m_board_bl_width,
      _m_board_thickness,
    ]
  );
}

module _board_configuration_001() {
  // Tier 1
  _board_main();
  translate(
    [
      0,
      0,
      _m_board_main_thickness,
    ]
  )
    _board_uprising();
  // Tier 2
  translate(
    [
      0,
      0,
      _m_board_main_thickness + _m_board_uprising_thickness,
    ]
  )
    _board_bl();
  translate(
    [
      0,
      _m_board_bl_width,
      _m_board_main_thickness + _m_board_uprising_thickness,
    ]
  )
    _board_ix_tech();
  // Tier 3
  translate(
    [
      0,
      0,
      _m_board_main_thickness + _m_board_uprising_thickness + _m_board_thickness,
    ]
  )
    mirror([-1, 1, 0])
      _board_im();
  // Tier 4
  translate(
    [
      0,
      0,
      _m_board_main_thickness + _m_board_uprising_thickness + 2 * _m_board_thickness,
    ]
  )
    mirror([-1, 1, 0])
      _board_uprising_6p(both=true);
  // Tier 5
  translate(
    [
      0,
      0,
      _m_board_main_thickness + _m_board_uprising_thickness + 3 * _m_board_thickness,
    ]
  )
    _board_ix_shipping();
}

module _board_configuration_002() {
  // Tier 1
  _board_main();
  translate(
    [
      0,
      0,
      _m_board_main_thickness,
    ]
  )
    _board_uprising();
  // Tier 2
  translate(
    [
      0,
      0,
      _m_board_main_thickness + _m_board_uprising_thickness,
    ]
  )
    _board_ix_tech();
  translate(
    [
      0,
      _m_board_ix_tech_width,
      _m_board_main_thickness + _m_board_uprising_thickness,
    ]
  )
    _board_bl();
  // Tier 3
  translate(
    [
      0,
      0,
      _m_board_main_thickness + _m_board_uprising_thickness + _m_board_thickness,
    ]
  )
    mirror([-1, 1, 0])
      _board_im();
  // Tier 4
  translate(
    [
      0,
      0,
      _m_board_main_thickness + _m_board_uprising_thickness + 2 * _m_board_thickness,
    ]
  )
    mirror([-1, 1, 0])
      _board_ix_shipping();
  translate(
    [
      0,
      _m_board_ix_shipping_length,
      _m_board_main_thickness + _m_board_uprising_thickness + 2 * _m_board_thickness,
    ]
  )
    _board_uprising_6p(both=true, stacked=true);
}

_board_configuration_002();
