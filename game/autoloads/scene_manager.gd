extends Node
## Scene transition service and active campaign tracker.

var current_scene: Node
var current_scene_resource: PackedScene
var current_level_index: int = -1
var current_level: Resource

var _campaign_levels: Array[Resource] = []
var _completion_scene: PackedScene

#region Engine Methods
func _ready() -> void:
	current_scene = get_tree().current_scene
	if current_scene == null and get_tree().root.get_child_count() > 0:
		current_scene = get_tree().root.get_child(-1)
	return
#endregion

#region Public API
func change_to(scene: PackedScene) -> void:
	if scene == null:
		push_error("SceneManager: scene not set.")
		return

	reset_pause()
	current_scene_resource = scene
	_deferred_change_to.call_deferred(scene)
	return

func start_campaign(levels: Array, completion_scene: PackedScene, start_index: int = 0) -> void:
	if levels.is_empty():
		push_error("SceneManager: campaign levels are empty.")
		return

	_campaign_levels.clear()
	for item in levels:
		var level: Resource = item as Resource
		if level == null:
			continue
		_campaign_levels.append(level)
	_completion_scene = completion_scene
	go_to_level(start_index)
	return

func go_to_level(index: int) -> void:
	if not _has_level(index):
		push_error("SceneManager: level index %d is out of range." % index)
		return

	var level: Resource = _campaign_levels[index]
	var level_scene: PackedScene = _get_level_scene(level)
	if level_scene == null:
		push_error("SceneManager: level %d has no scene." % index)
		return

	current_level_index = index
	current_level = level
	change_to(level_scene)
	return

func next() -> void:
	if _campaign_levels.is_empty():
		push_error("SceneManager: no active campaign.")
		return

	var next_index: int = current_level_index + 1
	if next_index >= _campaign_levels.size():
		_complete_campaign()
		return

	go_to_level(next_index)
	return

func reload() -> void:
	if not _has_level(current_level_index):
		push_error("SceneManager: no active level to reload.")
		return

	var level: Resource = _campaign_levels[current_level_index]
	var level_scene: PackedScene = _get_level_scene(level)
	if level_scene == null:
		push_error("SceneManager: current level has no scene.")
		return

	change_to(level_scene)
	return

func reset_pause() -> void:
	if get_tree().paused:
		get_tree().paused = false
	return
#endregion

#region Private Helpers
func _deferred_change_to(scene: PackedScene) -> void:
	var error: Error = get_tree().change_scene_to_packed(scene)
	if error != OK:
		push_error("SceneManager: failed to change scene with error %d." % error)
		return

	current_scene = get_tree().current_scene
	return

func _complete_campaign() -> void:
	if _completion_scene == null:
		push_error("SceneManager: campaign completion scene not set.")
		return

	current_level_index = _campaign_levels.size()
	current_level = null
	change_to(_completion_scene)
	return

func _has_level(index: int) -> bool:
	return index >= 0 and index < _campaign_levels.size()

func _get_level_scene(level: Resource) -> PackedScene:
	if level == null:
		return null
	return level.get("scene") as PackedScene
#endregion
