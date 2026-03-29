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
