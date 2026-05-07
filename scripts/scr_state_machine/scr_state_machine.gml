/// @desc Initializes the state machine system for this instance.
/// @arg {string} state_function_prefix The prefix for all functions that this state machine will use. For example, if your states are called state_player_idle, state_player_jump, etc. you would pass "state_player_".
/// @arg {string} default_state_id The default state ID for this instance.
function sm_init(_state_function_prefix, _default_state_id)
{
    static _state_machines = {}
    
    if !struct_exists(_state_machines, _state_function_prefix)
    {
        var _new_state_machine = {}
        
        var _global_vars = variable_instance_get_names(global)
        var _global_vars_len = array_length(_global_vars)
        
        var _state_names = []
        
        for (var i = 0; i < _global_vars_len; i++)
        {
            var _global_var = _global_vars[i]
            if (string_starts_with(_global_var, _state_function_prefix) && !string_ends_with(_global_var, TRANSITION_IN_SUFFIX) && !string_ends_with(_global_var, TRANSITION_OUT_SUFFIX) && is_method(variable_global_get(_global_var)))
                array_push(_state_names, _global_var)
        }
        
        var _state_names_length = array_length(_state_names)
        
        for (var i = 0; i < _state_names_length; i++)
        {
            var _state_name = _state_names[i]
            
            var _transition_in_function = variable_global_get(_state_names[i] + TRANSITION_IN_SUFFIX)
            if (!is_method(_transition_in_function))
                _transition_in_function = undefined
            
            var _transition_out_function = variable_global_get(_state_names[i] + TRANSITION_OUT_SUFFIX)
            if (!is_method(_transition_out_function))
                _transition_out_function = undefined
            
            _new_state_machine[$ string_delete(_state_name, 1, string_length(_state_function_prefix))] = new State(variable_global_get(_state_names[i]), _transition_in_function, _transition_out_function)
        }
        
        _state_machines[$ _state_function_prefix] = _new_state_machine
    }
    
    state_machine = _state_machines[$ _state_function_prefix]
    current_state = _default_state_id
}

/// @desc Initializes an empty state machine for this instance. Use sm_add_state() to manually add states.
function sm_init_ext()
{
    state_machine = {}
    current_state = undefined
}

/// @desc Adds a state to this instance's state machine.
/// @arg {real, string} id The ID of the new state.
/// @arg {function} step The function to run on every frame while this state is active.
/// @arg {function} transition_in The function to run when this state is changed to. See sm_example_transition_in() for documentation.
/// @arg {function} transition_out The function to run when this state is changed from. See sm_example_transition_out() for documentation.
function sm_add_state(_id, _step, _transition_in = undefined, _transition_out = undefined)
{
    state_machine[$ _id] = new State(_step, _transition_in, _transition_out)
    if (current_state == undefined) current_state = _id
}

/// @desc The state constructor function. You probably want to use sm_add_state() instead.
/// @arg {function} step The function to run on every frame while this state is active.
/// @arg {function} transition_in The function to run when this state is changed to.
/// @arg {function} transition_out The function to run when this state is changed from.
/// @return {struct} A struct representing a state.
/// @pure
/// @ignore
function State(_step, _transition_in = undefined, _transition_out = undefined) constructor
{
    step = _step
    transition_in = _transition_in
    transition_out = _transition_out
}

/// @desc Should be called in the step event of any instance that uses the state machine.
function sm_process()
{
    method(self, state_machine[$ current_state].step)()
}

/// @desc Call this function to transition to a new state.
/// @arg {real, string} new_state The ID of the state to transition to.
/// @arg {struct} [parameters] An optional struct containing any parameters you wish to pass to the transition functions for the old and new states.
function sm_change_state(_new_state, _parameters = {})
{
    if (state_machine[$ current_state].transition_out != undefined)
        method(self, state_machine[$ current_state].transition_out)(_new_state, _parameters)
    if (state_machine[$ _new_state].transition_in != undefined)
        method(self, state_machine[$ _new_state].transition_in)(current_state, _parameters)
    current_state = _new_state
}

#region Example State Functions
    
    /// @desc An example function for a state. Use this as a reference for creating your own.
    /// @ignore
    function sm_example_state()
    {
        some_variable += 1
    }
    
    /// @desc An example __out function for a state. Use this as a reference for creating your own.
    /// @arg {real, string} new_state The ID of the state that will be transitioned to.
    /// @arg {struct} parameters A struct containing any parameters from the call to sm_change_state(). Can be modified to pass additional/different parameters to the __in function of the new state.
    /// @ignore
    function sm_example_state__out(_new_state, _parameters)
    {
        some_variable = 0
        if (_new_state == "jump")
            y_speed = -5
        if (_parameters[$ "some_value"] == 3)
            _parameters[$ "some_other_value"] = 4
    }
    
    /// @desc An example __in function for a state. Use this as a reference for creating your own.
    /// @arg {real, string} old_state The ID of the state that was transitioned from.
    /// @arg {struct} parameters A struct containing any parameters from the call to sm_change_state(). May have been modified by the preceding __out function.
    /// @ignore
    function sm_example_state__in(_old_state, _parameters)
    {
        some_other_variable = 20
        if (_old_state == "walk")
            x_speed = 0
        if (_parameters[$ "some_other_value"] != undefined)
            a_third_variable = _parameters[$ "some_other_value"]
    }
    
#endregion Example State Functions
