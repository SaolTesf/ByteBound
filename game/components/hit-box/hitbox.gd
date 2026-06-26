class_name Hitbox extends Area2D
## A reusable detection area.
##
## Reports bodies entering/leaving via the local [signal entered] / [signal exited]
## signals; the owner connects and decides what to do. Holds no reference to its
## owner. Configure the shape/size in the inspector, then call [method init] from
## the owner's [method Node._ready].

## Emitted when a body enters the hitbox.
signal entered(body: Node2D)
## Emitted when a body leaves the hitbox.
signal exited(body: Node2D)

@export_category("CollisionShape")
@export var collision_shape: CollisionShape2D
@export_subgroup("shape")
@export_enum("Circle", "Rectangle", "Capsule") var shape_type: int = 1
@export var x: float = 10
@export var y: float = 10

## Builds the collision shape and starts reporting body enter/exit.
func init() -> void:
	if not collision_shape:
		collision_shape = find_child("CollisionShape2D")
	assert(collision_shape, "Hitbox: CollisionShape2D not set")
	collision_shape.shape = _create_shape()
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _create_shape() -> Shape2D:
	match shape_type:
		0:
			var circle := CircleShape2D.new()
			circle.radius = x
			return circle
		2:
			var capsule := CapsuleShape2D.new()
			capsule.radius = x
			capsule.height = y
			return capsule
		_:
			var rect := RectangleShape2D.new()
			rect.size = Vector2(x, y)
			return rect

func _on_body_entered(body: Node2D) -> void:
	entered.emit(body)

func _on_body_exited(body: Node2D) -> void:
	exited.emit(body)
