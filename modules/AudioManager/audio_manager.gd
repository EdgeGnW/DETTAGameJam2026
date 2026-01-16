extends Node

var music_player := AudioStreamPlayer.new()
var ambience_player := AudioStreamPlayer.new()

@onready var sound_players: Array[AudioStreamPlayer] = [
	AudioStreamPlayer.new(),
	AudioStreamPlayer.new(),
	AudioStreamPlayer.new(),
	AudioStreamPlayer.new(),
	AudioStreamPlayer.new(),
	AudioStreamPlayer.new(),
	AudioStreamPlayer.new(),
]

var sound_index: int = 0

#func _physics_process(delta: float) -> void:
#	play_sound(load("res://assets/sound/sfx/default_text_voice.wav"), 1)

func _ready() -> void:
	
	add_child(music_player)
	music_player.bus = "Music"
	
	add_child(ambience_player)
	ambience_player.bus = "Ambience"
	
	for player in sound_players:
		add_child(player)
		player.bus = "SoundEffects"

func play_music(music: AudioStream):
	music_player.stream = music
	music_player.play()
	
func play_sound(sound: AudioStream, pitch_scale := 1.0):
	var player = sound_players[sound_index]
	player.stream = sound
	player.pitch_scale = pitch_scale 
	player.play()
	sound_index = (sound_index + 1) % len(sound_players)
