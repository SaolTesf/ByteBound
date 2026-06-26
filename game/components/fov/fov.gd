extends Area2D
class_name FoV
## calculates and draws the fov of the character
##
## Uses RayCast2D to gather points in space to draw the fov collision polygon with.
## Increase the num_of_segments to make the polygon smoother on surfaces


@export var fov_collision: CollisionPolygon2D
@export var fov_display: Polygon2D
var parent: Node2D
#var detect: AudioStreamPlayer2D

# used to create the fov
var points: Array[Vector2] = [Vector2.ZERO] # hold points that make up the polygon
var num_of_segments: int
var sight_angle: float
var sight_distance: float


func _ready() -> void:
	body_entered.connect(_on_fov_entered)
	body_exited.connect(_on_fov_exited)

	
## Sets up the fov variables. these variables should be passed in from the parent
func init(body : Node2D, segments : int, angle : float, distance : float) -> void:
	self.parent = body
	self.num_of_segments = segments
	self.sight_angle = angle
	self.sight_distance = distance

	
# Handle RayCasting --------------------------------------------------------------------------------------------
## Create a PhysicsRayQueryParameters2D object to cast a ray from the origin to the target
## Pass this into intersect_ray() to get the first object it hits
func create_ray_params(origin: Vector2, target: Vector2) -> PhysicsRayQueryParameters2D:
	var params = PhysicsRayQueryParameters2D.new()
	params.from = origin
	params.to = target
	params.collision_mask = collision_mask
	params.exclude = [self]
	params.collide_with_bodies = true
	params.collide_with_areas = false
	return params


## Updates the points Array with the points to use in the polygon
func calcRayPoint(direction : float = 0) -> void:
	var half_angle = deg_to_rad(sight_angle) / 2.0
	var angle_step = (2.0 * half_angle) / float(num_of_segments)

	var facing = Vector2(direction, 0)
	# Start from -half_angle and go to +half_angle
	for i in range(num_of_segments + 1):
		var angle = - half_angle + (angle_step * i)
		
		# Rotate the ray by the entity's facing direction plus the current angle
		var d = facing.rotated(angle)
		
		# Calculate the endpoint
		var endpoint = d * sight_distance
		points.append(endpoint)
	

## Takes the points array and cast a ray starting at the body ending on each point in the array
## Checks in the ray hits an object. If it does make the point of contact the new point in the polygon
func castRays() -> void:
	var space_state = get_world_2d().direct_space_state
	for i in range(points.size()):
		var global_target = to_global(points[i])
		var params = create_ray_params(self.global_position, global_target)
		var result = space_state.intersect_ray(params)
		if result:
			points[i] = to_local(result.position)

			
func drawFOV() -> void:
	# Create a properly formed polygon with the origin at the center
	var final_points = PackedVector2Array()
	final_points.append(Vector2.ZERO) # Start with the origin
	
	# Add all other points in order
	for i in range(1, points.size()):
		final_points.append(points[i])
	
	if fov_collision:
		fov_collision.polygon = final_points
	if fov_display:
		fov_display.polygon = final_points

		
# Used to draw gizmos to debug the arrays
# func _draw() -> void:
# 	# Draw rays
# 	for point in points:
# 		draw_line(Vector2.ZERO, point, Color(1, 0, 0), 2.0)
	
# 	# Draw the FOV polygon outline (optional)
# 	if points.size() > 1:
# 		draw_polyline(points, Color(0, 1, 0), 2.0, true)


func update(direction : float) -> void:
	points.clear()
	calcRayPoint(direction)
	castRays()
	drawFOV()
	queue_redraw() # Redraw the gizmos


#Signals -------------------------------------------------------------------------------------------------
func _on_fov_entered(body: Node2D) -> void:
	if body.name == "Player":
		# play detection sound and start chase on the parent enemy
		AudioController.play_sound("EnemyDetect")
		parent.player_in_sight = true # use this to change state in the state machine.
		parent.player = body
		Debug.debug(self, "%s"%parent.player)
		#Debug.debug(self, "player is in sight range: %s"%parent.player_in_sight)


func _on_fov_exited(body: Node2D) -> void:
	if body.name == "Player":
		parent.player_in_sight = false
		#Debug.debug(self, "player is in sight range: %s"%parent.player_in_sight)
