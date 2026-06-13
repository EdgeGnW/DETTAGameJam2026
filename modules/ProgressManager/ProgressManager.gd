extends Node

var completedLevels: Array[String] = ['amk']

func isLevelCompleted(level: String) -> bool:
	return completedLevels.has(level)

func completeLevel(level: String):
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
	print(save_file.get_as_text())
	
	
