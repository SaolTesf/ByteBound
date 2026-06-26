extends GutTest

const LEVEL_ENTRY_SCRIPT: Script = preload("res://custom-resources/level_entry.gd")
const CATALOG: Resource = preload("res://custom-resources/sceneCatalog.tres")
const SCENE_MANAGER_PATH: String = "res://autoloads/scene_manager.gd"

var _levels: Array[Resource] = []
var _completion_scene: PackedScene

func before_each() -> void:
	_levels = [
		_make_level("Level One", _make_scene("LevelOne")),
		_make_level("Level Two", _make_scene("LevelTwo")),
	]
	_completion_scene = _make_scene("Complete")
	return

func test_start_campaign_loads_first_level() -> void:
	SceneManager.start_campaign(_levels, _completion_scene)
	await _flush_scene_change()

	assert_eq(SceneManager.current_level_index, 0)
	assert_eq(SceneManager.current_level, _levels[0])
	assert_eq(SceneManager.current_scene_resource, _levels[0].get("scene"))
	assert_eq(get_tree().current_scene.name, "LevelOne")
	return

func test_go_to_level_loads_selected_level() -> void:
	SceneManager.start_campaign(_levels, _completion_scene)
	await _flush_scene_change()
	SceneManager.go_to_level(1)
	await _flush_scene_change()

	assert_eq(SceneManager.current_level_index, 1)
	assert_eq(SceneManager.current_level, _levels[1])
	assert_eq(get_tree().current_scene.name, "LevelTwo")
	return

func test_catalog_separates_tutorial_and_regular_level_indices() -> void:
	assert_eq(CATALOG.call("get_level_indices", 0), [0, 1, 2, 3, 4])
	assert_eq(CATALOG.call("get_level_indices", 1), [5, 6, 7, 8, 9])
	return

func test_next_advances_through_active_campaign() -> void:
	SceneManager.start_campaign(_levels, _completion_scene)
	await _flush_scene_change()
	SceneManager.next()
	await _flush_scene_change()

	assert_eq(SceneManager.current_level_index, 1)
	assert_eq(SceneManager.current_level, _levels[1])
	assert_eq(get_tree().current_scene.name, "LevelTwo")
	return

func test_next_from_final_level_loads_completion_scene() -> void:
	SceneManager.start_campaign(_levels, _completion_scene, 1)
	await _flush_scene_change()
	SceneManager.next()
	await _flush_scene_change()

	assert_eq(SceneManager.current_level_index, _levels.size())
	assert_null(SceneManager.current_level)
	assert_eq(SceneManager.current_scene_resource, _completion_scene)
	assert_eq(get_tree().current_scene.name, "Complete")
	return

func test_reload_loads_current_level_again() -> void:
	SceneManager.start_campaign(_levels, _completion_scene, 1)
	await _flush_scene_change()
	SceneManager.reload()
	await _flush_scene_change()

	assert_eq(SceneManager.current_level_index, 1)
	assert_eq(SceneManager.current_scene_resource, _levels[1].get("scene"))
	assert_eq(get_tree().current_scene.name, "LevelTwo")
	return

func test_scene_manager_has_no_direct_scene_or_ui_paths() -> void:
	var file: FileAccess = FileAccess.open(SCENE_MANAGER_PATH, FileAccess.READ)
	assert_not_null(file)
	var source: String = file.get_as_text()

	assert_eq(source.find("res://scenes/"), -1)
	assert_eq(source.find("res://ui/"), -1)
	return

func _make_level(title: String, scene: PackedScene) -> Resource:
	var level: Resource = LEVEL_ENTRY_SCRIPT.new()
	level.set("title", title)
	level.set("scene", scene)
	return level

func _make_scene(scene_name: String) -> PackedScene:
	var root: Node = Node.new()
	root.name = scene_name
	var scene: PackedScene = PackedScene.new()
	var result: Error = scene.pack(root)
	root.free()
	assert_eq(result, OK)
	return scene

func _flush_scene_change() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	return
