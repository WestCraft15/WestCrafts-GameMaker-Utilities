/// @desc Change a value towards a target by a fixed amount without going past the target. Essentially a linear version of lerp().
/// @arg {real} value The current value.
/// @arg {real} target The target value to approach.
/// @arg {real} amount The amount to approach by.
/// @return {real} The value plus or minus the specified amount.
/// @pure
function approach(_value, _target, _amount)
{
	if (_value > _target)
	{
		_value -= _amount
        
		if (_value < _target)
			return _target
	}
    
	if (_value < _target)
	{
		_value += _amount
        
		if (_value > _target)
			return _target
	}
    
	return _value
}

/// @desc Wrap a value between a minimum and maximum. When working with integers, this may not behave as expeceted. If so, use wrap_int() instead.
/// @arg {real} value The value to wrap.
/// @arg {real} minimum The lower bound. Inclusive.
/// @arg {real} maximum The upper bound. Exclusive.
/// @return {real} The wrapped value.
/// @pure
function wrap(_value, _minimum, _maximum)
{
	assert(_minimum <= _maximum, "wrap(): maximum cannot be less than minimum.")
	
    if (assert(_minimum != _maximum, "wrap(): maximum and minimum are equal. This may not be intended.", SEVERITY.WARNING))
		return _maximum
	
	var _difference = _maximum - _minimum
	
	while (_value >= _maximum)
		_value -= _difference
		
	while (_value < _minimum)
		_value += _difference
	
	return _value
}

/// @desc Wrap an integer value between a minimum and maximum. When working with decimals, this will not behave as expeceted. Use wrap() instead.
/// @arg {real} value The value to wrap.
/// @arg {real} minimum The lower bound. Inclusive.
/// @arg {real} maximum The upper bound. Inclusive.
/// @return {real} The wrapped value.
/// @pure
function wrap_int(_value, _minimum, _maximum)
{
	assert(_minimum <= _maximum, "wrap_int(): maximum cannot be less than minimum.")
	
    if (assert(_minimum != _maximum, "wrap_int(): maximum and minimum are equal. This may not be intended.", SEVERITY.WARNING))
		return _maximum
    
	var _difference = _maximum - _minimum + 1
	
	while (_value > _maximum)
		_value -= _difference
		
	while (_value < _minimum)
		_value += _difference
	
	return _value
}
