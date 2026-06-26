class_name AudioPoolStream
extends Resource
## Data-driven sound definition.
##
## Holds everything needed to play one sound through [AudioPool]: the stream, bus,
## volume/pitch, whether it loops, and whether it is global (D0) or positional
## (D2 / D3).

## How a sound is placed in the world.
enum DIMENSION {
	D0, # Global / non-positional (UI, music)
	D2, # 2D positional
	D3, # 3D positional
}

## Identifies the stream (for debugging / inspection).
@export var stream_name: StringName = &""

## The audio bus to play on (must exist in the project's bus layout).
@export var audio_bus: String = "Master"

## True if the sound finishes on its own; false for a looping sound the caller
## stops via [method AudioPool.stop].
@export var one_shot: bool = true

## Global vs 2D/3D positional.
@export var dimension: DIMENSION = DIMENSION.D0

## The actual stream that gets played.
@export var stream: AudioStream

## Playback volume, 0 (silent) .. 100 (full).
@export_range(0, 100, 1) var volume: int = 50

## Pitch multiplier.
@export_range(0.1, 4.0, 0.05) var pitch_scale: float = 1.0

## Effects to apply. (Effects are bus-level in Godot; applying them per-stream is a
## deferred feature — see [method apply_effects].)
@export var audio_effects: Array[AudioPoolEffect] = []

## The configured [member volume] as decibels for an [AudioStreamPlayer].
func volume_db() -> float:
	return linear_to_db(volume / 100.0)

## Deferred: per-stream effects need dedicated buses. Kept as a hook.
func apply_effects() -> void:
	pass
