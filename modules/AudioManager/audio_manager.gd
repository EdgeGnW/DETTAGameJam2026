extends Node

var music_player := AudioStreamPlayer.new()
var ambience_player := AudioStreamPlayer.new()

#const DAYTIME_FARM_AMBIENCE_409990 = preload("uid://bqrhyx8mnncpu")

@onready var sound_players: Array[AudioStreamPlayer] = [
	AudioStreamPlayer.new(),
	AudioStreamPlayer.new(),
	AudioStreamPlayer.new(),
	AudioStreamPlayer.new(),
	AudioStreamPlayer.new(),
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
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	add_child(music_player)
	music_player.bus = "Music"
	
	add_child(ambience_player)
	ambience_player.bus = "Ambience"
	
	for player in sound_players:
		add_child(player)
		player.bus = "SoundEffects"
		
	#play_ambience(DAYTIME_FARM_AMBIENCE_409990)

func play_music(music: AudioStream):
	music_player.stream = music
	music_player.play()
	
func play_ambience(ambience: AudioStream):
	ambience_player.stream = ambience
	ambience_player.play()
	
func play_sound(sound: AudioStream, pitch_scale := 1.0, cutoff := 0.0):
	var player = sound_players[sound_index]
	player.stream = sound
	player.pitch_scale = pitch_scale 
	player.play()
	sound_index = (sound_index + 1) % len(sound_players)
	if cutoff:
		await get_tree().create_timer(cutoff).timeout
		player.stop()
	
func play_random_sound(soundarr: Array):
	var player = sound_players[sound_index]
	player.stream = soundarr[randi() % len(soundarr)]
	player.play()
	sound_index = (sound_index + 1) % len(sound_players)
	
func set_volume(bus_name, percentage: float):
	var index = AudioServer.get_bus_index(bus_name)
	var db_value = linear_to_db(percentage / 100)
	AudioServer.set_bus_volume_db(index, db_value)
