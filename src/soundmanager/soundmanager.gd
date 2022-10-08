extends Node
class_name SoundManager

var sounds := {}

func _ready() -> void:
	sounds = get_available_audio_players()

func get_available_audio_players() -> Dictionary:
	var audio_players = {}
	for audio_player in get_children():
		if audio_player is AudioStreamPlayer:
			audio_players[audio_player.name] = audio_player
	
	return audio_players

func play(sound_name: String) -> void:
	var audio_player = sounds[sound_name]
	audio_player.play()
