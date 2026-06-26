extends Node
## Pooled audio player for global / 2D / 3D sounds.
##
## Routes [method play] by the stream's [enum AudioPoolStream.DIMENSION] to the
## matching pool; reuses [AudioStreamPlayer]-family nodes instead of churning them.

var _global: GlobalAudioPool = GlobalAudioPool.new()
var _2d: Audio2DPool = Audio2DPool.new()
var _3d: Audio3DPool = Audio3DPool.new()
var _owner: Dictionary[Node, IAudioPool] = {}
var _unique_players: Dictionary[StringName, Node] = {}
var _unique_keys: Dictionary[Node, StringName] = {}

func _ready() -> void:
	_init_pool(_global, "Global")
	_init_pool(_2d, "Local2D")
	_init_pool(_3d, "Local3D")
	return

func _exit_tree() -> void:
	_global.clear()
	_2d.clear()
	_3d.clear()
	_owner.clear()
	_unique_players.clear()
	_unique_keys.clear()
	return

func _init_pool(pool: BaseAudioPool, container_name: String) -> void:
	var container: Node = Node.new()
	container.name = container_name
	add_child(container)
	pool.init(container)
	return

## Plays [param stream]. [param at] is a [Vector2] for D2, [Vector3] for D3, and
## ignored for D0. Returns the player — keep it as a handle to [method stop] a
## looping sound.
func play(stream: AudioPoolStream, at: Variant = Vector2.ZERO) -> Node:
	return _play(stream, at, false)

## Plays [param stream] only if another stream with the same
## [member AudioPoolStream.stream_name] is not already active.
func play_unique(stream: AudioPoolStream, at: Variant = Vector2.ZERO) -> Node:
	if stream == null:
		push_warning("AudioPool: cannot play a null stream")
		return null

	var key: StringName = stream.stream_name
	if key != &"" and _unique_players.has(key):
		var current_player: Node = _unique_players[key]
		if is_instance_valid(current_player):
			return current_player
		_unique_players.erase(key)
		return _play(stream, at, true)
	return _play(stream, at, key != &"")

func _play(stream: AudioPoolStream, at: Variant, unique: bool) -> Node:
	if stream == null:
		push_warning("AudioPool: cannot play a null stream")
		return null

	var pool: IAudioPool = _pool_for(stream.dimension)
	if pool == null:
		push_warning("AudioPool: invalid dimension on '%s'" % stream.stream_name)
		return null
	var player: Node = pool.play(stream, at)
	if player:
		_owner[player] = pool
		if unique:
			_unique_players[stream.stream_name] = player
			_unique_keys[player] = stream.stream_name
	return player

## Stops a player returned by [method play] and returns it to its pool.
func stop(player: Node) -> void:
	if player and _owner.has(player):
		_clear_unique(player)
		_owner[player].stop(player)
		_owner.erase(player)
	return

func _clear_unique(player: Node) -> void:
	if not _unique_keys.has(player):
		return
	var key: StringName = _unique_keys[player]
	_unique_keys.erase(player)
	if _unique_players.get(key) == player:
		_unique_players.erase(key)
	return

func _pool_for(dimension: AudioPoolStream.DIMENSION) -> IAudioPool:
	match dimension:
		AudioPoolStream.DIMENSION.D0:
			return _global
		AudioPoolStream.DIMENSION.D2:
			return _2d
		AudioPoolStream.DIMENSION.D3:
			return _3d
	return null
