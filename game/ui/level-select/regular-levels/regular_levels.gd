extends Control

@onready var go_back_button: Button = %GoBack
@onready var level_container: GridContainer = $Panel/HBoxContainer/VBoxContainer/ButtonContainer/levelContainer
@onready var level_1: Button = $Panel/HBoxContainer/VBoxContainer/ButtonContainer/levelContainer/Level1
@onready var level_2: Button = $Panel/HBoxContainer/VBoxContainer/ButtonContainer/levelContainer/Level2
@onready var level_3: Button = $Panel/HBoxContainer/VBoxContainer/ButtonContainer/levelContainer/Level3
@onready var level_4: Button = $Panel/HBoxContainer/VBoxContainer/ButtonContainer/levelContainer/Level4
@onready var level_5: Button = $Panel/HBoxContainer/VBoxContainer/ButtonContainer/levelContainer/Level5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_1.pressed.connect(SceneManager.selectLevel.bind(5))
	level_2.pressed.connect(SceneManager.selectLevel.bind(6))
	level_3.pressed.connect(SceneManager.selectLevel.bind(7))
	level_4.pressed.connect(SceneManager.selectLevel.bind(8))
	level_5.pressed.connect(SceneManager.selectLevel.bind(9))
	go_back_button.pressed.connect(SceneManager.open_level_select)
	
