class_name Hitbox extends Area2D
## A class that adds an area 2D for checks to its parent
##
## This Script will set up the shape of the colliion shape
## Connect Signals for on bodyentered and on bodyexited

@export_category("CollisionShape")
@export var collision_shape : CollisionShape2D
var parent : Node2D
@export_subgroup("shape")
@export_enum("Circle", "Rectangle", "Capsule") var shape_type : int = 1
@export var x : float = 10
@export var y : float  = 10


func init(body : Node2D) -> void:
	self.parent = body
	setUpCollisionShape()
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _createShape():
	match(shape_type):
		0:
			return CircleShape2D.new()
		1:
			return RectangleShape2D.new()
		2:
			return CapsuleShape2D.new()
		_:
			Debug.debug(self, "No Shape was defined using the default RectangleShape2D", false)
			Debug.log(self, "No Shape was defined using the default RectangleShape2D", true)
			return RectangleShape2D.new()


## Used to initalif fov:ize the collision shape and set the shape, size and color
func setUpCollisionShape() -> void:
	if not collision_shape:
		collision_shape = find_child("CollisionShape2D")
	assert(collision_shape != null, "Collision Shape not set")
	var shape = _createShape()
	match(shape_type):
		0:
			shape.radius = x
		1:
			shape.size = Vector2(x, y)
		_: 
			Debug.debug(self, "What Shape?")
	collision_shape.shape = shape


func _on_body_entered(body : Node2D) -> void:
	#Debug.debug(self, "%s entered %s hitbox\nemiting Signal" % [body, self], false)
	SignalHub.hitbox_entered.emit(parent, body)

func _on_body_exited(body : Node2D) -> void:
	#Debug.debug(self, "%s exited %s hitbox\nemiting Signal" % [body, self], false)
	SignalHub.hitbox_exited.emit(parent, body)
