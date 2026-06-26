@tool
class_name LookAroundAction
extends EnemyBTAction
## Flips the enemy in place while searching, then returns to patrol behavior.

@export var look_amount: int = 5
@export var flip_interval: float = 2.0

var _flips_left: int = 0
var _time_until_flip: float = 0.0

func before_run(actor: Node, _blackboard: Blackboard) -> void:
	var enemy: Enemy = get_enemy(actor)
	if enemy == null:
		return
	_flips_left = look_amount
	_time_until_flip = flip_interval
	enemy.walk.direction = 0.0
	_flip(enemy)
	return

func tick(actor: Node, _blackboard: Blackboard) -> int:
	var enemy: Enemy = get_enemy(actor)
	if enemy == null:
		return FAILURE
	enemy.walk.direction = 0.0
	if _flips_left <= 0:
		enemy.clear_search()
		return SUCCESS

	_time_until_flip -= delta_time()
	if _time_until_flip <= 0.0:
		_time_until_flip = flip_interval
		_flip(enemy)
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

func _flip(enemy: Enemy) -> void:
	if _flips_left <= 0:
		return
	enemy.dir = -enemy.dir
	_flips_left -= 1
	return
