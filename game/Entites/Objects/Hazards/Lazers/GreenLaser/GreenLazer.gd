class_name GreenLazer extends Lazer

func _ready() -> void:
	super._ready()
	sprite.play("Active")
	type = Globals.LazerType.GREEN

	SignalHub.green_pedistal_activated.connect(_on_green_pedistal_activated)
	SignalHub.green_pressure_plate_activated.connect(_on_green_pressure_plate_activated)
	SignalHub.green_pressure_plate_deactivated.connect(_on_green_pressure_plate_deactivated)


func _on_green_pedistal_activated() -> void:
	perma_open = true
	if is_active:
		is_active = false
		perma_open = true # if opened by pedistal keep the lazer off
		sprite.play("Disabled")
		light.enabled = false
		print("DEBUG GreenLazer/Pedestal: The green lazer has been deactivated")


func _on_green_pressure_plate_activated() -> void:
	if is_active and !perma_open:
		is_active = false
		sprite.play("Disabled")
		light.enabled = false
		print("DEBUG GreenLazer/PressurePlate: The green lazer has been deactivated")


func _on_green_pressure_plate_deactivated() -> void:
	if !is_active and !perma_open:
		is_active = true
		sprite.play("Activate")
		light.enabled = true
		just_activated = true
		
		print("DEBUG GreenLazer/PressurePlate: The green lazer has been activated")
