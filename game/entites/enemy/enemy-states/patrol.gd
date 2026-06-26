extends State

@export var idle: State
@export var patrol: State
@export var chase: State

var patrol_timer: Timer
var in_patrol: bool

func enter():
	super()
	Debug.debug(self, "Enemy entered the Patrol State")
	parent.fov.modulate = parent.original_color
	in_patrol = true
	setup_timer()
	patrol_timer.start()
	
	
func process_physics(delta: float) -> State:
	move_stats.handle_horizontal_input(parent, parent.dir, delta)
	move_stats.handle_gravity(parent, false, delta)
	parent.move_and_slide()
	return null

	
func process_frame(_delta : float) -> State:
	if not in_patrol:
		if move_stats.can_move and not move_stats.can_idle:
			parent.dir = -parent.dir
			return patrol
		if move_stats.can_idle:
			return idle
	if parent.player_in_sight: # if the player is seen chase them.
		return chase
	return null


func exit():
	super()


func setup_timer():
	patrol_timer = Timer.new()
	patrol_timer.wait_time = move_stats.move_time
	patrol_timer.one_shot = true
	patrol_timer.timeout.connect(_on_timer_timeout)
	add_child(patrol_timer)


func _on_timer_timeout():
	#Debug.debug(self, "patrol_timer timed out")
	in_patrol = false
