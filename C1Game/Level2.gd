extends Node2D

export(int) var base_time = 10 #starting time

var pies_left =0
var total_pies = 0


onready var timer = $Timer#------
onready var pies_node = $Pies
onready var spawn_container = $TileMap/SpawnPoints
onready var hud = $"/root/MainHud"


var spawn_points = []




func _ready():
	get_node("/root/MainHud").connect("game_over", self, "show_game_over")
	$GameOver/CanvasLayer.visible = false
	randomize()#randomize the pie spawning
	spawn_points.clear()
	#collect spwan points
	for sp in spawn_container.get_children():
		spawn_points.append(sp)
		
	#count the pies from the pies node
	total_pies = pies_node.get_child_count()
	pies_left = total_pies
	
	#start timer
	timer.wait_time = int(base_time * pies_left)#initial interval
	timer.start()
	
	random_spawn_all_pies()
	update_hud()
	
	var screen_size = OS.get_screen_size()
	var window_size = OS.get_window_size()
	
	var center_position = (screen_size - window_size) / 2
	OS.set_window_position (center_position)
	
	pass # Replace with function body.




func _on_Menu_pressed():
	get_tree().change_scene("res://MainMenu.tscn")
	pass # Replace with function body.

# =========================
#	BEHAVIOUR OF PIES
#===========================
func on_pie_collected():
	pies_left -= 1
	#timer wait time = base time(10) * ( number of pies)
	timer.wait_time = int(base_time * pies_left)
	if timer.wait_time < 10:
		timer.wait_time = 10
	#reduce_time_after_pie()
	if pies_left > 0:
		timer.start()
	else:
		timer.stop()
	
	update_hud()

	if pies_left <= 0: # after all pies collected change scene to Vectory Scene
		#audio winning
		#victory scene
		print("all pies collected")  # just print for now
		

		
		
# --------------------------
# SPAWNING
# --------------------------

func random_spawn_all_pies():
	for pie in pies_node.get_children():
		$SpawnPieSound.play()
		respawn_pie(pie)
		

func respawn_pie(pie):
	var spawn = spawn_points [randi() % spawn_points.size()]
	pie.global_position = spawn.global_position
	
	pie.visible = true
	pie.set_deferred("monitoring", true)


# --------------------------
# ROUND RESET
# --------------------------
func reset_round():
	
	#print("all pies colleced")
	pies_left = total_pies
	random_spawn_all_pies()
	
	timer.start()
	update_hud()
	
# --------------------------
# TIME RESTART
# --------------------------

func _on_Timer_timeout():
	warp_remaining_pies()
	#adjust the time interval
	if pies_left > 0:
		#warp_interval = base_time *current pie count
		timer.wait_time = int(base_time * pies_left)
		
		timer.wait_time = max(int(base_time * pies_left), 10)
			
		timer.start()
		
	else:
		timer.stop() #all pies collected
		
func warp_remaining_pies():
	for pie in pies_node.get_children():
		if pie.visible:
			respawn_pie(pie)
		
# --------------------------
# HUD
# --------------------------
func update_hud():
	var collected = total_pies - pies_left
	hud.set_pie(total_pies - pies_left)
	hud.set_total(total_pies)
		
func show_game_over():
	$GameOver/CanvasLayer.visible = true
	#get_tree().paused = true
# =========================
#	DEATH AREA
#===========================

func _on_DeathArea_body_entered(body):
	if(body.name == "Dag"):
		get_node("/root/MainHud").set_pie(0)
		$WaterSplash.play()
		get_tree().reload_current_scene()
