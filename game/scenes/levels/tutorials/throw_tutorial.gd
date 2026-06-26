extends CanvasLayer

@export var message_timer : Timer
@export var text : Label
@export var object1 : Throwable
@export var player : Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = true
	Validate.check_reference(self, "time", "Timer")
	Validate.check_reference(self, "text", "TextEdit")
	message_timer.timeout.connect(_on_timeout)

func _on_timeout():
	visible = false
