class_name EnemyPatrol extends EnemyState
## PATROL STATE — walks in the current facing direction; flips/idles when the timer ends.

@export var idle: FSMState
@export var patrol: FSMState
@export var chase: FSMState

var patrol_timer: Timer
var in_patrol: bool

func enter() -> void:
	super()
	enemy.fov.modulate = enemy.original_color
	in_patrol = true
	setup_timer()
	patrol_timer.start()

func process_physics(_delta: float) -> FSMState:
	walk.direction = enemy.dir
	return null

func process_frame(_delta: float) -> FSMState:
	if not in_patrol:
		if move_stats.can_move and not move_stats.can_idle:
			enemy.dir = -enemy.dir
			return patrol
		if move_stats.can_idle:
			return idle
	if enemy.player_in_sight:
		return chase
	return null

func setup_timer() -> void:
	patrol_timer = Timer.new()
	patrol_timer.wait_time = move_stats.move_time
	patrol_timer.one_shot = true
	patrol_timer.timeout.connect(_on_timer_timeout)
	add_child(patrol_timer)

func _on_timer_timeout() -> void:
	in_patrol = false
