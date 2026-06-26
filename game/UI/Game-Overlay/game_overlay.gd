class_name GameOverlay extends CanvasLayer

@onready var current_time: Label = %CurrentTime
var elapsed_time = 0.0
var running = true

func _process(delta):
	if running:
		elapsed_time += delta
		current_time.text = format_time(elapsed_time)

func format_time(seconds: float) -> String:
	var minutes = int(seconds) / 60
	var secs = int(seconds) % 60
	var millis = int((seconds - int(seconds)) * 10)
	return "%02d:%02d.%01d" % [minutes, secs, millis]

func stop_clock():
	running = false
	print("Final time: ", format_time(elapsed_time))
