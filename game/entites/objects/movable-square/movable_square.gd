class_name MovableSquare extends CharacterBody2D

@export var acceleration : float = 10.0  # Increased from 5.0
@export var push_force : float = 40.0  # Increased from 10.0 for faster movement
@export var max_push_force: float = 80.0  # Increased from 18.0
@export var friction: float = 6.0  # Keep as is
@export var gravity_scale: float = 0.5  # New parameter to control falling speed (less than 1.0 for slower fall)

# Refrences to the squares other nodes.
@export var gravity : GravityComponent # allow the block to fall
@export var collision : CollisionShape2D
@export var hitbox : Hitbox

var push_box : bool = false # allows the box to be pushed
var direction : float


func _ready() -> void:
	# Set the box to the Movable group
	add_to_group("Movable")
	
	# Make sure the node refrences exist.
	assert(gravity != null, "Squares GravityComponent is null")
	assert(collision != null, "Squares CollisionShape2D is null")
	assert(hitbox != null, "Squares Area2D is null")

	# Set up the signals to detect when the player is in contact with the box.
	hitbox.body_entered.connect(_on_body_entered)
	hitbox.body_exited.connect(_on_body_exited)
	gravity.init(self)
	# Modify the gravity value directly for slower falling
	gravity.gravity = gravity.gravity * gravity_scale
	gravity.fast_fall_gravity = gravity.fast_fall_gravity * gravity_scale


func _physics_process(delta: float) -> void:
	gravity.physics_update(delta) # always apply gravity to the box
	if push_box:
		# If the player is in contact with the box, apply a force to the box.
		velocity.x = lerp(velocity.x, direction * push_force, acceleration * delta)
	else:
		# If the player is not in contact with the box, apply friction to the box.
		velocity.x = lerp(velocity.x, 0.0, friction * delta)

	move_and_slide()


func _on_body_entered(body: Node) -> void:
	#Debug.debug(self, "%s hit the moving square" % body.name)
	# If the player is in contact with the box, set the box to be pushed.
	if body.name == "Player":
		SignalHub.movable_box_hit.emit(self)
		direction = -sign(body.global_position.x - global_position.x) # should return -1 or 1
		push_box = true
		#var params = [direction, push_box, velocity.x]
		#var message = "Player is in contact with the box\ndirection: %s\npush_box: %s\nvelocityX: %f" % params
		#Debug.debug(self, message, false)
		# Calculate push force based on player's velocity (scales push by player speed)
		var player_velocity = body.velocity.length()
		push_force = clamp(player_velocity * 1.5, 30.0, max_push_force)
		#Debug.debug(self, "Calculated Push_force: %f" % push_force, false)		

		
func _on_body_exited(body: Node) -> void:
	# If the player is no longer in contact with the box, set the box to not be pushed.
	if body.name == "Player":
		#print("DEBUG: Player is no longer in contact with the box")
		push_box = false
