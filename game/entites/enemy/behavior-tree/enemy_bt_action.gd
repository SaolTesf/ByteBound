@tool
class_name EnemyBTAction
extends ActionLeaf
## Base action leaf for [Enemy] behavior trees.

func get_enemy(actor: Node) -> Enemy:
	if actor is Enemy:
		return actor as Enemy
	push_error("%s expected an Enemy actor." % name)
	return null

func delta_time() -> float:
	return get_physics_process_delta_time()
