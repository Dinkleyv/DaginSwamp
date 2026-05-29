extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var screen_size = OS.get_screen_size()
	var window_size = OS.get_window_size()
	
	var center_position = (screen_size - window_size) / 2
	OS.set_window_position (center_position)
	pass # Replace with function body.
	MainHud.hide_hud()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	===========================
#		GO TO STORY1 SCENE
#==============================

func _on_Story_pressed():
	get_tree().change_scene("res://Story1.tscn")
	pass # Replace with function body.

#	===========================
#		GO TO lEVEL 1 SCENE
#==============================

func _on_Play_pressed():
	get_tree().change_scene("res://Level1.tscn")
	pass # Replace with function body.
#	===========================
#		GO TO HELP SCENE
#==============================

func _on_Help_pressed():
	get_tree().change_scene("res://HowTo1.tscn")
	pass # Replace with function body.
#	===========================
#		GO TO cREDITS SCENE
#==============================

func _on_Credits_pressed():
	get_tree().change_scene("res://Credits.tscn")
	pass # Replace with function body.


func _on_Quit_pressed():
	get_tree().quit
	
