global.controller_deadzone = DEFAULT_CONTROLLER_DEADZONE // TODO: Save and load this value.

global.binds = {}
global.default_binds = {}
global.input = {}

init_input()

gamepad_axis_previous = ds_map_create()
gamepad_axis_previous[? gp_axislh] = 0
gamepad_axis_previous[? gp_axislv] = 0
gamepad_axis_previous[? gp_axisrh] = 0
gamepad_axis_previous[? gp_axisrv] = 0

pad = 0
