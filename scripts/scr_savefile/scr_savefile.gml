// TODO: Write JSDoc comments.

function settings_save_write(_section, _key, _value)
{
    with (obj_savefile_manager)
    {
        settings_save_dirty = true
        settings_save[$ _section] ??= {}
        settings_save[$ _section][$ _key] = _value
    }
}

function player_save_write(_section, _key, _value)
{
    with (obj_savefile_manager)
    {
        player_save_dirty = true
        player_save[$ _section] ??= {}
        player_save[$ _section][$ _key] = _value
    }
}

function settings_save_read(_section, _key, _default)
{
    with (obj_savefile_manager)
    {
        if (!is_struct(settings_save[$ _section]))
            return _default
        
        return settings_save[$ _section][$ _key] ?? _default
    }
}

function player_save_read(_section, _key, _default)
{
    with (obj_savefile_manager)
    {
        if (!is_struct(player_save[$ _section]))
            return _default
        
        return player_save[$ _section][$ _key] ?? _default
    }
}

function savefile_do_save(_silent = false)
{
    with (obj_savefile_manager)
    {
        do_save = true
        if (!_silent)
            image_alpha = 3
    }
}

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
                show_message($"Player load failed. {_error.message}")
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
