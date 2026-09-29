// Used to denote the severity of messages in the below functions.
enum SEVERITY
{
    DEBUG,
    INFO,
    WARNING,
    ERROR,
    FATAL,
}

/// @desc A basic assertion. Fails if the `condition` is false, which prints a message and throws an exception if `severity` is set to SEVERITY.FATAL.
/// @arg {bool} condition The condition to check. If this is false, prints `message` and possibly throws an error.
/// @arg {string} message The message to print to the log. Also used when throwing an error.
/// @arg {real} severity The severity of the assertion. Defaults to `SEVERITY.FATAL`.
/// @return {bool} Returns `condition`.
function assert(_condition, _message, _severity = SEVERITY.FATAL)
{
    if (!_condition)
    {
        print(_message, _severity)
        
        if (_severity >= SEVERITY.FATAL)
            throw _message
        
        return false
    }
    
    return true
}

/// @desc A general purpose print function for logging and debugging. Also used for outputting warnings and errors.
/// @arg {string} message The message to print. Will be prepended with `severity` if it is higher than `SEVERITY.DEBUG`.
/// @arg {real} severity The severity of the message. Defaults to `SEVERITY.DEBUG`. The message will not be printed if this is lower than `MINIMUM_SEVERITY`.
function print(_message, _severity = SEVERITY.DEBUG)
{
    if (_severity < MINIMUM_SEVERITY)
        exit

    switch (_severity)
    {
        case SEVERITY.DEBUG:
            show_debug_message(_message)
            break
        case SEVERITY.INFO:
            show_debug_message("(INFO) " + _message)
            break
        case SEVERITY.WARNING:
            show_debug_message("(WARN) " + _message)
            break
        case SEVERITY.ERROR:
            show_debug_message("(ERROR) " + _message)
            break
        case SEVERITY.FATAL:
            show_debug_message("(FATAL) " + _message)
            break
    }
}
