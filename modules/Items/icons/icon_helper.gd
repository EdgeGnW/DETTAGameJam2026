extends SubViewport

@onready var models: Node3D = %Models

func _ready() -> void:
	for file in DirAccess.get_files_at("res://modules/Items/models"):
		var file_extension = file.rsplit(".", false, 1)[1]
		if file_extension == "import": continue
		var file_name = file.split(".", false, 1)[0]
		var file_path = "res://modules/Items/models/" + file
		var model = load(file_path)
		var instance = model.instantiate()
		models.add_child(instance)
		instance.hide()
		instance.name = file_name
	_generate_icon()

func _generate_icon():
	for child in %Models.get_children():
		await RenderingServer.frame_pre_draw
		child.show()
		await RenderingServer.frame_post_draw
		var img = get_texture().get_image()
		img.resize(64, 64, Image.INTERPOLATE_BILINEAR)
		img.save_png("res://modules/Items/icons/textures/" + child.name +".png")
		child.hide()
