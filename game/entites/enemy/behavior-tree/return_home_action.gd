@tool
class_name ReturnHomeAction
extends EnemyBTAction
## Walks an enemy back to its spawn point using local platformer movement.

const RETRY_AT_KEY: StringName = &"return_home_retry_at"

@export var stop_distance: float = 8.0
@export var jump_probe_distance: float = 14.0
@export var floor_probe_depth: float = 24.0
@export var vertical_jump_threshold: float = 12.0
@export var jump_x_window: float = 24.0
@export var stuck_timeout: float = 2.0
@export var retry_delay: float = 1.5
@export var min_progress: float = 2.0

var _last_distance: float = INF
var _stuck_time: float = 0.0

func before_run(actor: Node, _blackboard: Blackboard) -> void:
	var enemy: Enemy = get_enemy(actor)
	if enemy == null:
		return
	_last_distance = enemy.global_position.distance_to(enemy.home_position)
	_stuck_time = 0.0
	return

func tick(actor: Node, blackboard: Blackboard) -> int:
	var enemy: Enemy = get_enemy(actor)
	if enemy == null:
		return FAILURE
	if enemy.is_home_reached(stop_distance):
		_stop(enemy)
		return SUCCESS

	var direction := _home_direction(enemy)
	enemy.walk.direction = direction
	if direction != 0.0:
		enemy.dir = int(direction)
	if _should_jump(enemy, direction):
		enemy.jump.jump(enemy)
	if _is_stuck(enemy):
		_stop(enemy)
		blackboard.set_value(RETRY_AT_KEY, Time.get_ticks_msec() / 1000.0 + retry_delay)
		return FAILURE
	return RUNNING

func interrupt(actor: Node, blackboard: Blackboard) -> void:
	super(actor, blackboard)
	var enemy: Enemy = get_enemy(actor)
	if enemy == null:
		return
	_stop(enemy)
	return

func after_run(actor: Node, _blackboard: Blackboard) -> void:
	var enemy: Enemy = get_enemy(actor)
	if enemy == null:
		return
	_stop(enemy)
	return

func _home_direction(enemy: Enemy) -> float:
	var to_home := enemy.home_position - enemy.global_position
	return signf(to_home.x)

func _should_jump(enemy: Enemy, direction: float) -> bool:
	if enemy.jump == null or not enemy.jump.can_jump():
		return false
	if not _is_grounded(enemy):
		return false
	if _home_is_above(enemy):
		return true
	if direction == 0.0:
		return false
	if enemy.is_on_wall():
		return true
	if _has_wall_ahead(enemy, direction):
		return true
	return _has_gap_ahead(enemy, direction)

func _home_is_above(enemy: Enemy) -> bool:
	var to_home := enemy.home_position - enemy.global_position
	return to_home.y < -vertical_jump_threshold and absf(to_home.x) <= jump_x_window

func _has_wall_ahead(enemy: Enemy, direction: float) -> bool:
	var motion := Vector2(direction * jump_probe_distance, 0.0)
	return enemy.test_move(enemy.global_transform, motion)

func _has_gap_ahead(enemy: Enemy, direction: float) -> bool:
	var space_state := enemy.get_world_2d().direct_space_state
	var start := enemy.global_position + Vector2(direction * jump_probe_distance, 0.0)
	var query := PhysicsRayQueryParameters2D.create(start, start + Vector2.DOWN * floor_probe_depth)
	query.exclude = [enemy.get_rid()]
	query.collision_mask = enemy.collision_mask
	var result := space_state.intersect_ray(query)
	return result.is_empty()

func _is_grounded(enemy: Enemy) -> bool:
	return enemy.is_on_floor()

func _is_stuck(enemy: Enemy) -> bool:
	var distance := enemy.global_position.distance_to(enemy.home_position)
	if _last_distance - distance >= min_progress:
		_last_distance = distance
		_stuck_time = 0.0
		return false
	_stuck_time += delta_time()
	return _stuck_time >= stuck_timeout

func _stop(enemy: Enemy) -> void:
	enemy.walk.direction = 0.0
	return
