class_name Enemy extends BaseCharacter
## AI-controlled hazard that patrols, idles, and chases the player on sight.
##
## Movement and decisions are driven by the child FSM ([FSMachine2D]); this node
## wires up its components and exposes the shared state the FSM states read
## ([member dir], [member player_in_sight], [member player]).

@export var hitbox: Hitbox
@export var walk: WalkComponent

@export_category("Field of View")
@export var fov: FoV
@export var num_segments: int
@export var sight_distance: float
@export var sight_angle: float

var player_in_sight: bool
var original_color: Color = Color(1, 0.270588, 0, 1)
var player: CharacterBody2D

func _ready() -> void:
	super._ready()
	assert(walk, "Enemy: walk component not set")
	fov.init(num_segments, sight_angle, sight_distance)
	fov.sighted.connect(_on_sighted)
	fov.lost.connect(_on_lost)
	hitbox.init()
	dir = movement_stats.starting_dir

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	fov.update(dir)

func _on_sighted(body: Node2D) -> void:
	player_in_sight = true
	player = body

func _on_lost(_body: Node2D) -> void:
	player_in_sight = false
