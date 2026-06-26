extends CanvasLayer
const CATALOG_PATH: String = "res://custom-resources/sceneCatalog.tres"

@onready var reload_button: Button = %Reload
@onready var main_menu_button: Button = %MainMenu
@onready var quit_button: Button = %Quit

var _catalog: Resource

func _ready() -> void:
	_catalog = _load_catalog()
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS
	main_menu_button.pressed.connect(SceneManager.change_to.bind(_get_scene(&"main_menu_scene")))
	reload_button.pressed.connect(SceneManager.reload)
	quit_button.pressed.connect(quit_game)
	return

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()
	return

func toggle_pause() -> void:
	var tree: SceneTree = get_tree()
	tree.paused = not tree.paused  # toggles pause state
	visible = tree.paused  # show/hide the menu based on pause state
	return

func quit_game() -> void:
	get_tree().quit()
	return

func _load_catalog() -> Resource:
	var catalog: Resource = ResourceLoader.load(CATALOG_PATH)
	assert(catalog, "PauseMenu: scene catalog not found")
	return catalog

func _get_scene(property: StringName) -> PackedScene:
	return _catalog.get(property) as PackedScene
