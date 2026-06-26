extends Control

const CATALOG_PATH: String = "res://custom-resources/sceneCatalog.tres"
const CATEGORY: int = 1

@onready var go_back_button: Button = %GoBack
@onready var level_container: GridContainer = $Panel/HBoxContainer/VBoxContainer/ButtonContainer/levelContainer
@onready var level_1: Button = $Panel/HBoxContainer/VBoxContainer/ButtonContainer/levelContainer/Level1
@onready var level_2: Button = $Panel/HBoxContainer/VBoxContainer/ButtonContainer/levelContainer/Level2
@onready var level_3: Button = $Panel/HBoxContainer/VBoxContainer/ButtonContainer/levelContainer/Level3
@onready var level_4: Button = $Panel/HBoxContainer/VBoxContainer/ButtonContainer/levelContainer/Level4
@onready var level_5: Button = $Panel/HBoxContainer/VBoxContainer/ButtonContainer/levelContainer/Level5

var _catalog: Resource

func _ready() -> void:
	_catalog = _load_catalog()
	_bind_levels([level_1, level_2, level_3, level_4, level_5])
	go_back_button.pressed.connect(SceneManager.change_to.bind(_get_scene(&"level_select_scene")))
	return

func _bind_levels(buttons: Array[Button]) -> void:
	var level_indices: Array = _catalog.call("get_level_indices", CATEGORY)
	var levels: Array = _catalog.get("campaign_levels")
	for i in range(buttons.size()):
		var button: Button = buttons[i]
		if i >= level_indices.size():
			button.hide()
			continue

		var level_index: int = level_indices[i]
		var level: Resource = levels[level_index] as Resource
		button.text = str(level.get("title"))
		button.show()
		button.pressed.connect(_on_level_pressed.bind(level_index))
	return

func _on_level_pressed(level_index: int) -> void:
	SceneManager.start_campaign(_catalog.get("campaign_levels"), _get_scene(&"campaign_complete_scene"), level_index)
	return

func _load_catalog() -> Resource:
	var catalog: Resource = ResourceLoader.load(CATALOG_PATH)
	assert(catalog, "RegularLevels: scene catalog not found")
	return catalog

func _get_scene(property: StringName) -> PackedScene:
	return _catalog.get(property) as PackedScene
