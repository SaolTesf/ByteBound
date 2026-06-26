pass
# class_name Enemy extends CharacterBody2D

# @export_category("Components")
# @export_subgroup("Internal")
# @export var animations: AnimationComponent
# @export var gravity: GravityComponent
# @export var movement: MoveStats
# @export var fov: Area2D
# @export var fov_collision: CollisionPolygon2D
# @export var fov_display: Polygon2D
# @export_subgroup("External")
# @export var player: Player

# @export_category("Timers")
# @export_subgroup("Length")
# @export var idle_duration: float = 2.0
# @export var move_duration: float = 2.0

# @export_category("Sight")
# @export var num_segments: int = 10
# @export var sight_distance: float = 100.0
# @export var sight_angle: float = 45.0

# @export_category("Actions")
# @export var starting_direction: int = 1
# @export var can_move: bool
# @export var can_idle: bool

# var ray_params: PhysicsRayQueryParameters2D
# var player_in_range: bool
# var player_in_sight: bool

# var move_timer: Timer
# var idle_timer: Timer
# var is_idle: bool
# var direction: float

# # Built-Ins -----------------------------------------------------------------
# func _ready() -> void:
# 	direction = starting_direction
# 	setup_idle_timer()
# 	setup_move_timer()
# 	if can_move or (can_idle and can_move):
# 		move_timer.start()
# 	elif can_idle and not can_move:
# 		idle_timer.start()
	
# 	fov.body_entered.connect(_on_field_of_view_body_entered)
# 	fov.body_exited.connect(_on_field_of_view_body_exited)
	

# func _physics_process(delta: float) -> void:
# 	# Run fov and sight check
# 	sight_check()
# 	update_fov()
# 	# Things that always need to be handled
# 	gravity.handle_gravity(self, false, delta)
# 	animations.handle_move_animation(direction)
	
# 	if (can_move and can_idle) or can_move:
# 		if is_idle and can_idle:
# 			return
# 		else:
# 			movement.handle_horizontal_input(self, direction, delta)
	
# 	move_and_slide()
	
# # Line of Sight -------------------------------------------------------------------
# ## Used to update the position of the fov collision and polygon
# ## As the player moves creates and PackedVector2DArray of points in an arc
# ## The curve always starts with the enemies origin
# func update_fov() -> void:
# 	var points: Array[Vector2] = [Vector2.ZERO] # start with the enemy origin
# 	var half_angle = deg_to_rad(sight_angle) / 2.0
	
# 	# draw and arc with the given angle and distance and number of segments
# 	for i in range(num_segments + 1):
# 		var angle = -half_angle + (i / float(num_segments)) * (2 * half_angle)
# 		var p = Vector2(sight_distance * cos(angle), sight_distance * sin(angle))
# 		p.x *= direction # flip the x value if the direction is negative
# 		points.append(p)

# 	# update the position of the fov collision and polygon
# 	if fov_collision:
# 		fov_collision.polygon = PackedVector2Array(points)
# 	if fov_display:
# 		fov_display.polygon = PackedVector2Array(points)

# ## If the player is in range of the enemy, cast a ray to check if the player is in sighta
# ## only set player_in_sight to true if the player is in range and the ray can collide with the player
# func sight_check() -> void:
# 	if player_in_range:
# 		ray_params = create_ray_params(position, player.position)
# 		var space_state = get_world_2d().direct_space_state
# 		var sight = space_state.intersect_ray(ray_params)

# 		if sight:
# 			if sight.collider.is_in_group("Player"):
# 				print("Player is in sight")
# 				player_in_sight = true
# 				player.is_detected = true
# 			else:
# 				print("Player is not in sight")
# 				player_in_sight = false
# 				player.is_detected = false

# ## Create a PhysicsRayQueryParameters2D object to cast a ray from the origin to the target
# ## Pass this into intersect_ray() to get the first object it hits
# func create_ray_params(origin: Vector2, target: Vector2) -> PhysicsRayQueryParameters2D:
# 	var params = PhysicsRayQueryParameters2D.new()
# 	params.from = origin
# 	params.to = target
# 	params.exclude = [self]
# 	return params

# # Timers -------------------------------------------------------------------
# func setup_move_timer() -> void:
# 	move_timer = Timer.new()
# 	move_timer.one_shot = true
# 	move_timer.wait_time = move_duration
# 	move_timer.timeout.connect(_on_move_timeout)
# 	add_child(move_timer)

# func setup_idle_timer() -> void:
# 	idle_timer = Timer.new()
# 	idle_timer.one_shot = true
# 	idle_timer.wait_time = idle_duration
# 	idle_timer.timeout.connect(_on_idle_timeout)
# 	add_child(idle_timer)

# ## This signial should only be called if move is enabled
# ## if both move and idle are enabled, then go to idle when called
# ## if only move is eabled then flip directions and restart the timer
# func _on_move_timeout() -> void:
# 	#print("Move Timer Ended")
# 	if can_idle and can_move:
# 		#print("move and idle are enabled")
# 		is_idle = true
# 		idle_timer.start()
# 	elif can_move and not can_idle:
# 		direction = -direction
# 		move_timer.start()
	
# ## This function should only ever go off if idle is enabled.
# ## If both move and idle are enabled, Start moving when this is called
# ## if only idle is enabled restart the timer
# ## regardless of options the direction will switch if this signal is called
# func _on_idle_timeout() -> void:
# 	#print("Idle Timer Ended")
# 	direction = -direction
# 	# if only idle is enabled
# 	if not can_move and can_idle:
# 		#print("only idle is enabled restart the timer")
# 		idle_timer.start() # restart the timer
# 	# if both move and idle are enabled
# 	if can_idle and can_move:
# 		#print("idle and move enabled start moving again")
# 		is_idle = false # we want to move
# 		move_timer.start() # we just finished idleing start moving
	
# # Signals -------------------------------------------------------------------
# ## Handles what happens when another body exits the enemy's field of view
# func _on_field_of_view_body_exited(body: Node2D) -> void:
# 	if body == player:
# 		player_in_range = false
# 		print("Player left the range of enemy")

# ## Handles what happens when another body enters the enemy's field of view
# func _on_field_of_view_body_entered(body: Node2D) -> void:
# 	if body == player:
# 		player_in_range = true
# 		print("Player is in range of enemy")
