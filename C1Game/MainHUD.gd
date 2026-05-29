extends Node2D

var pie =0 setget set_pie
var key =0 setget set_key
var total = 0 setget set_total
signal game_over
onready var lives = 300 setget set_lives
onready var hearts = [
	$HUD/Heart1,
	$HUD/Heart2,
	$HUD/Heart3
]
var last_pie = 0

####LIVES FUNCTIONS
func set_lives(value):
	lives = clamp(value, 0, 300)
	for i in range(hearts.size()):
		update_heart(hearts[i], lives - (i * 100))
	if lives <=0:
		#play pop heart sound
		#get_tree().change_scene("res://GameOver.tscn")
		emit_signal("game_over")


func update_heart(heart, value):
	value = clamp(value,0, 100)
	
	heart.visible = value > 0
	if value <=0:
		return
		
	#set states
	var states = ["Full", "ThreeQuarter", "Half", "Quarter", "Low"]
	
	#Turn off all states
	for state in states:
		heart.get_node(state).visible = false
	#for child in heart.get_children():
	#	child.visible = false
	
	
	# Turn on correct state
	if value > 75:
		heart.get_node("Full").visible = true
	elif value > 50:
		heart.get_node("Full").visible = false
		heart.get_node("ThreeQuarter").visible = true
	elif value > 25:
		heart.get_node("Full").visible = false
		heart.get_node("Half").visible = true
	elif value > 10:
		heart.get_node("Full").visible = false
		heart.get_node("Quarter").visible = true
	else:
		heart.get_node("Full").visible = false
		$HUD/Low_life.play()
		heart.get_node("Low").visible = true
		
func _ready():
	
	set_lives(lives)
	#for heart in hearts:
	#	print("Heart:", heart)
	#	print("Children:", heart.get_children())
#reseting the HUD
func reset():
	lives = 300
	pass	
	
func set_pie(value):
	pie = value
	update_text()

func set_total(value):
	total = value
	update_text()
	
func update_text():
	if pie == null or total == null:
		return
	
	if pie > last_pie:
		$HUD/FoundPie.play()
	last_pie = pie
	
	$HUD/Pies.text = "PIES: %d / %d" % [pie, total]
	
	pass

func set_key(value):
	if value > key:
		$HUD/FoundKey.play()
	key=value
	$HUD/Keys.set_text(":  "+str(key) )
	
	pass


#func set_lives(value):
#	lives = value
#	$HUD/Lives.set_text("LIVES: "+ str(lives) + "%")
	
	
#	if	 lives <=  0:
#		 get_tree().change_scene("res://GameOver.tscn")
	 
#	pass
	
	#animationLivesVisual
	

	
	
	
	

	
	#HIDING THE HUD
func hide_hud():
	$HUD.visible = false
	pass

func show_hud():
	$HUD.visible = true


func _on_Button_pressed():
	get_tree().change_scene("res://MainMenu.tscn")
	
