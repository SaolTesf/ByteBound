extends Node
## Runtime access to saved audio preferences.

signal volume_changed(bus: StringName, value: float)

var _settings: SoundSettings

func _ready() -> void:
	_settings = SoundSettings.load_settings()
	_settings.apply()
	return

## Returns the saved linear volume for [param bus].
func get_volume(bus: StringName) -> float:
	_ensure_settings()
	return _settings.volume_for_bus(bus)

## Updates, applies, and saves the linear volume for [param bus].
func set_volume(bus: StringName, value: float) -> void:
	_ensure_settings()
	_settings.set_volume_for_bus(bus, value)
	_settings.apply_bus(bus)

	var err: int = _settings.save_settings()
	if err != OK:
		push_warning("AudioSettings: could not save audio settings (error %d)" % err)

	volume_changed.emit(bus, _settings.volume_for_bus(bus))
	return

## Saves the current preferences.
func save() -> void:
	_ensure_settings()
	var err: int = _settings.save_settings()
	if err != OK:
		push_warning("AudioSettings: could not save audio settings (error %d)" % err)
	return

func _ensure_settings() -> void:
	if _settings != null:
		return
	_settings = SoundSettings.load_settings()
	_settings.apply()
	return
