class_name EnemyChase extends EnemyState
## CHASE STATE — moves toward the sighted player and kills it on contact.

@export var idle: FSMState
@export var look_around: FSMState

var chase_timer: Timer
var in_chase: bool
var fov_color: Color = Color(1, 0, 0, 0.6)

func enter() -> void:
	super()
	in_chase = true
	setup_timer()
	enemy.fov.modulate = fov_color
	chase_timer.start()

func exit() -> void:
	enemy.player_in_sight = false

func process_physics(_delta: float) -> FSMState:
	var to_player: Vector2 = enemy.player.global_position - enemy.global_position
	walk.direction = signf(to_player.x)
	for i in range(enemy.get_slide_collision_count()):
		var col: Object = enemy.get_slide_collision(i).get_collider()
		if col is Player:
			col.handleDeath()
	return null

func process_frame(_delta: float) -> FSMState:
	if not enemy.player_in_sight or not in_chase:
		return look_around
	return null

func setup_timer() -> void:
	chase_timer = Timer.new()
	chase_timer.one_shot = true
	chase_timer.wait_time = move_stats.idle_time
	chase_timer.timeout.connect(_on_timer_timeout)
	add_child(chase_timer)

func _on_timer_timeout() -> void:
	in_chase = false
