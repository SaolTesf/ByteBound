class_name EnemyState extends FSMState2D
## Base for the enemy's FSM states.
##
## The machine injects the controlled node as [member FSMState2D.body] — here the
## [Enemy]. This base exposes the enemy plus its [MoveStats] and sprite so
## concrete states stay focused on AI and transition logic.

## Animation played on [method enter] (if set). Assigned per state in the scene.
@export var animation_name: String

## The controlled enemy, typed.
var enemy: Enemy:
	get: return body as Enemy

## The enemy's movement stats resource.
var move_stats: MoveStats:
	get: return enemy.movement_stats

## The enemy's animated sprite.
var sprite: AnimatedSprite2D:
	get: return enemy.sprite

## Plays this state's animation (when one is assigned) on entry.
func enter() -> void:
	if animation_name and sprite:
		sprite.play(animation_name)
