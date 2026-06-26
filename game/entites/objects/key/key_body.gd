class_name Key extends CharacterBody2D

@export var grav_comp : GravityComponent
var hitbox : Hitbox
#var collectSound : AudioStreamPlayer2D

func _ready() -> void:
	Validate.check_reference(self, "grav_comp", "GravityComponent")
	assert(grav_comp != null, "ERROR/Key: GravityComponent not set")

	hitbox = find_child("HitBox")
	assert(hitbox != null, "ERROR/Key: Area2D not set")
	hitbox.init()
	hitbox.entered.connect(_on_hitbox_entered)

	SignalHub.key_collected.connect(_on_key_collected)

	#collectSound = get_node("CollectSound")



func _physics_process(delta : float) -> void:
	grav_comp.physics_update(self, delta)
	move_and_slide()


## When the player enters the key's hitbox, broadcast that the key was collected.
func _on_hitbox_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		SignalHub.key_collected.emit()


## What Happens when this object is collected?
func _on_key_collected() -> void:
	#collectSound.play()
	self.queue_free()
