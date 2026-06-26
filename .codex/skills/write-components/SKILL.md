---
name: write-componennts
description: use when writing game components with gdscript.
---

# general rule


# What is a comonent

A small independent decoupled node that when attached to a parent node can provide it with additional functionallity.
functionallity can be something like health, mana, movement, skills, inventory...etc.

- communicates through signals
- dont hold references to the node its provided functionallity to
- take in all dependencies as arguments in the API calls
- Owner calls down to component not the other way
- do not overbuild. 
- if a component expects a custom resource it needs to be accepted in an 'init' function
- the stats must be asserted to be true. 
- avoid building useless fallbacks if a resource is expected throw an error if its not set
- Small API's
- Single Concern

```gdscript
class_name HealthComponent
extends Node

signal health_changed(new_health: int)
signal health_full(health: int)
signal health_depleated()

@export var max_health: int
var health: int

func _ready() -> void:
	health = max_health

func damage(amount: int) -> int:
	health = clamp(0, max_health, health - amount)
	if health <= 0:
		health_depleated.emit()
	health_changed.emit(health)

func heal() -> void:
	# character should be dead.
	if health <= 0:
		health_depleated.emit()
		return
	
	# get new health
	health = clamp(0, max_health, health + amount)

	# check if health is full
	if health == max_health:
		health_full.emit(health)
	
	health_changed.emit(health)

```


