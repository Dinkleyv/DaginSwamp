extends Area2D

onready var sprite = $AnimatedSprite
var current_state = ""
#get_node("/root/MainHud").lives -= 15
func update_lives_visual(value):
	var new_state = ""
	if get_node("/root/MainHud").lives >= 75:
		sprite.play("Full")
	elif get_node("/root/MainHud").lives >= 50:
		sprite.play("ThreeQuarter")
	elif get_node("/root/MainHud").lives >= 25:
		sprite.play("Half")
	elif get_node("/root/MainHud").lives > 0:
		sprite.play("Quarter")
	else:
		sprite.play("Low")

	if new_state != current_state:
		current_state = new_state
		sprite.play(current_state)


