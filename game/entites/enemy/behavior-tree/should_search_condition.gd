@tool
class_name ShouldSearchCondition
extends EnemyBTCondition
## Succeeds while the enemy should search its last known target area.

func tick(actor: Node, _blackboard: Blackboard) -> int:
	var enemy: Enemy = get_enemy(actor)
	if enemy == null:
		return FAILURE
	if enemy.should_search:
		return SUCCESS
	return FAILURE
