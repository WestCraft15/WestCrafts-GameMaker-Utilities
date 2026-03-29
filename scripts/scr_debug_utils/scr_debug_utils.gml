// Used to denote the severity of messages in the below functions.
enum SEVERITY
{
    DEBUG,
    INFO,
    WARNING,
    ERROR,
    FATAL,
}

/// @desc A basic assertion. Outputs a message to the log depending on the severity, and throws an exception if severity is set to SEVERITY.FATAL.
/// @arg {bool} condition The condition to check. If the result is falsy, outputs the message and possibly throws an error.
/// @arg {string} message The message to print to the log. Also the message used when throwing an error.
/// @arg {real} severity The severity of the error. Defaults to SEVERITY.FATAL.
/// @return {bool} Returns true if the condition is true, false otherwise.
function assert(_condition, _message, _severity = SEVERITY.FATAL)
{
    if (_condition)
    {
        print(_message, _severity)
        
        if (_severity >= SEVERITY.FATAL)
            throw _message
        
        return true
    }
    
    return false
}

/// @desc A general purpose print function for logging and debugging. Also used for outputting warnings and errors.
/// @arg {string} message The message to print. Will be prepended with the severity if it is higher than SEVERITY.DEBUG.
/// @arg {real} severity The severity of the error. Defaults to SEVERITY.DEBUG. Will not print the message if this is lower than MINIMUM_SEVERITY.
function print(_message, _severity = SEVERITY.DEBUG)
{
    if (_severity < MINIMUM_SEVERITY)
        exit

    switch (_severity)
    {
        case SEVERITY.DEBUG:
            print(_message)
            break
        case SEVERITY.INFO:
            print("(INFO) " + _message)
            break
        case SEVERITY.WARNING:
            print("(WARN) " + _message)
            break
        case SEVERITY.ERROR:
            print("(ERROR) " + _message)
            break
        case SEVERITY.FATAL:
            print("(FATAL) " + _message)
            break
    }
}