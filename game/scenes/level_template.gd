class_name LevelTemplate extends Node2D

const MUSIC: AudioPoolStream = preload("res://Assets/Audio/pool-streams/music.tres")

func _ready() -> void:
	get_tree().paused = false
	AudioPool.play_unique(MUSIC)
	return
