extends CanvasLayer

@export var message_timer : Timer
@export var text : Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = true
	assert(message_timer, "TutorialText: message_timer not set")
	message_timer.timeout.connect(_on_timeout)

func _on_timeout():
	print(message_timer)
	visible = false
