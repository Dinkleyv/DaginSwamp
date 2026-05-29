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
	MainHud.hide_hud()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _on_BckMenu_pressed():
	get_tree().change_scene("res://MainMenu.tscn")
	pass # Replace with function body.


func _on_Next_pressed():
	get_tree().change_scene("res://Story2.tscn")
	pass # Replace with function body.
