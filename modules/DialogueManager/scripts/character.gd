extends Resource
class_name Character 

@export var name: StringName
@export var picture: Texture2D
@export var voice: AudioStream
	
func _init(n: String = "", p: Texture2D = null, v: AudioStream = null) ->void:
	name = n
	picture = p
	voice = v
