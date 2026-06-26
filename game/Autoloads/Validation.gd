extends Node
## Used to validate refs and vars
##
## Each check function has debugging built in.
## Each function should check if the value exists, 
## Attempt to set it if it is a node from the child list
## Throw an error if it could not be set.
## Return true or false depending if the var was set.


## This funciton is used to set up reference to a Node.
## Checks if the node exist
## if not attempt to fetch as a child of the calling node
func check_reference(caller : Node, var_name : String, child : String ) -> bool:
	# Check if the var was already set, if so return
	var current_value = caller.get(var_name)
	if current_value:
		return true # var was set return true
		
	# Current Value was not set in the editor log info to console
	var params : Array = [var_name, child, caller.name]
	var message : String = "%s was not currently set!\nAttempting to find %s as a child of %s" % params
	Debug.debug(self, message, false, 2)
	
	# attempt to fetch the the node from the owners children
	var node = caller.find_child(child, true, false)
	# if the node found is the has the same name as child, Set the value
	if node.name == child:
		print("%s was found in %s setting reference" % [child, caller.name])
		caller.set(var_name, node)
		return true
	# Return false if no refrence could be set.
	return false


func check_if_null(caller : Node, var_name : String) -> bool:
	var current_value = caller.get(var_name)
	var message : String
	if current_value: 
		message = "%s-%s has a value of %s" % [caller.name, var_name, current_value]
		Debug.debug(self, message, false)
		return true
	
	message = "%s was not set for %s, its value is %s" % [var_name, caller.name, current_value] 
	Debug.debug(self, message, false, 2)
	return false


## Checks if the caller is a CharacterBody2D or a RidgedBody2D
func check_velocity(caller : Node2D) -> Vector2:
	if caller is CharacterBody2D:
		return caller.velocity
	if caller is RigidBody2D:
		return caller.linear_velocity
	return Vector2.ZERO
	
