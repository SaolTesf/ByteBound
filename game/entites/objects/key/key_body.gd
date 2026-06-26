class_name Key extends CharacterBody2D

@export var grav_comp : GravityComponent
var hitbox : Hitbox
#var collectSound : AudioStreamPlayer2D

func _ready() -> void:
	Validate.check_reference(self, "grav_comp", "GravityComponent")
	assert(grav_comp != null, "ERROR/Key: GravityComponent not set")

	hitbox = find_child("HitBox")
	assert(hitbox != null, "ERROR/Key: Area2D not set")
	hitbox.init(self)
	grav_comp.init(self)
	
	SignalHub.key_collected.connect(_on_key_collected)

	#collectSound = get_node("CollectSound")



func _physics_process(delta : float) -> void:	
	grav_comp.physics_update(delta)
	move_and_slide()


## What Happens when this object is collected?
func _on_key_collected() -> void:
	#collectSound.play()
	self.queue_free()
