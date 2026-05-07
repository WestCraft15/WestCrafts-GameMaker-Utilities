function state_player_normal()
{
    if INPUT.right
    	x_speed = 2
    else if INPUT.left
    	x_speed = -2
    else
        x_speed = 0
    
    if grounded && INPUT.jump_pressed
    	sm_change_state("jump", {strength: 5})
}
