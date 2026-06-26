class_name EnemyLookAround extends EnemyState
## LOOK-AROUND STATE — flips in place a few times searching; chases on sight or idles.

@export var idle_state: FSMState
@export var chase_state: FSMState
@export var look_amount: int = 5
@export var flip_interval: float = 2.0

var flips_left: int
var look_timer: Timer

func enter() -> void:
	super()
	walk.direction = 0.0
	flips_left = look_amount
	look_timer = Timer.new()
	look_timer.one_shot = false
	look_timer.wait_time = flip_interval
	look_timer.autostart = true
	look_timer.timeout.connect(_on_look_timer_timeout)
	add_child(look_timer)
	_on_look_timer_timeout()

func _on_look_timer_timeout() -> void:
	enemy.dir = -enemy.dir
	flips_left -= 1

func process_frame(_delta: float) -> FSMState:
	if enemy.player_in_sight:
		return chase_state
	if flips_left <= 0:
		look_timer.stop()
		return idle_state
	return null
