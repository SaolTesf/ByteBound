extends Node

# add this to the gitignore
var _log_file_path : String = "user://Logs/"

## Prints a message to a log file,
## By default the stack trace is false,
## By default the stack info displayed comes from stack[1]
func log(caller: Object, message: String, 
		show_stack : bool = false, starting_stack : int = 1) -> void:
	# Log the time the message was written
	var date = Time.get_date_string_from_system()
	var time = Time.get_time_string_from_system()
	var date_time = "Time: %s-%s" % [date, time]

	# Pull Info to display use 2 to not get the Debug auto load
	var function = _get_function_data(starting_stack)
	var c_name = _get_class_data(caller)
	var source = _get_source_data(starting_stack)
	var line = _get_line_data(starting_stack)

	var file_path = _get_log_file_path(source, c_name)
	
	# Print message to the console telling the programmer that data has been logged and where
	var params : Array = [c_name, source, function, file_path]
	print("LOG: class: %s  source: %s function: %s()\nInfo has been logged to: %s" % params)

	# Write the logs to file
	var content : String = _write_log_message(source, c_name, function, line, date_time, message)
	_write_to_file(file_path, content)
	if show_stack:
		_write_to_file(file_path, stack_to_string())

## Used to log a debug message to the console
## Contains some infromation about the function debug was called from
## Info includes the script name, and function name.
func debug(caller : Object, message : String, 
			show_stack: bool = false, starting_stack : int = 1) -> void:
	var source = _get_source_data(starting_stack)
	var function = _get_function_data(starting_stack)
	var c_name = _get_class_data(caller)
	var line = _get_line_data(starting_stack)

	print("-".repeat(70))
	print("DEBUG: class: %s  source: %s  function: %s()/l:%d\n%s" % [c_name, source, function, line, message])
	if show_stack:
		print(stack_to_string())


## Returns the stack as a string
func stack_to_string() -> String:
	var stack: Array = get_stack()
	var source : String
	var function : String
	var line : int
	var result : String = ""
	
	for i in range(stack.size()):
		line = stack[i].get("line")
		source = stack[i].get("source")
		function = stack[i].get("function")
		result = result + "%s: source: %s , function: %s, line: %d\n" % [i, source, function, line]

	return result


## Returns a single element of the stack Dictionary 
func _get_stack_data(i : int) -> Dictionary:
	var stack : Array = get_stack()
	if i < 0 or i > stack.size():
		return {"source": "NA", "function" : "NA", "line" : "NA"}
	var data : Dictionary = stack[i + 2]
	return data


## Returns the name of the calling function
func _get_function_data(stack_level) -> String:
	return _get_stack_data(stack_level).get("function")


## Returns the location of the calling function just the file name not the full path
# TODO: Decide if the whole path should be printed
func _get_source_data(stack_level) -> String:
	return _get_stack_data(stack_level).get("source").get_file()


## Returns the line number of the Debug call
## this can come in handy for jumping near the line in question or for finding and turning off print statements
func _get_line_data(stack_level) -> int:
	return _get_stack_data(stack_level).get("line")


## If the calling script has a class_name declared return that if not returns the root class usually node
func _get_class_data(object : Object) -> String:
	var script = object.get_script()
	if script:
		var c_name = script.get_global_name()
		if c_name != "":
			return c_name
		
	return object.get_class()


## Takes in the source and Class and creates a file path.
## Creates a folder for each class and then a file for each source
## user://Logs/Class/source.log
func _get_log_file_path(source: String, cclass : String) -> String:
	# _log_file_path has an ending /
	return _log_file_path + cclass.capitalize() + "/" + source.get_slice(".", 0) + ".log"


func _write_log_message(source, c_name, function, line, date_time, message) -> String:
	var c : String = "class: %s" % c_name
	var f : String = "function %s" % function
	var l : String = "line: %s" % line
	var s : String = "source: %s" % source
	return "-".repeat(80) + "LOG: %s: %s \n%s \n%s \n%s \n%s\n" % [date_time, message, s, c, f, l]




func _write_to_file(file_path: String, content: String) -> void:
	# Ensure the directory exists
	var dir = file_path.get_base_dir()
	if not DirAccess.dir_exists_absolute(dir):
		DirAccess.make_dir_recursive_absolute(dir)
	
	# Try to open the file
	var file = FileAccess.open(file_path, FileAccess.READ_WRITE)
	if file:
		file.seek_end()
		file.store_string(content)
		file.close()
		print("Successfully wrote to file: %s" % file_path)
	else:
		print("Failed to open file: %s" % file_path)
		print("Error: %s" % FileAccess.get_open_error())
