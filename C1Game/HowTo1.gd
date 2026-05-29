extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	MainHud.hide_hud()
	var screen_size = OS.get_screen_size()
	var window_size = OS.get_window_size()
	
	var center_position = (screen_size - window_size) / 2
	OS.set_window_position (center_position)
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_BckMenu_pressed():
	get_tree().change_scene("res://MainMenu.tscn")
	pass
	
func _on_BtnNext_pressed():
	get_tree().change_scene("res://HowTo2.tscn")
	pass
