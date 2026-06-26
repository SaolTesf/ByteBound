class_name Enemy extends BaseCharacter
## AI-controlled hazard that patrols, idles, and chases the player on sight.
##
## Movement and decisions are driven by the child [BeehaveTree]. This node wires
## its components and exposes shared sensory state for behavior leaves.

@export var hitbox: Hitbox
@export var walk: WalkComponent
@export var jump: JumpComponent

@export_category("Field of View")
@export var fov: FoV
@export var num_segments: int
@export var sight_distance: float
@export var sight_angle: float

var player_in_sight: bool
var should_search: bool
var home_position: Vector2
var original_color: Color = Color(1, 0.270588, 0, 1)
var player: CharacterBody2D

func _ready() -> void:
	super._ready()
	home_position = global_position
	assert(walk, "Enemy: walk component not set")
	assert(jump, "Enemy: jump component not set")
	assert(fov, "Enemy: FoV component not set")
	assert(hitbox, "Enemy: hitbox component not set")
	fov.init(num_segments, sight_angle, sight_distance)
	fov.sighted.connect(_on_sighted)
	fov.lost.connect(_on_lost)
	hitbox.init()
	dir = movement_stats.starting_dir
	return

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	fov.update(dir)
	return

func can_see_player() -> bool:
	return player_in_sight and is_instance_valid(player)

func is_home_reached(distance: float) -> bool:
	return global_position.distance_to(home_position) <= distance

func request_search() -> void:
	should_search = true
	return

func clear_search() -> void:
	should_search = false
	return

func _on_sighted(body: Node2D) -> void:
	player_in_sight = true
	player = body as CharacterBody2D
	should_search = false
	return

func _on_lost(body: Node2D) -> void:
	if body != player:
		return
	player_in_sight = false
	request_search()
	return
