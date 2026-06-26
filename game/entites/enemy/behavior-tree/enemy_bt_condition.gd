@tool
class_name EnemyBTCondition
extends ConditionLeaf
## Base condition leaf for [Enemy] behavior trees.

func get_enemy(actor: Node) -> Enemy:
	if actor is Enemy:
		return actor as Enemy
	push_error("%s expected an Enemy actor." % name)
	return null
