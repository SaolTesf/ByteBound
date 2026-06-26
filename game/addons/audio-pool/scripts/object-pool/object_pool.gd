@abstract
class_name IAudioPool
extends RefCounted
## Contract for a pool of audio players for one [enum AudioPoolStream.DIMENSION].
##
## A pool reuses [AudioStreamPlayer]-family nodes: it hands one out to play a
## stream and reclaims it when the sound finishes (or is stopped).

## Plays [param stream] (optionally at [param at]) on a pooled player; returns it.
@abstract func play(stream: AudioPoolStream, at: Variant) -> Node

## Stops [param player] and returns it to the pool.
@abstract func stop(player: Node) -> void

## Stops and frees every player in the pool.
@abstract func clear() -> void
