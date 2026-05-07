function state_player_jump()
{
    if INPUT.right
    	x_speed = 2
    else if INPUT.left
    	x_speed = -2
    else
        x_speed = 0
    
    if grounded
        sm_change_state("normal")
}

function state_player_jump_in(_old_state, _parameters)
{
    _parameters[$ "strength"] ??= 1
    y_speed = -_parameters.strength
}
