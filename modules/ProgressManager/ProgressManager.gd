extends Node

var completedLevels: Array[String] = []

func _ready() -> void:
	#resetProgress()
	loadProgress()
	print(completedLevels)

func isLevelCompleted(level: String) -> bool:
	return completedLevels.has(level)

func completeLevel(level: String):
	print('Saving Level ', level)
	if isLevelCompleted(level):
		return
	completedLevels.append(level)

func saveProgress():
	print('save')
	var save_file = FileAccess.open("user://lightbringer.save", FileAccess.WRITE)
	save_file.store_string(JSON.stringify(completedLevels))
	save_file.close()

func loadProgress():
	if not FileAccess.file_exists("user://lightbringer.save"):
		print('not found')
		return
	
	var save_file = FileAccess.open("user://lightbringer.save", FileAccess.READ)
	completedLevels.assign(JSON.parse_string(save_file.get_as_text()))
	#print(save_file.get_as_text())
	
func resetProgress():
	completedLevels = []
	saveProgress()
