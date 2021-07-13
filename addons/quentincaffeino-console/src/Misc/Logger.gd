
extends RefCounted


class  TYPE :
	const DEBUG=0
	const INFO=1
	const WARNING=2
	const ERROR=3
	const NONE=4



# @var  int
var logLevel = TYPE.WARNING

var _console


func _init(console):
	_console = console

# @deprecated
# @param    int  in_log_level
# @returns  Log
func setLogLevel(in_log_level):
	self._console.Log.warn("DEPRECATED: We're moving our api from camelCase to snake_case, please update this method to `set_log_level`. Please refer to documentation for more info.")
	return self.set_log_level(in_log_level)


# @param    int  in_log_level
# @returns  Log
func set_log_level(in_log_level):
	logLevel = in_log_level
	return self

# Example usage:
# ```gdscript
# Console.Log.log("Hello world!", Console.Log.TYPE.INFO)
# ```
#
# @param    String  message
# @param    int     type
# @returns  Log
func log(message, type = TYPE.INFO):
	match type:
		TYPE.DEBUG:   debug(message)
		TYPE.INFO:    info(message)
		TYPE.WARNING: warn(message)
		TYPE.ERROR:   error(message)
	return self


# @param    String  message
# @returns  Log
func debug(message):
	if logLevel <= TYPE.DEBUG:
		self._console.write_line('[color=green][DEBUG][/color] ' + str(message))
	return self


# @param    String  message
# @returns  Log
func info(message):
	if logLevel <= TYPE.INFO:
		self._console.write_line('[color=blue][INFO][/color] ' + str(message))
	return self


# @param    String  message
# @returns  Log
func warn(message):
	if logLevel <= TYPE.WARNING:
		self._console.write_line('[color=yellow][WARNING][/color] ' + str(message))
	return self


# @param    String  message
# @returns  Log
func error(message):
	if logLevel <= TYPE.ERROR:
		self._console.write_line('[color=red][ERROR][/color] ' + str(message))
	return self
