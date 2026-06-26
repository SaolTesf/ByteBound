extends Control

const CATALOG_PATH: String = "res://custom-resources/sceneCatalog.tres"

@onready var new_game_button: Button = %MainMenu
@onready var quit_button: Button = %Quit

var _catalog: Resource

func _ready() -> void:
	_catalog = _load_catalog()
	new_game_button.pressed.connect(SceneManager.change_to.bind(_get_scene(&"main_menu_scene")))
	quit_button.pressed.connect(quit_game)
	return

func quit_game() -> void:
	get_tree().quit()
	return

func _load_catalog() -> Resource:
	var catalog: Resource = ResourceLoader.load(CATALOG_PATH)
	assert(catalog, "WinScene: scene catalog not found")
	return catalog

func _get_scene(property: StringName) -> PackedScene:
	return _catalog.get(property) as PackedScene
