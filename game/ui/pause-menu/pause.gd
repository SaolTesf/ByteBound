extends CanvasLayer
@onready var reload_button: Button = %Reload
@onready var main_menu_button: Button = %MainMenu
@onready var quit_button: Button = %Quit

func _ready():
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS
	main_menu_button.pressed.connect(SceneManager.open_main_menu)
	reload_button.pressed.connect(SceneManager.reload)
	quit_button.pressed.connect(quit_game)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()

func toggle_pause():
	var tree = get_tree()
	tree.paused = not tree.paused  # toggles pause state
	visible = tree.paused  # show/hide the menu based on pause state

func quit_game():
	get_tree().quit()
