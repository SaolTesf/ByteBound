class_name RedLazer extends Lazer

func _ready() -> void:
	super._ready()
	type = Globals.LazerType.RED
	sprite.play("Active")

	SignalHub.red_pedistal_activated.connect(_on_red_pedistal_activated)
	SignalHub.red_pressure_plate_activated.connect(_on_red_pressure_plate_activated)
	SignalHub.red_pressure_plate_deactivated.connect(_on_red_pressure_plate_deactivated)

func _on_red_pedistal_activated() -> void:
	perma_open = true # if opened by pedistal keep the lazer off
	if is_active:
		is_active = false
		sprite.play("Disabled")
		light.enabled = false
		print("DEBUG: The red lazer has been deactivated")

func _on_red_pressure_plate_activated() -> void:
	if is_active and !perma_open:   
		is_active = false
		sprite.play("Disabled")
		light.enabled = false
		print("DEBUG: The red lazer has been deactivated")

func _on_red_pressure_plate_deactivated() -> void:
	if !is_active and !perma_open:
		is_active = true
		sprite.play("Activate")
		light.enabled = true
		just_activated = true
		print("DEBUG: The red lazer has been activated")
