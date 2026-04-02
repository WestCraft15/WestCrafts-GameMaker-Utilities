switch(async_load[? "event_type"])
{
	case "gamepad discovered":
		pad = async_load[? "pad_index"]
		gamepad_set_axis_deadzone(pad, 0)
		break
}
