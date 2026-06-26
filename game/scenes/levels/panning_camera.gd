extends Camera2D

var init_activated: bool = false
@onready var player_cam = $"../Characters/Player".camera

func _ready() -> void:
	SignalHub.pedestal_activated.connect(_on_pedestal_activated)

func _on_pedestal_activated(channel: Channel.Type) -> void:
	if channel != Channel.Type.BLUE:
		return
	if not init_activated:
		init_activated = true
		make_current()
		await get_tree().create_timer(1.5).timeout
		player_cam.make_current()
		
	