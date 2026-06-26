
class_name Throwable extends RigidBody2D

var hand_node : Node
@export var hitbox : Hitbox
@export var collision : CollisionShape2D

var is_picked_up : bool = false 
var in_range : bool = false
@export var player: Player

func _ready():
	Validate.check_reference(self, "hitbox", "HitBox")
	Validate.check_reference(self, "collision", "CollisionShape2D")

	hitbox.init(self)
	

## looks at the players input to see if they want to interact or throw
func _input(event : InputEvent):
	if !player: return # if no player is set do not look for input
	if player.input.get_interact():
		if !is_picked_up and in_range:
			pickup()
		elif is_picked_up:
			drop()
			
	if player.input.get_throw():
		if is_picked_up:
			throw()

			
## When something is picked up set flags
## disable gravity
## disable collision
func pickup():
	Debug.debug(self, "Pickup function called")
	if not player:
		push_error("player should be a refrence before this is called")
	# set the flags
	is_picked_up = true
	if player:
		player.hands_free = false

	# disable gravity
	self.freeze = true
	collision.disabled = true

	# reparent to the player
	call_deferred("reparent", player.hand)
	await get_tree().process_frame

	global_position = player.hand.global_position


# Handles resetting the flags on drop
# Places back in the tree.
# re enables physics and collision
func drop():
	Debug.debug(self, "Drop function called")
	player.hands_free = true
	is_picked_up = false
	collision.disabled = false
	call_deferred("reparent", player.get_parent())
	await get_tree().process_frame
	self.freeze = false

func _process(delta: float) -> void:
	if !in_range and !is_picked_up:
		player = null
	
# Handles resetting the flags on throw
# Places object back in tree and applies a force to it.
# re enables the physics and collision
func throw():
	Debug.debug(self, "throw function called")
	player.hands_free = true
	is_picked_up = false
	collision.disabled = false
	call_deferred("reparent", player.get_parent())
	await get_tree().process_frame
	var x_force = player.dir * 300
	self.freeze = false
	apply_impulse(Vector2(x_force, -300))
