class_name EnemyPatrol extends EnemyState
## PATROL STATE
##
## The enemy walks in its current facing direction for [member MoveStats.move_time].
## When the timer ends it flips and patrols again, or idles; sighting the player
## transitions to chase.

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

func process_physics(delta: float) -> FSMState:
	move_stats.handle_horizontal_input(enemy, enemy.dir, delta)
	move_stats.handle_gravity(enemy, false, delta)
	enemy.move_and_slide()
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
