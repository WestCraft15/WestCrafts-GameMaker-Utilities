// Used to specify which device a bind belongs to.
enum BIND_TYPE
{
	KEYBOARD,              // eg. vk_right
	GAMEPAD_BUTTON,        // eg. gp_face1
	GAMEPAD_AXIS_POSITIVE, // eg. gp_axislh (left stick, right)
	GAMEPAD_AXIS_NEGATIVE, // eg. gp_axislh (left stick, left)
}

// An input macro just so you don't have to type global.input every time.
#macro INPUT global.input

/// @desc Creates an input.
/// @arg {string} id The id of the input.
/// @arg {array<struct.Bind>} default_binds The array of default binds for this input.
function add_input(_id, _default_binds)
{
    global.binds[$ _id] = variable_clone(_default_binds) // TODO: Load the binds from the player's save file.
    
    global.default_binds[$ _id] = _default_binds
    
    global.input[$ _id] = false
    global.input[$ _id + "_pressed"] = false
    global.input[$ _id + "_released"] = false
}

/// @desc Creates a bind.
/// @arg {enum.BIND_TYPE} type The BIND_TYPE. Used to specify the device the input belongs to.
/// @arg {constant.VirtualKey, constant.GamepadButton, constant.GamepadAxis} input The vk or gp constant that corresponds with the key/button/axis to press.
/// @pure
function Bind(_type, _input) constructor
{
    type = _type
    input = _input
}

/// @desc Checks if an input is pressed. Internal function, no need to call this yourself.
/// @arg {array<struct.Bind>} binds The binds array for this input.
/// @return {bool} Whether the input is pressed.
/// @pure
/// @ignore
function input_check(_binds)
{
	for (var i = 0; i < array_length(_binds); i++)
    {
		var _bind = _binds[i]
		switch _bind.type
        {
			case BIND_TYPE.KEYBOARD:
				if keyboard_check(_bind.input) return true
			case BIND_TYPE.GAMEPAD_BUTTON:
				if gamepad_button_check(obj_input_manager.pad, _bind.input) return true
			case BIND_TYPE.GAMEPAD_AXIS_POSITIVE:
				if gamepad_axis_value(obj_input_manager.pad, _bind.input) >= global.controller_deadzone return true
			case BIND_TYPE.GAMEPAD_AXIS_NEGATIVE:
				if gamepad_axis_value(obj_input_manager.pad, _bind.input) <= -global.controller_deadzone return true
		}
	}
	return false
}

/// @desc Checks if an input was pressed this frame. Internal function, no need to call this yourself.
/// @arg {array<struct.Bind>} binds The binds array for this input.
/// @return {bool} Whether the input was pressed this frame.
/// @pure
/// @ignore
function input_check_pressed(_binds)
{
	for (var i = 0; i < array_length(_binds); i++)
    {
		var _bind = _binds[i]
		switch _bind.type
        {
			case BIND_TYPE.KEYBOARD:
				if keyboard_check_pressed(_bind.input) return true
			case BIND_TYPE.GAMEPAD_BUTTON:
				if gamepad_button_check_pressed(obj_input_manager.pad, _bind.input) return true
			case BIND_TYPE.GAMEPAD_AXIS_POSITIVE:
				if gamepad_axis_value(obj_input_manager.pad, _bind.input) >= global.controller_deadzone && obj_input_manager.gamepad_axis_previous[? _bind.input] < global.controller_deadzone return true
			case BIND_TYPE.GAMEPAD_AXIS_NEGATIVE:
				if gamepad_axis_value(obj_input_manager.pad, _bind.input) <= -global.controller_deadzone && obj_input_manager.gamepad_axis_previous[? _bind.input] > -global.controller_deadzone return true
		}
	}
	return false
}

/// @desc Checks if an input was released this frame. Internal function, no need to call this yourself. 
/// @arg {array<struct.Bind>} binds The binds array for this input.
/// @return {bool} Whether the input was released this frame.
/// @pure
/// @ignore
function input_check_released(_binds)
{
	for (var i = 0; i < array_length(_binds); i++)
    {
		var _bind = _binds[i]
		switch _bind.type
        {
			case BIND_TYPE.KEYBOARD:
				if keyboard_check_released(_bind.input) return true
			case BIND_TYPE.GAMEPAD_BUTTON:
				if gamepad_button_check_released(obj_input_manager.pad, _bind.input) return true
			case BIND_TYPE.GAMEPAD_AXIS_POSITIVE:
				if gamepad_axis_value(obj_input_manager.pad, _bind.input) < global.controller_deadzone && obj_input_manager.gamepad_axis_previous[? _bind.input] >= global.controller_deadzone return true
			case BIND_TYPE.GAMEPAD_AXIS_NEGATIVE:
				if gamepad_axis_value(obj_input_manager.pad, _bind.input) > -global.controller_deadzone && obj_input_manager.gamepad_axis_previous[? _bind.input] <= -global.controller_deadzone return true
		}
	}
	return false
}
