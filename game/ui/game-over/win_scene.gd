extends Control
@onready var new_game_button: Button = %MainMenu
@onready var quit_button: Button = %Quit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game_button.pressed.connect(SceneManager.open_main_menu)
	quit_button.pressed.connect(quit_game)

func quit_game():
	get_tree().quit()
