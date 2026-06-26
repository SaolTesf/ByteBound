extends Node
# List of tutorial Levels
var move_tutorial = "res://Scenes/Levels/Tutorials/move_tutorial.tscn"
var jump_tutorial = "res://Scenes/Levels/Tutorials/jump_tutorial.tscn"
var dash_tutorial = "res://Scenes/Levels/Tutorials/dash_tutorial.tscn"
var box_tutorial = "res://Scenes/Levels/Tutorials/box_tutorial.tscn"
var throw_tutorial = "res://Scenes/Levels/Tutorials/throw_tutorial.tscn"
# List of the levels in the game
var level_00 : String = "res://Scenes/Levels/level_00.tscn"
var level_01 : String = "res://Scenes/Levels/level_01.tscn"
var level_02 : String = "res://Scenes/Levels/level_02.tscn"
var level_03 : String = "res://Scenes/Levels/level_03.tscn"
var level_04 : String = "res://Scenes/Levels/level_04.tscn"

# array to hold all the level paths
var level_paths : Array[String] = [
	move_tutorial, jump_tutorial, dash_tutorial, box_tutorial,
	throw_tutorial, level_00,level_01, level_02, level_03,level_04]

var current_level_path: int = 0 # Start on the first level.
var current_level = null

var mainMenuPath : String = "res://UI/MainMenu/MainMenuControlNode.tscn"
var levelSelectPath : String = "res://UI/Level-Select/LevelSelectMenu.tscn"
var winMenuPath : String = "res://UI/GameOver/GameOver.tscn"
var tutorialSelectPath : String = "res://UI/Level-Select/Tutorial-Levels/TutorialLevels.tscn"
var regularSelectPath : String = "res://UI/Level-Select/Regular-Levels/RegularLevels.tscn"
var settingsMenuPath : String = "res://UI/OptionsMenu/Settings.tscn"

func _ready() -> void:
	var root = get_tree().root
	current_level = root.get_child(-1)

func play() -> void: #function to start game at level 1 when clicking play
	current_level_path = 0
	load_level(level_paths[0])

func selectLevel(levelNum) -> void:
	current_level_path = levelNum
	load_level(level_paths[levelNum])

func open_win_menu():
	load_level(winMenuPath)

func open_level_select(): #function to navigate to the level select scene
	load_level(levelSelectPath)

func open_tutorial_selection():
	load_level(tutorialSelectPath)

func open_regualr_selection():
	load_level(regularSelectPath)
	
func open_main_menu(): #function to navigate to main menu scene
	load_level(mainMenuPath)
	
func open_settings_menu(): #function to navigate to main menu scene
	load_level(settingsMenuPath)

func load_level(level) -> void:
	reset_pause()
	_defered_load_level.call_deferred(level)

func _defered_load_level(level) -> void:
	# It is now safe to remove the current scene.
	if current_level != null:
		current_level.queue_free()

	# Load the new scene.
	var s = ResourceLoader.load(level)

	# Instance the new scene.
	current_level = s.instantiate()

	# Add it to the active scene, as child of root.
	get_tree().root.add_child(current_level)

	# Optionally, to make it compatible with the SceneTree.change_scene_to_file() API.
	get_tree().current_scene = current_level
	
	
func reload() -> void:
	load_level(level_paths[current_level_path])

func next() -> void:
	current_level_path += 1
	var message : String = "Current Level Index: %d\nNumber of Levels: %d"
	var params : Array = [current_level_path, level_paths.size()]
	Debug.debug(self, message % params)
	if current_level_path >= level_paths.size():
		#loading past the last level open the win screen
		open_win_menu()
		return
	load_level(level_paths[current_level_path])


func previous() -> void:
	current_level_path -= 1
	load_level(level_paths[current_level_path])

func reset_pause():
	if get_tree().paused:
		get_tree().paused = false
