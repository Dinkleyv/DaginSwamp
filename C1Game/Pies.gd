extends Node2D

var pies_left =0
onready var level = get_parent()

func _ready():
	pies_left = get_child_count()
	print("coins in scene:", pies_left)
	
	print("Pies", pies_left)
	
func pie_collected():
	pies_left -= 1
	print("pies left:", pies_left)
	
	level.reduce_time_after_pie(pies_left)




