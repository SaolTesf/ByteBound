class_name Lazer extends Area2D

var sprite : AnimatedSprite2D
var light : PointLight2D
var is_active : bool = true
var perma_open: bool = false
var type : Globals.LazerType = Globals.LazerType.DEFAULT

# set true when the player leaves pressure plate, set false one the Active animation is playing
var just_activated : bool = false 

func _ready() -> void:
	sprite = find_child("AnimatedSprite2D")
	light = find_child("PointLight2D")
	assert(sprite != null, "ERROR: Lazer/_ready(): The sprite is null")
	assert(light != null, "ERROR: Lazer/_ready(): The light is null")

	sprite.play("Active") # Start the lazers off as active
	light.enabled = true

	AudioController.play_sound("LaserField")
	
	# Set up the signals to detect player collision and animations
	body_entered.connect(_on_body_entered)

	
func _process(_delta: float) -> void:
	# if the laser was just activated and there is no animation playing, play active
	if !sprite.is_playing() and just_activated:
		sprite.play("Active")
		just_activated = false
	update_sound()

func update_sound():
	if is_active and !AudioController.is_playing("LaserField"):
		AudioController.play_sound("LaserField")
	elif !is_active:
		AudioController.stop_sound("LaserField")
		
func _on_body_entered(body : Node) -> void:
	Debug.debug(self, "%s Entered the Laser" % body.get_script().get_global_name(), false)
	if body.is_in_group("Player"):
		if is_active:
			#hitSound.play()
			AudioController.play_sound("LaserCollision")
			body.handleDeath()
