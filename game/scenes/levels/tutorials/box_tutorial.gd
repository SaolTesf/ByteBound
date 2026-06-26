extends CanvasLayer

@export var message_timer : Timer
@export var message_time : float
@export var player : Player
@export var first_box : MovableSquare
@export var second_box : MovableSquare
@export var third_box : MovableSquare
@export var text : Label


var collided_with_first : bool = false
var f_message_played : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = true
	Validate.check_reference(self, "time", "Timer")
	Validate.check_reference(self, "text", "TextEdit")
	message_timer.timeout.connect(_on_timeout)
	SignalHub.movable_box_hit.connect(_collide_boxes)

	
func _collide_boxes(box : CharacterBody2D):
	Debug.debug(self, "%s collided with player " % [box])
	if box == first_box and !collided_with_first:
		collided_with_first = true
		text.text = "When you collide with a box you will push it"
		message_timer.start()
		visible = true
	if box == second_box or box == third_box:
		text.text = "You can use block to block the vision of enemies"
		message_timer.start()
		visible = true

		
func _process(delta : float) -> void:
	if collided_with_first and first_box.is_on_wall() and !f_message_played:
		f_message_played = true
		text.text = "you can also jump on boxes to get to out of reach platforms"
		message_timer.start()
		visible = true


func _on_timeout():
	visible = false
