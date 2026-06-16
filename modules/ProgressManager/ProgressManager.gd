extends Node

var completedLevels: Array[String] = []

func _ready() -> void:
	#resetProgress()
	loadProgress()
	#print(completedLevels)

func isLevelCompleted(level: PackedScene) -> bool:
	return completedLevels.has(getSceneName(level))

func completeLevel(level: PackedScene):
	if isLevelCompleted(level):
		return false
	completedLevels.append(getSceneName(level))
	saveProgress()
	return true

func saveProgress():
	var save_file = FileAccess.open("user://lightbringer.save", FileAccess.WRITE)
	save_file.store_string(JSON.stringify(completedLevels))
	save_file.close()

func loadProgress():
	if not FileAccess.file_exists("user://lightbringer.save"):
		print('not found')
		return
	
	print('loaded progress')
	var save_file = FileAccess.open("user://lightbringer.save", FileAccess.READ)
	completedLevels.assign(JSON.parse_string(save_file.get_as_text()))
	print(save_file.get_as_text())

func checkProgress():
	var triggers: Array[LevelEnterTrigger]
	var nodes = get_tree().get_nodes_in_group("LevelEnterTriggers")
	print (len(nodes))
	triggers.assign(nodes)
	for trigger in triggers:
		if not isLevelCompleted(trigger.sceneToLoad):
			print('not all sublevels completed')
			return
	if completeLevel(SceneManager.current_scene):
		Menu._on_level_complete_pressed()
	print('all sublevels completed')

func resetProgress():
	completedLevels = []
	saveProgress()

func getSceneName(scene: PackedScene) -> String:
	if scene == null:
		return "InvalidLevel"
	return scene.resource_path.split('/')[-1]
