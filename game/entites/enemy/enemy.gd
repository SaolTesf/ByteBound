class_name Enemy extends CharacterBody2D
## AI-controlled hazard that patrols, idles, and chases the player on sight.
##
## Movement and decisions are driven by the child FSM ([FSMachine2D]); this node
## wires up its components and exposes the shared state the FSM states read
## ([member dir], [member player_in_sight], [member player]).

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
	fov.init(self, num_segments, sight_angle, sight_distance)
	hitbox.init(self)
	dir = movement_stats.starting_dir

func _physics_process(_delta: float) -> void:
	sprite.flip_h = dir < 0
	fov.update(dir)
