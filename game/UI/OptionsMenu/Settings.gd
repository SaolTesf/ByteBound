extends Control

@onready var sfx_slider: HSlider = $Panel/HBoxContainer/VBoxContainer/SettingsContainer/SliderContainer/SFX
@onready var bgm_slider: HSlider = $Panel/HBoxContainer/VBoxContainer/SettingsContainer/SliderContainer/BGM
@onready var go_back_button: Button = %GoBack

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(1))
	sfx_slider.value_changed.connect(_on_sfx_value_changed)
	
	bgm_slider.value = db_to_linear(AudioServer.get_bus_volume_db(2))	
	bgm_slider.value_changed.connect(_on_bgm_value_changed)

	go_back_button.pressed.connect(SceneManager.open_main_menu)

func _on_sfx_value_changed(value: float):
	AudioServer.set_bus_volume_db(1, linear_to_db(sfx_slider.value))

func _on_bgm_value_changed(value: float):
	AudioServer.set_bus_volume_db(2, linear_to_db(bgm_slider.value))


# Might be unnecessary
func _on_confirm_pressed() -> void:
	AudioServer.set_bus_volume_db(1, linear_to_db(sfx_slider.value))
	AudioServer.set_bus_volume_db(2, linear_to_db(bgm_slider.value))