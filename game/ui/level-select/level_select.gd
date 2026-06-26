extends Control

const CATALOG_PATH: String = "res://custom-resources/sceneCatalog.tres"

@onready var go_back_button: Button = %GoBack
@onready var level_1: Button = $Panel/HBoxContainer/VBoxContainer/ButtonContainer/VBox/levelContainer/Level1
@onready var level_2: Button = $Panel/HBoxContainer/VBoxContainer/ButtonContainer/VBox/levelContainer/Level2

var _catalog: Resource

func _ready() -> void:
	_catalog = _load_catalog()
	level_1.pressed.connect(SceneManager.change_to.bind(_get_scene(&"tutorial_select_scene")))
	level_2.pressed.connect(SceneManager.change_to.bind(_get_scene(&"regular_select_scene")))
	go_back_button.pressed.connect(SceneManager.change_to.bind(_get_scene(&"main_menu_scene")))
	return

func _load_catalog() -> Resource:
	var catalog: Resource = ResourceLoader.load(CATALOG_PATH)
	assert(catalog, "LevelSelect: scene catalog not found")
	return catalog

func _get_scene(property: StringName) -> PackedScene:
	return _catalog.get(property) as PackedScene
