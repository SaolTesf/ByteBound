class_name FoV extends Area2D
## A vision cone that reports when a target enters or leaves it.
##
## Casts rays each frame to build a collision/display polygon that bends around
## obstacles. Communicates purely through [signal sighted] / [signal lost] — it
## never reads or writes its owner. Increase [member num_of_segments] for a
## smoother cone.

## Emitted when the player enters the vision cone. Carries the sighted body.
signal sighted(body: Node2D)
## Emitted when the player leaves the vision cone.
signal lost(body: Node2D)

const ENEMY_DETECT: AudioPoolStream = preload("res://Assets/Audio/pool-streams/enemyDetect.tres")

@export var fov_collision: CollisionPolygon2D
@export var fov_display: Polygon2D

# Points that make up the cone polygon.
var points: Array[Vector2] = [Vector2.ZERO]
var num_of_segments: int
var sight_angle: float
var sight_distance: float

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

## Configures the cone. Call from the owner's [method Node._ready].
func init(segments: int, angle: float, distance: float) -> void:
	num_of_segments = segments
	sight_angle = angle
	sight_distance = distance

## Recomputes and redraws the cone for the given facing [param direction].
## Call from the owner's [method Node._physics_process].
func update(direction: float) -> void:
	points.clear()
	calc_ray_points(direction)
	cast_rays()
	draw_fov()
	queue_redraw()

#region Raycasting
## Builds a ray query from [param origin] to [param target] using the cone's mask.
func create_ray_params(origin: Vector2, target: Vector2) -> PhysicsRayQueryParameters2D:
	var params = PhysicsRayQueryParameters2D.new()
	params.from = origin
	params.to = target
	params.collision_mask = collision_mask
	params.exclude = [self]
	params.collide_with_bodies = true
	params.collide_with_areas = false
	return params

## Fills [member points] with the cone's outline for the given facing direction.
func calc_ray_points(direction: float = 0) -> void:
	var half_angle = deg_to_rad(sight_angle) / 2.0
	var angle_step = (2.0 * half_angle) / float(num_of_segments)
	var facing = Vector2(direction, 0)
	for i in range(num_of_segments + 1):
		var angle = - half_angle + (angle_step * i)
		var d = facing.rotated(angle)
		points.append(d * sight_distance)

## Casts a ray to each point; on a hit, clamps the point to the contact position.
func cast_rays() -> void:
	var space_state = get_world_2d().direct_space_state
	for i in range(points.size()):
		var global_target = to_global(points[i])
		var params = create_ray_params(self.global_position, global_target)
		var result = space_state.intersect_ray(params)
		if result:
			points[i] = to_local(result.position)

## Applies [member points] to the collision and display polygons.
func draw_fov() -> void:
	var final_points = PackedVector2Array()
	final_points.append(Vector2.ZERO)
	for i in range(1, points.size()):
		final_points.append(points[i])
	if fov_collision:
		fov_collision.polygon = final_points
	if fov_display:
		fov_display.polygon = final_points
#endregion

#region Signal handlers
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		AudioPool.play(ENEMY_DETECT, global_position)
		sighted.emit(body)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		lost.emit(body)
#endregion
