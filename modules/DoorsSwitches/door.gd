extends StaticBody2D

@export var door_index: int
@export var switch_threshold: int
@export var stay_once_opened := true

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
		
func check_switches():
	var sum = 0
	for switch in switches:
		sum += int(switch.pressed)
	if sum >= switch_threshold:
		if not open:
			collision_shape_2d.set_deferred("disabled", true)
			open = true
			$Closed.hide()
			$Open.show()
			if stay_once_opened:
				for switch in self.switches:
					switch.press_permanently()
	elif open and not stay_once_opened:
		collision_shape_2d.set_deferred("disabled", false)
		open = false
		$Closed.show()
		$Open.hide()
		
	
