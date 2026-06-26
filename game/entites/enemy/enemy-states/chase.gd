class_name EnemyChase extends EnemyState
## CHASE STATE
##
## The enemy moves toward the sighted player and kills it on contact. When the
## player is lost (or the chase timer ends) it transitions to look-around.

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

func process_physics(delta: float) -> FSMState:
	var to_player: Vector2 = enemy.player.global_position - enemy.global_position
	var sign_dir: Vector2 = sign(to_player)
	move_stats.handle_horizontal_input(enemy, sign_dir.x, delta)
	move_stats.handle_gravity(enemy, false, delta)
	enemy.move_and_slide()
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
