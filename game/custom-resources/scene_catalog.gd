class_name SceneCatalog extends Resource
## Editable scene references for menus and campaign progression.

@export_category("Menus")
@export var main_menu_scene: PackedScene
@export var level_select_scene: PackedScene
@export var tutorial_select_scene: PackedScene
@export var regular_select_scene: PackedScene
@export var settings_scene: PackedScene
@export var campaign_complete_scene: PackedScene

@export_category("Campaign")
@export var campaign_levels: Array[Resource] = []

func get_level_indices(category: int) -> Array[int]:
	var indices: Array[int] = []
	for i in range(campaign_levels.size()):
		var level: Resource = campaign_levels[i]
		if level == null:
			continue
		if int(level.get("category")) == category:
			indices.append(i)
	return indices
