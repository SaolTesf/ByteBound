@tool
class_name PatrolIdleRoutineAction
extends EnemyBTAction
## Runs the enemy's idle/patrol loop using [MoveStats] timing.

enum RoutineState {
	IDLE,
	PATROL,
}

var _state: RoutineState = RoutineState.IDLE
var _time_left: float = 0.0

func before_run(actor: Node, _blackboard: Blackboard) -> void:
	var enemy: Enemy = get_enemy(actor)
	if enemy == null:
		return
	_start_idle(enemy)
	return

func tick(actor: Node, _blackboard: Blackboard) -> int:
	var enemy: Enemy = get_enemy(actor)
	if enemy == null:
		return FAILURE

	match _state:
		RoutineState.IDLE:
			_tick_idle(enemy)
		RoutineState.PATROL:
			_tick_patrol(enemy)
	return RUNNING

func interrupt(actor: Node, blackboard: Blackboard) -> void:
	super(actor, blackboard)
	var enemy: Enemy = get_enemy(actor)
	if enemy == null:
		return
	enemy.walk.direction = 0.0
	return

func after_run(actor: Node, _blackboard: Blackboard) -> void:
	var enemy: Enemy = get_enemy(actor)
	if enemy == null:
		return
	enemy.walk.direction = 0.0
	return

func _tick_idle(enemy: Enemy) -> void:
	enemy.walk.direction = 0.0
	enemy.fov.modulate = enemy.original_color
	if _time_left > 0.0:
		_time_left -= delta_time()
		return
	if enemy.movement_stats.can_move:
		_start_patrol(enemy)
		return
	if enemy.movement_stats.can_idle:
		_start_idle(enemy)
		return
	return

func _tick_patrol(enemy: Enemy) -> void:
	enemy.fov.modulate = enemy.original_color
	enemy.walk.direction = enemy.dir
	if _time_left > 0.0:
		_time_left -= delta_time()
		return
	if enemy.movement_stats.can_move and not enemy.movement_stats.can_idle:
		enemy.dir = -enemy.dir
		_start_patrol(enemy)
		return
	if enemy.movement_stats.can_idle:
		_start_idle(enemy)
		return
	enemy.walk.direction = 0.0
	return

func _start_idle(enemy: Enemy) -> void:
	_state = RoutineState.IDLE
	_time_left = enemy.movement_stats.idle_time
	enemy.fov.modulate = enemy.original_color
	enemy.dir = -enemy.dir
	enemy.walk.direction = 0.0
	return

func _start_patrol(enemy: Enemy) -> void:
	_state = RoutineState.PATROL
	_time_left = enemy.movement_stats.move_time
	enemy.fov.modulate = enemy.original_color
	enemy.walk.direction = enemy.dir
	return
