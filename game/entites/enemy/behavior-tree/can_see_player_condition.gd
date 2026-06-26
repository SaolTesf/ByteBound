@tool
class_name CanSeePlayerCondition
extends EnemyBTCondition
## Succeeds while the enemy has a valid sighted player.

func tick(actor: Node, _blackboard: Blackboard) -> int:
	var enemy: Enemy = get_enemy(actor)
	if enemy == null:
		return FAILURE
	if enemy.can_see_player():
		return SUCCESS
	return FAILURE
