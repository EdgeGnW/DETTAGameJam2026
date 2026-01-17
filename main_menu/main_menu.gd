extends Control

@onready var main_buttons: VBoxContainer = $CanvasLayer/MainMenu/MainButtons
@onready var setting_menu: Panel = $CanvasLayer/SettingMenu


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_buttons.visible = true
	setting_menu.visible = false


func _on_settings_pressed() -> void:
	main_buttons.visible = false
	setting_menu.visible = true
	


func _on_end_pressed() -> void:
	get_tree().quit()


func _on_back_pressed() -> void:
	main_buttons.visible = true
	setting_menu.visible = false
