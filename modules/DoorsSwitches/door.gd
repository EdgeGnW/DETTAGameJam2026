extends StaticBody2D

@export var door_index: int
@export var switch_threshold: int
@export var stay_once_opened := true
@export var invert := false

const DOOR_OPEN = preload("uid://1jyumedpehhl")

var open := false

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var switches: Array[Switch]

func _ready():
	$Open.hide()
	var switches_ = get_tree().get_nodes_in_group("switches")
	
	for switch in switches_:
		if switch.door_index == door_index:
			self.switches.append(switch)
			
	for switch in self.switches:
		switch.updated.connect(check_switches)
		
	if invert:
		collision_shape_2d.set_deferred("disabled", true)
		open = true
		$Closed.hide()
		$Open.show()
	$Label.text = "0/" + str(switch_threshold)
		
func check_switches():
	var sum = 0
	for switch in switches:
		sum += int(switch.pressed)
	$Label.text = str(sum) + "/" + str(switch_threshold)
	#print(sum, switch_threshold, open, sum >= switch_threshold)
	if sum >= switch_threshold:
		if invert:
			if open:
				collision_shape_2d.set_deferred("disabled", false)
				open = false
				AudioManager.play_sound(DOOR_OPEN)
				$Closed.show()
				$Open.hide()
				if stay_once_opened:
					for switch in self.switches:
						switch.press_permanently()
		else:
			if not open:
				collision_shape_2d.set_deferred("disabled", true)
				open = true
				AudioManager.play_sound(DOOR_OPEN)
				$Closed.hide()
				$Open.show()
				if stay_once_opened:
					for switch in self.switches:
						switch.press_permanently()
	elif not stay_once_opened:
		if invert:
			collision_shape_2d.set_deferred("disabled", true)
			open = true
			$Closed.hide()
			AudioManager.play_sound(DOOR_OPEN)
			$Open.show()
		else:
			collision_shape_2d.set_deferred("disabled", false)
			open = false
			$Closed.show()
			AudioManager.play_sound(DOOR_OPEN)
			$Open.hide()
		
	
