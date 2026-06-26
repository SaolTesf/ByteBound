extends GutTest

const ENEMY_SCENE: PackedScene = preload("res://entites/enemy/enemy.tscn")
const CHASE_PLAYER_ACTION: Script = preload("res://entites/enemy/behavior-tree/chase_player_action.gd")
const LOOK_AROUND_ACTION: Script = preload("res://entites/enemy/behavior-tree/look_around_action.gd")
const PATROL_IDLE_ACTION: Script = preload("res://entites/enemy/behavior-tree/patrol_idle_routine_action.gd")
const RETURN_HOME_ACTION: Script = preload("res://entites/enemy/behavior-tree/return_home_action.gd")
const SHOULD_RETURN_HOME_CONDITION: Script = preload(
	"res://entites/enemy/behavior-tree/should_return_home_condition.gd"
)
const RETURN_HOME_RETRY_AT_KEY: StringName = &"return_home_retry_at"

var _enemy: Enemy

class GroundedReturnHomeAction:
	extends "res://entites/enemy/behavior-tree/return_home_action.gd"

	func _is_grounded(_enemy: Enemy) -> bool:
		return true

class FakePlayer:
	extends CharacterBody2D

	var died: bool = false

	func _ready() -> void:
		add_to_group("Player")
		return

	func handleDeath() -> void:
		died = true
		return

func before_each() -> void:
	_enemy = add_child_autofree(ENEMY_SCENE.instantiate()) as Enemy
	_enemy.movement_stats = _enemy.movement_stats.duplicate(true) as MoveStats
	_enemy.walk.stats = _enemy.movement_stats
	_enemy.jump.stats = _enemy.movement_stats
	var tree = _enemy.get_node("BeehaveTree")
	tree.disable()
	return

func test_enemy_captures_spawn_position_as_home() -> void:
	assert_eq(_enemy.home_position, _enemy.global_position)
	return

func test_idle_patrol_routine_sets_movement_and_flips_direction_after_timer() -> void:
	_enemy.movement_stats.can_move = true
	_enemy.movement_stats.can_idle = false
	_enemy.movement_stats.idle_time = 0.0
	_enemy.movement_stats.move_time = 0.0
	_enemy.dir = 1

	var action = add_child_autofree(PATROL_IDLE_ACTION.new())
	var blackboard: Blackboard = add_child_autofree(Blackboard.new())
	action.before_run(_enemy, blackboard)
	action.tick(_enemy, blackboard)

	assert_eq(_enemy.walk.direction, -1.0)

	action.tick(_enemy, blackboard)

	assert_eq(_enemy.walk.direction, 1.0)
	return

func test_sighted_player_causes_chase_movement_toward_player() -> void:
	var player: CharacterBody2D = _make_player_body()
	player.global_position = _enemy.global_position + Vector2(40.0, 0.0)
	_enemy.player = player
	_enemy.player_in_sight = true

	var action = add_child_autofree(CHASE_PLAYER_ACTION.new())
	var blackboard: Blackboard = add_child_autofree(Blackboard.new())
	action.before_run(_enemy, blackboard)
	var status: int = action.tick(_enemy, blackboard)

	assert_eq(status, BeehaveNode.RUNNING)
	assert_eq(_enemy.walk.direction, 1.0)
	return

func test_lost_player_requests_search() -> void:
	var player: CharacterBody2D = _make_player_body()
	_enemy.fov.sighted.emit(player)
	_enemy.fov.lost.emit(player)

	assert_false(_enemy.player_in_sight)
	assert_true(_enemy.should_search)
	return

func test_look_around_clears_search_and_returns_success() -> void:
	_enemy.request_search()
	_enemy.dir = 1

	var action = add_child_autofree(LOOK_AROUND_ACTION.new())
	action.look_amount = 1
	action.flip_interval = 0.01
	var blackboard: Blackboard = add_child_autofree(Blackboard.new())
	action.before_run(_enemy, blackboard)
	var status: int = action.tick(_enemy, blackboard)

	assert_eq(status, BeehaveNode.SUCCESS)
	assert_false(_enemy.should_search)
	assert_eq(_enemy.dir, -1)
	return

func test_chase_player_death_path_calls_player_handle_death() -> void:
	var player: FakePlayer = add_child_autofree(FakePlayer.new())
	var action = add_child_autofree(CHASE_PLAYER_ACTION.new())

	var killed: bool = action._try_kill_player(player)

	assert_true(killed)
	assert_true(player.died)
	return

func test_should_return_home_condition_succeeds_after_search_when_away() -> void:
	_enemy.global_position = _enemy.home_position + Vector2(64.0, 0.0)
	_enemy.clear_search()

	var condition = add_child_autofree(SHOULD_RETURN_HOME_CONDITION.new())
	var blackboard: Blackboard = add_child_autofree(Blackboard.new())
	var status: int = condition.tick(_enemy, blackboard)

	assert_eq(status, BeehaveNode.SUCCESS)
	return

func test_should_return_home_condition_fails_while_searching() -> void:
	_enemy.global_position = _enemy.home_position + Vector2(64.0, 0.0)
	_enemy.request_search()

	var condition = add_child_autofree(SHOULD_RETURN_HOME_CONDITION.new())
	var blackboard: Blackboard = add_child_autofree(Blackboard.new())
	var status: int = condition.tick(_enemy, blackboard)

	assert_eq(status, BeehaveNode.FAILURE)
	return

