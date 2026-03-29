if keyboard_check(vk_right)
	x_speed = 2
else if keyboard_check(vk_left)
	x_speed = -2
else
    x_speed = 0

if grounded && keyboard_check_pressed(vk_space)
	y_speed = -5

do_collision()
