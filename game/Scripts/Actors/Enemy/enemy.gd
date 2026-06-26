class_name Enemy extends CharacterBody2D

@export var state_machine: StateMachine
@export var sprite: AnimatedSprite2D
@export var movement_stats: MoveStats
@export var hitbox: Hitbox

@export_category("Field of View")
@export var fov: FoV
@export var num_segments: int
@export var sight_distance: float
@export var sight_angle: float

var dir: int
var player_in_sight: bool
var original_color: Color = Color(1, 0.270588, 0, 1)
var player: CharacterBody2D


func _ready() -> void:
	state_machine.init(self, sprite, movement_stats)
	fov.init(self, num_segments, sight_angle, sight_distance)
	hitbox.init(self)
	dir = movement_stats.starting_dir

	
func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	sprite.flip_h = dir < 0
	fov.update(dir)

	
func _process(delta: float) -> void:
	state_machine.process_frame(delta)


func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)
