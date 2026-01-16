extends CanvasLayer

@onready var player: Player3D = %Player
@onready var inventory_dialog: InventoryDialog = %InventoryDialog

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		inventory_dialog.open(player.inventory)
