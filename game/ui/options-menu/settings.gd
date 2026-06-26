extends Control

const CATALOG_PATH: String = "res://custom-resources/sceneCatalog.tres"
const SFX_BUS: StringName = &"SFX"
const MUSIC_BUS: StringName = &"Music"

@onready var sfx_slider: HSlider = $Panel/HBoxContainer/VBoxContainer/SettingsContainer/SliderContainer/SFX
@onready var bgm_slider: HSlider = $Panel/HBoxContainer/VBoxContainer/SettingsContainer/SliderContainer/BGM
@onready var go_back_button: Button = %GoBack

var _catalog: Resource

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_catalog = _load_catalog()
	sfx_slider.set_value_no_signal(AudioSettings.get_volume(SFX_BUS))
	sfx_slider.value_changed.connect(_on_sfx_value_changed)

	bgm_slider.set_value_no_signal(AudioSettings.get_volume(MUSIC_BUS))
	bgm_slider.value_changed.connect(_on_bgm_value_changed)

	go_back_button.pressed.connect(_on_go_back_pressed)
	return

func _on_sfx_value_changed(value: float) -> void:
	AudioSettings.set_volume(SFX_BUS, value)
	return

func _on_bgm_value_changed(value: float) -> void:
	AudioSettings.set_volume(MUSIC_BUS, value)
	return

func _on_go_back_pressed() -> void:
	AudioSettings.save()
	SceneManager.change_to(_get_scene(&"main_menu_scene"))
	return

func _load_catalog() -> Resource:
	var catalog: Resource = ResourceLoader.load(CATALOG_PATH)
	assert(catalog, "Settings: scene catalog not found")
	return catalog

func _get_scene(property: StringName) -> PackedScene:
	return _catalog.get(property) as PackedScene
