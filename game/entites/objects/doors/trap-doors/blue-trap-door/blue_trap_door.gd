class_name BlueTrapDoor extends StaticBody2D

var sprite: AnimatedSprite2D
var collision: CollisionShape2D
var is_open: bool = false
var is_transitioning: bool = false
var door_timer: Timer

func _ready():
	sprite = get_node("AnimatedSprite2D")
	assert(sprite != null, "ERROR/BlueTrapDoor: AnimatedSprite2D not set")
	sprite.play("Idle")
	sprite.animation_finished.connect(_on_animation_finished)
	
	# Set up the collision object
	collision = get_node("CollisionShape2D")
	assert(collision != null, "ERROR/BlueTrapDoor: CollisionShape2D not set")
	
	# Setup the timer for delayed closing
	door_timer = Timer.new()
	door_timer.one_shot = true
	add_child(door_timer)
	door_timer.timeout.connect(_on_door_timer_timeout)
	
	# Setup the signal connections
	SignalHub.blue_pressure_plate_activated.connect(_on_blue_pressure_plate_activated)
	SignalHub.blue_pressure_plate_deactivated.connect(_on_blue_pressure_plate_deactivated)
	
	
func _on_blue_pressure_plate_activated():
	if not is_open and not is_transitioning:
		is_transitioning = true
		sprite.play("Open")
		# Cancel any pending close time
		door_timer.stop()

func _on_blue_pressure_plate_deactivated():
	door_timer.start(1)

func _on_door_timer_timeout():
	Debug.debug(self, "TrapDoor Timer Timed out")
	if is_open and not is_transitioning:
		Debug.debug(self, "TrapDoor Should be shutting")
		is_transitioning = true
		sprite.play("Shut")

func _on_animation_finished():
	if sprite.animation == "Open":
		is_open = true
		is_transitioning = false
		collision.set_deferred("disabled", true)
		Debug.debug(self, "Door opened, collision disabled")
	elif sprite.animation == "Shut":
		is_open = false
		is_transitioning = false
		collision.set_deferred("disabled", false)
		Debug.debug(self, "Door closed, collision enabled")
