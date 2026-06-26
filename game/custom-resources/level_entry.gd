class_name LevelEntry extends Resource
## A playable level in the campaign sequence.

enum Category {
	TUTORIAL,
	REGULAR,
}

@export var title: String
@export var category: Category = Category.REGULAR
@export var scene: PackedScene
