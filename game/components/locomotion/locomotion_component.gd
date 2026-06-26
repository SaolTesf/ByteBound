class_name LocomotionComponent extends Node
## Owns a body's motion loop.
##
## Runs each child [MovementComponent] in tree order every physics frame, then
## calls move_and_slide exactly once. This is the [b]sole[/b] caller of
## move_and_slide for its body — controllers (FSM states, AI) set movement intent
## on the child components and never slide themselves.

## The body to move. Defaults to the parent if left unset.
@export var body: CharacterBody2D

var _movers: Array[MovementComponent] = []

func _ready() -> void:
	if not body:
		body = get_parent() as CharacterBody2D
	assert(body, "LocomotionComponent: body (CharacterBody2D) not set")
	for child in get_children():
		if child is MovementComponent:
			_movers.append(child)
	# Run after controllers (FSM/AI) have set this frame's movement intent.
	process_physics_priority = 100

func _physics_process(delta: float) -> void:
	for mover in _movers:
		mover.apply(body, delta)
	body.move_and_slide()
