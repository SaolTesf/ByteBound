extends Node
## Pooled audio player for global / 2D / 3D sounds.
##
## Routes [method play] by the stream's [enum AudioPoolStream.DIMENSION] to the
## matching pool; reuses [AudioStreamPlayer]-family nodes instead of churning them.

var _global := GlobalAudioPool.new()
var _2d := Audio2DPool.new()
var _3d := Audio3DPool.new()
var _owner: Dictionary[Node, IAudioPool] = {}

func _ready() -> void:
	_init_pool(_global, "Global")
	_init_pool(_2d, "Local2D")
	_init_pool(_3d, "Local3D")

func _init_pool(pool: BaseAudioPool, container_name: String) -> void:
	var container := Node.new()
	container.name = container_name
	add_child(container)
	pool.init(container)

## Plays [param stream]. [param at] is a [Vector2] for D2, [Vector3] for D3, and
## ignored for D0. Returns the player — keep it as a handle to [method stop] a
## looping sound.
func play(stream: AudioPoolStream, at: Variant = Vector2.ZERO) -> Node:
	var pool := _pool_for(stream.dimension)
	if pool == null:
		push_warning("AudioPool: invalid dimension on '%s'" % stream.stream_name)
		return null
	var player := pool.play(stream, at)
	if player:
		_owner[player] = pool
	return player

## Stops a player returned by [method play] and returns it to its pool.
func stop(player: Node) -> void:
	if player and _owner.has(player):
		_owner[player].stop(player)

func _pool_for(dimension: AudioPoolStream.DIMENSION) -> IAudioPool:
	match dimension:
		AudioPoolStream.DIMENSION.D0:
			return _global
		AudioPoolStream.DIMENSION.D2:
			return _2d
		AudioPoolStream.DIMENSION.D3:
			return _3d
	return null
