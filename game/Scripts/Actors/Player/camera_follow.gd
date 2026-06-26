class_name CameraFollow extends Camera2D

var camera_flip_speed : float = 0.5
var target : CharacterBody2D
var camera_position: Vector2

func _ready() -> void:
	target = get_parent()
	camera_position = position

func _physics_process(delta: float) -> void:
	var direction = 1 if target.velocity.x > 0 else -1
	var new_offset : Vector2 = Vector2(abs(offset.x) * direction, offset.y)
	offset = offset.lerp(new_offset, camera_flip_speed * delta)
	print(camera_position)
