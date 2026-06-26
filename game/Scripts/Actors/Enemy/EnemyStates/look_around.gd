extends State

@export var idle_state: State
@export var look_amount: int = 5
@export var flip_interval: float = 2.0
@export var chase_state: State

var flips_left: int
var look_timer: Timer

func enter():
	super()
	Debug.debug(self, "Enemy entered the look_around state")
	flips_left = look_amount
	look_timer = Timer.new()
	look_timer.one_shot = false
	look_timer.wait_time = flip_interval
	look_timer.autostart = true
	look_timer.timeout.connect(_on_LookTimer_timeout)
	add_child(look_timer)
	_on_LookTimer_timeout()

func _on_LookTimer_timeout():
	parent.dir = -parent.dir
	flips_left -= 1

func process_frame(_delta: float) -> State:
	if parent.player_in_sight:
		return chase_state
	if flips_left <= 0:
		look_timer.stop()
		return idle_state
	return null
