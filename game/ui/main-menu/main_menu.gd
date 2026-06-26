extends Control

const MUSIC: AudioPoolStream = preload("res://Assets/Audio/pool-streams/music.tres")
const CATALOG_PATH: String = "res://custom-resources/sceneCatalog.tres"

@onready var new_game_button: Button = %New_Game
@onready var select_level_button: Button = %Select_Level
@onready var settings_button: Button = %Settings
@onready var quit_button: Button = %Quit

var _catalog: Resource

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_catalog = _load_catalog()
	AudioPool.play_unique(MUSIC)
	new_game_button.pressed.connect(_on_new_game_pressed)
	select_level_button.pressed.connect(SceneManager.change_to.bind(_get_scene(&"level_select_scene")))
	settings_button.pressed.connect(SceneManager.change_to.bind(_get_scene(&"settings_scene")))
	quit_button.pressed.connect(quit_game)
	return

func _on_new_game_pressed() -> void:
	SceneManager.start_campaign(_catalog.get("campaign_levels"), _get_scene(&"campaign_complete_scene"))
	return


func quit_game() -> void:
	get_tree().quit()
	return

func _load_catalog() -> Resource:
	var catalog: Resource = ResourceLoader.load(CATALOG_PATH)
	assert(catalog, "MainMenu: scene catalog not found")
	return catalog

func _get_scene(property: StringName) -> PackedScene:
	return _catalog.get(property) as PackedScene
