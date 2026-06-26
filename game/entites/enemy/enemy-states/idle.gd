class_name EnemyIdle extends EnemyState
## IDLE STATE
##
## The enemy waits in place for [member MoveStats.idle_time], then either patrols
## (if it can move) or idles again. Sighting the player transitions to chase.

@export var patrol: FSMState
@export var idle: FSMState
@export var chase: FSMState

var idle_timer: Timer
## Allows the enemy to change state once the timer ends.
var in_idle: bool

func enter() -> void:
	super()
	in_idle = true
	enemy.fov.modulate = enemy.original_color
	enemy.dir = -enemy.dir
	enemy.velocity = Vector2.ZERO
	setup_timer()
	idle_timer.start()

func process_frame(_delta: float) -> FSMState:
	if not in_idle:
		if move_stats.can_move:
			return patrol
		if not move_stats.can_move and move_stats.can_idle:
			return idle
	if enemy.player_in_sight:
		return chase
	return null

func process_physics(delta: float) -> FSMState:
	move_stats.handle_gravity(enemy, false, delta)
	enemy.move_and_slide()
	return null

func setup_timer() -> void:
	idle_timer = Timer.new()
	idle_timer.wait_time = move_stats.idle_time
	idle_timer.one_shot = true
	idle_timer.timeout.connect(_on_timer_timeout)
	add_child(idle_timer)

func _on_timer_timeout() -> void:
	in_idle = false
