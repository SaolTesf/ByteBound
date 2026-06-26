class_name BlueLazer extends Lazer

func _ready() -> void:
	super._ready()
	type = Globals.LazerType.BLUE
	sprite.play("Active")
	# Set up the signals to detect player collision and animations
	SignalHub.blue_pedistal_activated.connect(_on_blue_pedistal_activated)
	SignalHub.blue_pressure_plate_activated.connect(_on_blue_pressure_plate_activated)
	SignalHub.blue_pressure_plate_deactivated.connect(_on_blue_pressure_plate_deactivated)


func _on_blue_pedistal_activated() -> void:
	perma_open = true
	if is_active:
		is_active = false
		sprite.play("Disabled")
		light.enabled = false
		print("DEBUG: The blue lazer has been deactivated")
	

func _on_blue_pressure_plate_activated() -> void:
	if is_active and !perma_open:
		is_active = false
		sprite.play("Disabled")
		light.enabled = false
		print("DEBUG: The blue lazer has been deactivated")


func _on_blue_pressure_plate_deactivated() -> void:
	if !is_active and !perma_open:
		is_active = true
		sprite.play("Activate")
		light.enabled = true
		just_activated = true
		print("DEBUG: The blue lazer has been activated")
