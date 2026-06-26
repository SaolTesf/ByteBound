class_name SoundSettings
extends Resource
## Saved audio preferences and bus application helpers.

const SAVE_PATH: String = "user://audio_settings.cfg"
const SECTION: String = "audio"
const SFX_KEY: String = "sfx_volume"
const MUSIC_KEY: String = "music_volume"
const SFX_BUS: StringName = &"SFX"
const MUSIC_BUS: StringName = &"Music"
const MIN_VOLUME: float = 0.0
const MAX_VOLUME: float = 1.0
const SILENT_DB: float = -80.0

@export_range(0.0, 1.0, 0.001)
var sfx_volume: float = MAX_VOLUME
@export_range(0.0, 1.0, 0.001)
var music_volume: float = MAX_VOLUME

## Loads saved settings, or returns defaults when no preference file exists.
static func load_settings(path: String = SAVE_PATH) -> SoundSettings:
	var settings: SoundSettings = SoundSettings.new()
	var config: ConfigFile = ConfigFile.new()
	var err: int = config.load(path)
	if err == ERR_FILE_NOT_FOUND:
		return settings
	if err != OK:
		push_warning("SoundSettings: could not load %s (error %d)" % [path, err])
		return settings

	settings.sfx_volume = settings._read_volume(config, SFX_KEY)
	settings.music_volume = settings._read_volume(config, MUSIC_KEY)
	return settings

## Saves settings to [param path].
func save_settings(path: String = SAVE_PATH) -> int:
	var config: ConfigFile = ConfigFile.new()
	config.set_value(SECTION, SFX_KEY, sfx_volume)
	config.set_value(SECTION, MUSIC_KEY, music_volume)
	return config.save(path)

## Applies all saved volumes to their audio buses.
func apply() -> void:
	apply_bus(SFX_BUS)
	apply_bus(MUSIC_BUS)
	return

## Applies the saved value for [param bus].
func apply_bus(bus: StringName) -> void:
	_apply_bus(bus, volume_for_bus(bus))
	return

## Returns the saved linear volume for [param bus].
func volume_for_bus(bus: StringName) -> float:
	if bus == SFX_BUS:
		return sfx_volume
	if bus == MUSIC_BUS:
		return music_volume
	push_warning("SoundSettings: unknown audio bus '%s'" % String(bus))
	return MAX_VOLUME

## Sets the saved linear volume for [param bus].
func set_volume_for_bus(bus: StringName, value: float) -> void:
	var clamped_value: float = clampf(value, MIN_VOLUME, MAX_VOLUME)
	if bus == SFX_BUS:
		sfx_volume = clamped_value
		return
	if bus == MUSIC_BUS:
		music_volume = clamped_value
		return
	push_warning("SoundSettings: unknown audio bus '%s'" % String(bus))
	return

func _read_volume(config: ConfigFile, key: String) -> float:
	var value: float = float(config.get_value(SECTION, key, MAX_VOLUME))
	return clampf(value, MIN_VOLUME, MAX_VOLUME)

func _apply_bus(bus: StringName, volume: float) -> void:
	var bus_index: int = AudioServer.get_bus_index(String(bus))
	if bus_index == -1:
		push_warning("SoundSettings: audio bus '%s' does not exist" % String(bus))
		return

	AudioServer.set_bus_mute(bus_index, volume <= MIN_VOLUME)
	if volume <= MIN_VOLUME:
		AudioServer.set_bus_volume_db(bus_index, SILENT_DB)
		return
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(volume))
	return
