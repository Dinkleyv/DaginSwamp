extends Node



func _on_Redo_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
	
	


func _on_Home_pressed():
	get_tree().change_scene("res://MainMenu.tscn")
	
