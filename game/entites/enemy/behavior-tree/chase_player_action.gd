@tool
class_name ChasePlayerAction
extends EnemyBTAction
## Chases the sighted player for a limited window, then requests a search.

const FOV_COLOR: Color = Color(1, 0, 0, 0.6)

var _time_left: float = 0.0

func before_run(actor: Node, _blackboard: Blackboard) -> void:
	var enemy: Enemy = get_enemy(actor)
	if enemy == null:
		return
	_time_left = enemy.movement_stats.idle_time
	enemy.should_search = false
	enemy.fov.modulate = FOV_COLOR
	return

func tick(actor: Node, _blackboard: Blackboard) -> int:
	var enemy: Enemy = get_enemy(actor)
	if enemy == null:
		return FAILURE
	if not enemy.can_see_player():
		enemy.request_search()
		return FAILURE

	_time_left -= delta_time()
	if _time_left <= 0.0:
		enemy.player_in_sight = false
		enemy.request_search()
		return FAILURE

	_chase_player(enemy)
	_kill_colliding_players(enemy)
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

func _chase_player(enemy: Enemy) -> void:
	var to_player: Vector2 = enemy.player.global_position - enemy.global_position
	var direction: float = signf(to_player.x)
	enemy.walk.direction = direction
	if direction != 0.0:
		enemy.dir = int(direction)
	return

func _kill_colliding_players(enemy: Enemy) -> void:
	for i in range(enemy.get_slide_collision_count()):
		var col: KinematicCollision2D = enemy.get_slide_collision(i)
		if col == null:
			continue
		_try_kill_player(col.get_collider())

	if enemy.hitbox:
		for body in enemy.hitbox.get_overlapping_bodies():
			_try_kill_player(body)
	return

func _try_kill_player(body: Object) -> bool:
	if not body is Node:
		return false
	var node: Node = body as Node
	if not node.is_in_group("Player") or not node.has_method("handleDeath"):
		return false
	node.call("handleDeath")
	return true
