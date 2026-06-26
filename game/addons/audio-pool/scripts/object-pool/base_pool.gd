@abstract
class_name BaseAudioPool
extends IAudioPool
## Shared pooling for [IAudioPool].
##
## Reuses player nodes between sounds: a player is configured from an
## [AudioPoolStream], played, and reclaimed when it finishes (one-shots) or is
## stopped (looping). Concrete pools supply the player type ([method _create_player])
## and how to position it ([method _apply_position]).

## Max players the pool will create before dropping requests.
const MAX_NODES: int = 512

var _container: Node          # the node the players live under in the tree
var _free: Array[Node] = []   # idle players ready to reuse
var _active: Array[Node] = [] # players currently playing

## Wires the pool to the [param container] node its players are parented under.
func init(container: Node) -> void:
	_container = container

func play(stream: AudioPoolStream, at: Variant = null) -> Node:
	var player := _acquire()
	if player == null:
		push_warning("AudioPool at capacity (%d); dropped '%s'" % [MAX_NODES, stream.stream_name])
		return null
	player.stream = stream.stream
	player.bus = stream.audio_bus
	player.volume_db = stream.volume_db()
	player.pitch_scale = stream.pitch_scale
	_apply_position(player, at)
	_active.append(player)
	player.play()
	return player

func stop(player: Node) -> void:
	if player == null or not _active.has(player):
		return
	player.stop()
	_release(player)

func clear() -> void:
	for p in _active + _free:
		p.queue_free()
	_active.clear()
	_free.clear()

func _acquire() -> Node:
	if not _free.is_empty():
		return _free.pop_back()
	if _active.size() + _free.size() >= MAX_NODES:
		return null
	var player := _create_player()
	player.finished.connect(_on_finished.bind(player))  # one-shots reclaim themselves
	_container.add_child(player)
	return player

func _release(player: Node) -> void:
	if not _active.has(player):
		return
	_active.erase(player)
	_free.append(player)

func _on_finished(player: Node) -> void:
	_release(player)

@abstract func _create_player() -> Node
@abstract func _apply_position(player: Node, at: Variant) -> void
