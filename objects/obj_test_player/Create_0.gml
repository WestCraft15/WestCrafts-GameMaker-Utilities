init_collision()

sm_init()
sm_add_state("normal", function()
{
    if global.input.right
    	x_speed = 2
    else if global.input.left
    	x_speed = -2
    else
        x_speed = 0
    
    if grounded && global.input.jump_pressed
    	sm_change_state("jump", {strength: 5})
})
sm_add_state("jump", function()
{
    if global.input.right
    	x_speed = 2
    else if global.input.left
    	x_speed = -2
    else
        x_speed = 0
    
    if grounded
        sm_change_state("normal")
}, function(_old_state, _parameters)
{
    _parameters.strength ??= 4
    y_speed = -_parameters.strength
})
