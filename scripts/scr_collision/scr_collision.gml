/// @desc A more robust move_and_collide() supporting platforms and slopes.
function do_collision()
{
	// Handle X subpixels
	var _x_add = 0
	x_carry += frac(x_speed)
	if (x_carry >= 1)
	{
		_x_add = 1
		x_carry--
	}
	else if (x_carry <= -1)
	{
		_x_add = -1
		x_carry++
	}
	
	var _dir = sign(x_speed + _x_add)
	
	// Move along the X axis
	repeat (abs(x_speed + _x_add))
	{
		// Solid check
		if (!check_solid(x + _dir, y))
		{
			x += _dir
			// Downward slope check
			if (grounded && !check_solid(x, y + 1))
			{
				for (var i = 1; i < 4; i++)
				{
					if (check_solid(x, y + 1 + i))
					{
						y += i
						break
					}
				}
			}
		}
		else
		{
			// Upward slope check
			if (grounded)
			{
				var _found = false
				for (var i = 1; i < 4; i++)
				{
					if (!check_solid(x + _dir, y - i))
					{
						x += _dir
						y -= i
						_found = true
						break
					}
				}
				if (_found) continue
			}
			x_speed = 0
			x_carry = 0
			break
		}
	}

	// First grounded check
	if (y_speed >= 0 && check_solid(x, y + 1))
	{
		y_speed = 0
		y_carry = 0
		grounded = true
		stay_on_moving_platform()
		exit
	}
	
	// Apply gravity
	y_speed = approach(y_speed, terminal_velocity, grav)
	
	// Handle Y subpixels
	var _y_add = 0
	y_carry += frac(y_speed)
	if (y_carry >= 1)
	{
		_y_add = 1
		y_carry--
	}
	else if (y_carry <= -1)
	{
		_y_add = -1
		y_carry++
	}
	
	_dir = sign(y_speed + _y_add)
	
	// Move along the Y axis
	repeat (abs(y_speed + _y_add))
	{
		if (!check_solid(x, y + _dir))
		{
			y += _dir
		}
		else
		{
			y_speed = 0
			y_carry = 0
			break
		}
	}
	
	// Grounded check
	if (y_speed >= 0 && check_solid(x, y + 1))
	{
		y_speed = 0
		y_carry = 0
		grounded = true
		stay_on_moving_platform()
	}
	else
		grounded = false
}

/// @desc A do_collision() equivalent specifically for moving platforms. You probably don't need to call this yourself.
/// @ignore
function do_collision_moving_platform()
{
    // TODO: Currently, moving platforms can sometimes miss falling objects if its moving upwards at more than 1 pixel per frame. I'll have to rewrite how I handle them at some point, but it works fine enough for now.
    
    x += next_move_x
    next_move_x = 0
    
	// Handle X subpixels
	var _x_add = 0
	x_carry += frac(x_speed)
	if (x_carry >= 1)
	{
		_x_add = 1
		x_carry--
	}
	else if (x_carry <= -1)
	{
		_x_add = -1
		x_carry++
	}
	
	var _dir = sign(x_speed + _x_add)
	
	// Move along the X axis
	repeat (abs(x_speed + _x_add))
	{
		// Solid check
		if (!instance_place(x + _dir, y, obj_moving_platform_boundary))
		{
            next_move_x += _dir
		}
		else
		{
			x_speed *= -1
			break
		}
	}
    
    y += next_move_y
    next_move_y = 0
	
	// Handle Y subpixels
	var _y_add = 0
	y_carry += frac(y_speed)
	if (y_carry >= 1)
	{
		_y_add = 1
		y_carry--
	}
	else if (y_carry <= -1)
	{
		_y_add = -1
		y_carry++
	}
	
	_dir = sign(y_speed + _y_add)
	
	// Move along the Y axis
	repeat (abs(y_speed + _y_add))
	{
		if (!instance_place(x, y + _dir, obj_moving_platform_boundary))
		{
            next_move_y += _dir
		}
		else
		{
			y_speed *= -1
			break
		}
	}
}

// Used to exclude certain types of solids from the check_solid() function.
enum COLLISION_EXCLUDE
{
	NONE = 0,
	SOLIDS = 1,
	PLATFORMS = 2,
	SLOPES = 4,
	MOVING_PLATFORMS = 8,
}

/// @desc Check for solid objects at the specified position. Optional arguments allow for excluding certain types of solids.
/// @arg {real} x The X position to check.
/// @arg {real} y The Y position to check.
/// @arg {real} [exclude] The collision types to exclude from the check. Defaults to COLLISION_EXCLUDE.NONE.
/// @return {bool} Whether a valid solid was found.
function check_solid(_x, _y, _exclude = COLLISION_EXCLUDE.NONE)
{
    // Get the list of solids at the specified position.
	var _solids = ds_list_create()
	instance_place_list(_x, _y, obj_solid, _solids, false)
	
    // Precompute the excludes.
    // TODO: Probably actually worse for optimization, now that I think about it. Maybe make the exclusion check a different function entirely?
	var _exclude_solids = (_exclude & COLLISION_EXCLUDE.SOLIDS) != 0
	var _exclude_platforms = (_exclude & COLLISION_EXCLUDE.PLATFORMS) != 0
	var _exclude_slopes = (_exclude & COLLISION_EXCLUDE.SLOPES) != 0
	var _exclude_moving_platforms = (_exclude & COLLISION_EXCLUDE.MOVING_PLATFORMS) != 0
	
    // Loop through the list of solids and check if they are able to collide with the object.
	var _found_solid = false
	for (var i = 0; i < ds_list_size(_solids); i++)
	{
		if (_exclude_solids && _solids[| i].object_index == obj_solid) continue
		if (_exclude_platforms && _solids[| i].object_index == obj_platform) continue
		if (_exclude_slopes && _solids[| i].object_index == obj_slope) continue
		if (_exclude_moving_platforms && _solids[| i].object_index == obj_moving_platform) continue
		
		if (_solids[| i].can_collide(id, _x, _y))
		{
			_found_solid = true
			break
		}
	}
    
	ds_list_destroy(_solids)
	return _found_solid
}

/// @desc Moves an object with the moving platform it's standing on. Used in do_collision(), so you likely don't need to call this yourself.
/// @ignore
function stay_on_moving_platform()
{
    // Exit if the object isn't on a moving platform.
	var _platform = instance_place(x, y + 1, obj_moving_platform)
	if (!_platform || !_platform.can_collide(id, x, y))
		exit

	var _dir = sign(_platform.next_move_x)
	
	// Move along the X axis
	repeat (abs(_platform.next_move_x))
	{
		// Solid check
		if (check_solid(x + _dir, y, COLLISION_EXCLUDE.MOVING_PLATFORMS))
			break
		x += _dir
	}
	
	_dir = sign(_platform.next_move_y)
	
	// Move along the Y axis
	repeat (abs(_platform.next_move_y))
	{
		if (check_solid(x, y + _dir, COLLISION_EXCLUDE.MOVING_PLATFORMS))
			break
		y += _dir
	}
}

/// @desc A helper function to initialize collision variables. Intended to be called in the Create event of any object that uses do_collision().
function init_collision()
{
	x_speed = 0
	y_speed = 0
	x_carry = 0
	y_carry = 0
	grav = DEFAULT_GRAVITY
	terminal_velocity = DEFAULT_TERMINAL_VELOCITY
	grounded = instance_place(x, y + 1, obj_solid)
}
