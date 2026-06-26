class_name EnemyState extends FSMState2D
## Base for the enemy's FSM states.
##
## The machine injects the [Enemy] as [member FSMState2D.body]. States set
## movement intent on `enemy.walk`; gravity and the single move_and_slide are
## handled by the enemy's [LocomotionComponent].

## Animation played on [method enter] (if set). Assigned per state in the scene.
@export var animation_name: String

var enemy: Enemy:
	get: return body as Enemy
var move_stats: MoveStats:
	get: return enemy.movement_stats
var sprite: AnimatedSprite2D:
	get: return enemy.sprite
var walk: WalkComponent:
	get: return enemy.walk

func enter() -> void:
	if animation_name and sprite:
		sprite.play(animation_name)
