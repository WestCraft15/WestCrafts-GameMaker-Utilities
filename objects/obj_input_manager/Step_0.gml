var _binds = struct_get_names(global.binds)
var _num_binds = array_length(_binds)

for (var i = 0; i < _num_binds; i++)
{
    var _bind_id = _binds[i]
    var _bind = global.binds[$ _bind_id]
    
    global.input[$ _bind_id] = input_check(_bind)
    global.input[$ _bind_id + "_pressed"] = input_check_pressed(_bind)
    global.input[$ _bind_id + "_released"] = input_check_released(_bind)
}

gamepad_axis_previous[? gp_axislh] = gamepad_axis_value(pad, gp_axislh)
gamepad_axis_previous[? gp_axislv] = gamepad_axis_value(pad, gp_axislv)
gamepad_axis_previous[? gp_axisrh] = gamepad_axis_value(pad, gp_axisrh)
gamepad_axis_previous[? gp_axisrv] = gamepad_axis_value(pad, gp_axisrv)
