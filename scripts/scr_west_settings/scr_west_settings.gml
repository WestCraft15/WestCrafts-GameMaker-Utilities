/*
 * This file contains various macros that act as settings for WestCraft's GameMaker Utilities.
 * Each one is explained in the comment(s) above the macro.
 * They have been separated into regions for convenience.
 * 
 * When updating, make a backup of this file and manually copy the old values.
 * Don't just directly replace the file, as there may be new settings.
 */

#region Debug Utils
    
    // Causes functions like assert() and print() to not print a message if the severity argument is below this value.
    #macro MINIMUM_SEVERITY SEVERITY.DEBUG
    
#endregion Debug Utils

#region Collision
    
    // The default value of grav assigned in the collision_init() function.
    #macro DEFAULT_GRAVITY 0.25
    
    // The default value of terminal_velocity assigned in the collision_init() function.
    #macro DEFAULT_TERMINAL_VELOCITY 4
    
#endregion Collision

#region Input
    
    // The default value of global.controller_deadzone.
    #macro DEFAULT_CONTROLLER_DEADZONE 0.8
    
    /// @desc This function sets up the input system. Use add_input("id", [new Bind(BIND_TYPE, vk_key/gp_button)]) to create new inputs.
    /// @ignore
    function init_input()
    {
        add_input("left",  [new Bind(BIND_TYPE.KEYBOARD, vk_left),  new Bind(BIND_TYPE.GAMEPAD_AXIS_NEGATIVE, gp_axislh)])
        add_input("right", [new Bind(BIND_TYPE.KEYBOARD, vk_right), new Bind(BIND_TYPE.GAMEPAD_AXIS_POSITIVE, gp_axislh)])
        add_input("jump",  [new Bind(BIND_TYPE.KEYBOARD, vk_space), new Bind(BIND_TYPE.GAMEPAD_BUTTON, gp_face1)])
    }
    
#endregion Input

#region State Machines

    // The suffix for all transition in functions.
    #macro TRANSITION_IN_SUFFIX "__in"

    // The suffix for all transition out functions.
    #macro TRANSITION_OUT_SUFFIX "__out"

#endregion State Machines

#region Savefile
    
    // Whether to create an uncompressed duplicate of each save. This is only for debugging, as the game will not read from these files. Also pretty prints the json for readability.
    #macro SAVE_UNCOMPRESSED false

    // The name of the player's save file. Will be appended with the corresponding save number and the ".sav" file extension.
    #macro SAVE_NAME "savefile"
    
    // Whether to show the saving icon by default when savefile_do_save is called.
    #macro SHOW_SAVING_ICON true
    
#endregion Savefile
