extends Area2D

var player_in_zone = false
var opened = false

func _ready():
	$AnimatedSprite.play("Closed")






func _on_BoxSpider_body_entered(body):
	if body.name == "Dag":
		player_in_zone = true
	


func _on_BoxSpider_body_exited(body):
	if body.name == "Dag":
		player_in_zone = false
	pass # Replace with function body.


func _process(delta):
	var hud = get_node("/root/MainHud")
	
	if player_in_zone and hud.key > 0 and not opened:
		
		hud.set_key(hud.key - 1) # subtract key
		hud.set_lives(hud.lives - 5) #subtract lives 
		open_chest()
		opened = true
		
func open_chest():
	$AnimatedSprite.play("Open")
	$open.play()
