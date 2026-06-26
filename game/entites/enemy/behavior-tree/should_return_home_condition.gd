@tool
class_name ShouldReturnHomeCondition
extends EnemyBTCondition
## Allows return-home only after search is finished and retry cooldown has expired.

const RETRY_AT_KEY: StringName = &"return_home_retry_at"

@export var stop_distance: float = 8.0

func tick(actor: Node, blackboard: Blackboard) -> int:
	var enemy: Enemy = get_enemy(actor)
	if enemy == null:
		return FAILURE
	if enemy.should_search:
		return FAILURE
	if enemy.can_see_player():
		return FAILURE
	if enemy.is_home_reached(stop_distance):
		return FAILURE
	if _is_retry_blocked(blackboard):
		return FAILURE
	return SUCCESS

func _is_retry_blocked(blackboard: Blackboard) -> bool:
	var now := Time.get_ticks_msec() / 1000.0
	var retry_at := float(blackboard.get_value(RETRY_AT_KEY, 0.0))
	return now < retry_at
