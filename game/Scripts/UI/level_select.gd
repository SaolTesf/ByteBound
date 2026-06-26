extends Control

@onready var go_back_button: Button = %GoBack
@onready var level_1: Button = $Panel/HBoxContainer/VBoxContainer/ButtonContainer/VBox/levelContainer/Level1
@onready var level_2: Button = $Panel/HBoxContainer/VBoxContainer/ButtonContainer/VBox/levelContainer/Level2

# Called when the uttonode enters the scene tree for the first time.
func _ready() -> void:
	
	level_1.pressed.connect(SceneManager.open_tutorial_selection)
	level_2.pressed.connect(SceneManager.open_regualr_selection)
	go_back_button.pressed.connect(SceneManager.open_main_menu)
		
