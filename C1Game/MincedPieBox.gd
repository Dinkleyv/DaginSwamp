extends Area2D

var player_in_zone = false
var opened = false
onready var box = $AnimatedSprite

func _ready():
	box.play("Closed")



func _process(delta):
	var hud = get_node("/root/MainHud")
	
	if player_in_zone and hud.key > 0 and not opened:
		hud.set_key(hud.key - 1) # subtract key
		hud.pie += 1             # reward
		open_chest()
		opened = true

func open_chest():
	box.play("Open")
	$open.play()

func _on_MincedPieBox_body_entered(body):
	if body.name == "Dag":
		player_in_zone = true


func _on_MincedPieBox_body_exited(body):
	if body.name == "Dag":
		player_in_zone = false
