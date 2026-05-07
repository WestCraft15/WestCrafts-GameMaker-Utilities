settings_save = {}
player_save = {}
selected_file = 1

settings_save_dirty = false
player_save_dirty = false

do_save = false

volitile = false

save = function()
{
    volitile = true
    
	if settings_save_dirty
    {
		settings_save_dirty = false
		var _buffer = buffer_create(1, buffer_grow, 1)
		buffer_write(_buffer, buffer_text, json_stringify(settings_save, true))
		buffer_save(_buffer, "settings.json")
		buffer_delete(_buffer)
	}
    
	if player_save_dirty
    {
		player_save_dirty = false
		var _buffer = buffer_create(1, buffer_grow, 1)
		buffer_write(_buffer, buffer_text, json_stringify(player_save, SAVE_UNCOMPRESSED))
		var _buffer_compressed = buffer_compress(_buffer, 0, buffer_tell(_buffer))
		buffer_save(_buffer_compressed, string_concat("savefile", selected_file, ".sav"))
		if (SAVE_UNCOMPRESSED)
			buffer_save(_buffer, string_concat("savefile", selected_file, ".json"))
		buffer_delete(_buffer_compressed)
		buffer_delete(_buffer)
	}
    
    volitile = false
}
