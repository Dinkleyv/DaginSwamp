extends Node2D


var player_inside = false


# Called when the node enters the scene tree for the first time.
func _ready():
	#connect the game_over signal to the show_game function
	get_node("/root/MainHud").connect("game_over", self, "show_game_over")
	$GameStart.play()
	$GameOver/CanvasLayer.visible = false
	var screen_size = OS.get_screen_size()
	var window_size = OS.get_window_size()
	
	var center_position = (screen_size - window_size) / 2
	OS.set_window_position (center_position)
	MainHud.show_hud()
	
# =========================
#	1. Get the number of pie instances  from the pie node.
#	2. send the number to the HUD as the total pies in the scene
#===========================
	var total_pies = $Pies.get_child_count()
	get_node("/root/MainHud").set_total(total_pies)
	


 # =========================
#	SHOW GAME OVER SCENE
#===========================
func show_game_over():
	$GameOver/CanvasLayer.visible = true
	#get_tree().paused = true

# =========================
# PLAYER ENTERS WATER- DEAD AREA
#===========================
func _on_DeadArea_body_entered(body):
		if(body.name == "Dag"):
			#show_game_over() #testing game over
			get_node("/root/MainHud").set_pie(0)
			get_node("/root/MainHud").set_key(0)
			$WaterSplash.play()
			#yield($WaterSplash, "finished")
			get_tree().reload_current_scene()
			
	
