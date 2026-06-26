class_name ExitDoor extends Area2D

var _door_sprite : AnimatedSprite2D
var _door_locked : bool = true
var _door_open : bool = false
var _level_complete : bool = false
var _door_delay : float = 0.5

@export var light : PointLight2D


func _ready() -> void:
	# Set up the signals
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

	SignalHub.key_collected.connect(_on_key_collected)
	
	# Set up the default sprite
	_door_sprite = get_node("DoorSprite")
	assert(_door_sprite != null, "DoorSprite not found")
	_door_sprite.play("Locked")
	light.color = Color.ORANGE
	_door_sprite.animation_finished.connect(_on_animation_finished)


func _process(delta: float) -> void:
	if !_door_sprite.is_playing() and _level_complete:
		_level_complete = false
		if SceneManager.current_level_path == SceneManager.level_paths.size():
				SceneManager.open_win_menu()
		await _delay(_door_delay)
		SceneManager.next()
	
## Called when the player collects a key, Chnage door state to unlocked
func _on_key_collected() -> void:
	_door_locked = false
	light.color = Color.LAWN_GREEN
	Debug.debug(self, "Key Collected Door is Now Unlocked %s" % _door_locked, false)
	_door_sprite.play("Unlocked")
	

func _on_body_entered(body: Node2D) -> void:
	# Check if the body is the player
	if body.is_in_group("Player"):
		# Check the state of the door
		if _door_locked == false:
			Debug.debug(self, "Player Entered the door, Door is %s" % _door_locked, false)
			light.enabled = false
			await _delay(_door_delay)
			_door_sprite.play("Open")
			_door_sprite.animation_finished.emit()
			_door_open = true
		else:
			Debug.debug(self, "Player Entered Door, Door is %s" % _door_locked, false)


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Debug.debug(self, "Player Left the door Area", false)
		if _door_open == true:
			await _delay(_door_delay)
			_door_open = false	
			_door_sprite.play("Close")


func _on_animation_finished() -> void:
	# Make sure the door is opend and the animation is done playing 
	if _door_sprite.animation == "Open":
		_level_complete = true

func _delay(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
