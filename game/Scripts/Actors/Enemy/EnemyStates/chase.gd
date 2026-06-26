extends State

@export var idle: State
@export var look_around: State

var chase_timer: Timer
var in_chase: bool
var look_amount: int = 5
var look_around_time: float = 3.0

var fov_color: Color = Color(1, 0, 0, 0.6)

func enter():
	super()
	in_chase = true
	Debug.debug(self, "Entered the chase State")
	setup_timer()
	parent.fov.modulate = fov_color
	chase_timer.start()


func exit():
	super()
	Debug.debug(self, "Exiting the chase state")
	parent.player_in_sight = false

	
func process_physics(delta: float) -> State:
	var dir = parent.player.global_position - parent.global_position
	var sign_dir = sign(dir)
	move_stats.handle_horizontal_input(parent, sign_dir.x, delta)
	move_stats.handle_gravity(parent, false, delta)
	parent.move_and_slide()
	for i in range(parent.get_slide_collision_count()):
		var col = parent.get_slide_collision(i).get_collider()
		if col is Player:
			col.handleDeath()
	return null


func process_frame(_delta: float) -> State:
	if not parent.player_in_sight or not in_chase:
		return look_around
	return null


func setup_timer():
	chase_timer = Timer.new()
	chase_timer.one_shot = true
	chase_timer.wait_time = move_stats.idle_time
	chase_timer.timeout.connect(_on_timer_timeout)
	add_child(chase_timer)


func _on_timer_timeout():
	in_chase = false



	