func test_should_return_home_condition_fails_while_seeing_player() -> void:
	var player: CharacterBody2D = _make_player_body()
	_enemy.global_position = _enemy.home_position + Vector2(64.0, 0.0)
	_enemy.player = player
	_enemy.player_in_sight = true

	var condition = add_child_autofree(SHOULD_RETURN_HOME_CONDITION.new())
	var blackboard: Blackboard = add_child_autofree(Blackboard.new())
	var status: int = condition.tick(_enemy, blackboard)

	assert_eq(status, BeehaveNode.FAILURE)
	return

func test_should_return_home_condition_fails_at_home() -> void:
	_enemy.global_position = _enemy.home_position
	_enemy.clear_search()

	var condition = add_child_autofree(SHOULD_RETURN_HOME_CONDITION.new())
	var blackboard: Blackboard = add_child_autofree(Blackboard.new())
	var status: int = condition.tick(_enemy, blackboard)

	assert_eq(status, BeehaveNode.FAILURE)
	return

func test_should_return_home_condition_fails_during_retry_cooldown() -> void:
	_enemy.global_position = _enemy.home_position + Vector2(64.0, 0.0)
	_enemy.clear_search()

	var condition = add_child_autofree(SHOULD_RETURN_HOME_CONDITION.new())
	var blackboard: Blackboard = add_child_autofree(Blackboard.new())
	blackboard.set_value(RETURN_HOME_RETRY_AT_KEY, Time.get_ticks_msec() / 1000.0 + 60.0)
	var status: int = condition.tick(_enemy, blackboard)

	assert_eq(status, BeehaveNode.FAILURE)
	return

func test_return_home_action_walks_left_and_right_toward_home() -> void:
	_enemy.home_position = Vector2.ZERO
	_enemy.global_position = Vector2(64.0, 0.0)

	var action = add_child_autofree(RETURN_HOME_ACTION.new())
	var blackboard: Blackboard = add_child_autofree(Blackboard.new())
	action.before_run(_enemy, blackboard)
	var status: int = action.tick(_enemy, blackboard)

	assert_eq(status, BeehaveNode.RUNNING)
	assert_eq(_enemy.walk.direction, -1.0)
	assert_eq(_enemy.dir, -1)

	_enemy.global_position = Vector2(-64.0, 0.0)
	action.before_run(_enemy, blackboard)
	status = action.tick(_enemy, blackboard)

	assert_eq(status, BeehaveNode.RUNNING)
	assert_eq(_enemy.walk.direction, 1.0)
	assert_eq(_enemy.dir, 1)
	return

func test_return_home_action_stops_at_home_and_succeeds() -> void:
	_enemy.home_position = _enemy.global_position
	_enemy.walk.direction = 1.0

	var action = add_child_autofree(RETURN_HOME_ACTION.new())
	var blackboard: Blackboard = add_child_autofree(Blackboard.new())
	action.before_run(_enemy, blackboard)
	var status: int = action.tick(_enemy, blackboard)

	assert_eq(status, BeehaveNode.SUCCESS)
	assert_eq(_enemy.walk.direction, 0.0)
	return

func test_return_home_action_uses_jump_component_when_home_is_above() -> void:
	_enemy.global_position = Vector2.ZERO
	_enemy.home_position = Vector2(0.0, -64.0)
	_enemy.velocity.y = 0.0
	_enemy.jump.jumps_used = 0

	var action = add_child_autofree(GroundedReturnHomeAction.new())
	var blackboard: Blackboard = add_child_autofree(Blackboard.new())
	action.before_run(_enemy, blackboard)
	var status: int = action.tick(_enemy, blackboard)

	assert_eq(status, BeehaveNode.RUNNING)
	assert_eq(_enemy.walk.direction, 0.0)
	assert_eq(_enemy.velocity.y, _enemy.movement_stats.jump_height)
	return

func test_return_home_action_sets_retry_cooldown_when_stuck() -> void:
	_enemy.home_position = Vector2.ZERO
	_enemy.global_position = Vector2(64.0, 0.0)

	var action = add_child_autofree(RETURN_HOME_ACTION.new())
	action.stuck_timeout = 0.0
	var blackboard: Blackboard = add_child_autofree(Blackboard.new())
	action.before_run(_enemy, blackboard)
	var status: int = action.tick(_enemy, blackboard)

	assert_eq(status, BeehaveNode.FAILURE)
	assert_true(float(blackboard.get_value(RETURN_HOME_RETRY_AT_KEY, 0.0)) > 0.0)
	assert_eq(_enemy.walk.direction, 0.0)
	return

func test_enemy_scene_uses_single_beehave_root_without_state_machine() -> void:
	var enemy: Enemy = add_child_autofree(ENEMY_SCENE.instantiate()) as Enemy
	var tree: Node = enemy.get_node("BeehaveTree")
	tree.disable()

	assert_eq(tree.get_child_count(), 1)
	assert_not_null(tree.get_node_or_null("RootSelector"))
	assert_null(enemy.get_node_or_null("StateMachine"))
	return

func test_enemy_scene_orders_return_home_after_search_before_patrol() -> void:
	var root: Node = _enemy.get_node("BeehaveTree/RootSelector")
	var branch_names: Array[StringName] = []
	for child: Node in root.get_children():
		branch_names.append(child.name)

	assert_true(branch_names.has(&"SearchBranch"))
	assert_true(branch_names.has(&"ReturnHomeBranch"))
	assert_true(branch_names.has(&"PatrolIdleRoutine"))
	assert_true(branch_names.find(&"SearchBranch") < branch_names.find(&"ReturnHomeBranch"))
	assert_true(branch_names.find(&"ReturnHomeBranch") < branch_names.find(&"PatrolIdleRoutine"))
	return

func _make_player_body() -> CharacterBody2D:
	var player: CharacterBody2D = add_child_autofree(CharacterBody2D.new())
	player.add_to_group("Player")
	return player
