class_name InputComponent extends Node
## Handles Player Input 
##
## This componet should only be added to game objects te player wants to control
## Constanly pools for left and right input every frame and assigns it to [member InputComponent.input_horizontal]

## either -1.0, 0.0, 1.0
var input_horizontal: float = 0.0

# checks every frame if input was given
func _process(_delta: float) -> void:
	input_horizontal = Input.get_axis("ui_left", "ui_right")

func get_jump() -> bool:
	return Input.is_action_just_pressed("ui_accept")

func get_move() -> bool:
	return get_left() or get_right()

func get_left() -> bool:
	return Input.is_action_pressed("ui_left")

func get_right() -> bool:
	return Input.is_action_pressed("ui_right")

func get_fast_fall() -> bool:
	return Input.is_action_pressed("ui_down")

func get_dash() -> bool:
	return Input.is_action_pressed("dash")

func get_crouch() -> bool:
	return Input.is_action_pressed("crouch")

func get_paused() -> bool:
	return Input.is_action_just_pressed("ui_cancel")

func get_interact() -> bool:
	var rv = Input.is_action_pressed("interact")
	if rv:
		print("Interact was pressed something should happen")
	return rv

func get_throw() -> bool:
	var rv = Input.is_action_just_pressed("throw")
	if rv:
		print("trow was press if object held it should be thrown")
	return rv
