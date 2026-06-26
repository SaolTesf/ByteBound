extends State

@export var patrol : State
@export var idle : State
@export var chase : State

var idle_timer: Timer
## allows the enemy to change state when the timer ends
var in_idle: bool

func enter():
	super()
	in_idle = true
	Debug.debug(self, "Enemy entered idle state")
	parent.fov.modulate = parent.original_color
	parent.dir = -parent.dir
	parent.velocity = Vector2.ZERO
	setup_timer()
	idle_timer.start()

	
func process_frame(_delta : float) -> State:
	if not in_idle:
		# if the enemy is allowed to move and the idle is over
		if move_stats.can_move:
			#parent.dir = -parent.dir
			return patrol
		# if the enemy can only idle and the current idle is over.
		if not move_stats.can_move and move_stats.can_idle:
			return idle
	if parent.player_in_sight: # anytime the player is seen chase them
		return chase
	return null


func process_physics(delta : float):
	move_stats.handle_gravity(parent, false, delta)
	parent.move_and_slide()
	return null

	
func exit():
	super()


func setup_timer():
	idle_timer = Timer.new()
	idle_timer.wait_time = move_stats.idle_time
	idle_timer.one_shot = true
	idle_timer.timeout.connect(_on_timer_timeout)
	add_child(idle_timer)
		

func _on_timer_timeout():
	in_idle = false # when the timer ends allow the enemy to change states
	

	
