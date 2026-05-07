///@desc Write a value to the global settings file. Functions similarly to `ini_write_real` and `ini_write_string`, but with no limitation on the variable type.
///@arg {string} section The section of the save to write to.
///@arg {string} key The key within the relevant section of the save to write to.
///@arg {any} value The value to write to the relevant destination.
function settings_save_write(_section, _key, _value)
{
    with (obj_savefile_manager)
    {
        settings_save_dirty = true
        settings_save[$ _section] ??= {}
        settings_save[$ _section][$ _key] = _value
    }
}

///@desc Write a value to the player's current save file. Functions similarly to `ini_write_real` and `ini_write_string`, but with no limitation on the variable type.
///@arg {string} section The section of the save to write to.
///@arg {string} key The key within the relevant section of the save to write to.
///@arg {any} value The value to write to the relevant destination.
function player_save_write(_section, _key, _value)
{
    with (obj_savefile_manager)
    {
        player_save_dirty = true
        player_save[$ _section] ??= {}
        player_save[$ _section][$ _key] = _value
    }
}

///@desc Read a value from the global settings file. Functions similarly to `ini_read_real` and `ini_read_string`, but with no limitation on the variable type.
///@arg {string} section The section of the save to read from.
///@arg {string} key The key within the relevant section of the save to read from.
///@arg {any} default The value to return if a value is not found in the defined place.
///@return {any} The value read from the file, or `default` if none is found.
function settings_save_read(_section, _key, _default)
{
    with (obj_savefile_manager)
    {
        if (!is_struct(settings_save[$ _section]))
            return _default
        
        return settings_save[$ _section][$ _key] ?? _default
    }
}

///@desc Read a value from the player's current save file. Functions similarly to `ini_read_real` and `ini_read_string`, but with no limitation on the variable type.
///@arg {string} section The section of the save to read from.
///@arg {string} key The key within the relevant section of the save to read from.
///@arg {any} default The value to return if a value is not found in the defined place.
///@return {any} The value read from the file, or `default` if none is found.
function player_save_read(_section, _key, _default)
{
    with (obj_savefile_manager)
    {
        if (!is_struct(player_save[$ _section]))
            return _default
        
        return player_save[$ _section][$ _key] ?? _default
    }
}

///@desc Write the settings and player save files to disk.
///@arg {bool} [silent] Set to true to disable the save icon (or false to enable it). The default can be configured in `scr_west_settings`.
function savefile_do_save(_silent = !SHOW_SAVING_ICON)
{
    with (obj_savefile_manager)
    {
        do_save = true
        if (!_silent)
            image_alpha = 3
    }
}

///@desc Load the settings file from disk. You probably only want to call this once, at the start of the game.
function savefile_load_settings()
{
    with (obj_savefile_manager)
    {
        if file_exists("settings.json")
        {
            var _buffer = undefined
            try
            { 
                _buffer = buffer_load("settings.json")
                settings_save = json_parse(buffer_read(_buffer, buffer_text))
                buffer_delete(_buffer)
            }
            catch (_error)
            {
                show_message($"Settings load failed. {_error.message}")
                settings_save = {}
            }
            finally
            {
               if (!is_undefined(_buffer))
                   buffer_delete(_buffer)
            }
        }
        else
            settings_save = {}
    }
}

///@desc Load the player's save file from disk.
///@arg {int} file_number The slot of the save file to read from. Will also be the slot written to by `savefile_do_save` until this function is called again.
function savefile_load_player(_file_number)
{
    with (obj_savefile_manager)
    {
        selected_file = _file_number
        var _save_name = string_concat("savefile", _file_number, ".sav")
        if file_exists(_save_name)
        {
            var _buffer = undefined
            var _buffer_decompressed = undefined
            try
            {
                _buffer = buffer_load(_save_name)
                _buffer_decompressed = buffer_decompress(_buffer)
                player_save = json_parse(buffer_read(_buffer_decompressed, buffer_text))
                buffer_delete(_buffer_decompressed)
                buffer_delete(_buffer)
            }
            catch (_error)
            {
                show_message($"Savefile load failed. {_error.message}")
                player_save = {}
            }
            finally
            {
               if (!is_undefined(_buffer))
                   buffer_delete(_buffer)
               if (!is_undefined(_buffer_decompressed))
                   buffer_delete(_buffer_decompressed)
            }
        }
        else
            player_save = {}
    }
}
