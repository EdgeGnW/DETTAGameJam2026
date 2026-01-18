extends Control

@onready var main_buttons: VBoxContainer = $CanvasLayer/MainMenu/MainButtons
@onready var setting_menu: Panel = $CanvasLayer/SettingMenu
@onready var credits: Panel = $CanvasLayer/Credits
@onready var game_title: Label = $CanvasLayer/game_title

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_buttons.visible = true
	setting_menu.visible = false
	credits.visible = false
	fade_in(game_title, 1.5)
	fade_in(main_buttons, 1.5)

func fade_in(node: Node, duration: float) -> void:
	node.modulate.a = 0
	var tween = get_tree().create_tween()
	tween.tween_property(node, "modulate:a", 1, duration) 
	tween.play()
	await tween.finished
	tween.kill()

func _on_settings_pressed() -> void:
	main_buttons.visible = false
	setting_menu.visible = true

func _on_end_pressed() -> void:
	get_tree().quit()


func _on_back_pressed() -> void:
	main_buttons.visible = true
	setting_menu.visible = false
	credits.visible = false
	game_title.visible = true
	main_buttons.get_parent().visible = true


func _on_credits_pressed() -> void:
	main_buttons.visible = false
	main_buttons.get_parent().visible = false
	credits.visible = true
	game_title.visible = false
