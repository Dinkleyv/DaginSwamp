extends Area2D

var player_in_zone = false
var opened = false

# ON READY: BOX REMAIN CLOSED
func _ready():
	$AnimatedSprite.play("Closed")




# =========================
#	DETECT PLAYER
#===========================

func _on_FroginBox_body_entered(body):
	if body.name == "Dag":
		player_in_zone = true
	pass # Replace with function body.


func _on_FroginBox_body_exited(body):
	if body.name == "Dag":
		player_in_zone = false
		
		

# =========================
#	FUNCTIONING PROCESS
#===========================		
func _process(delta):
	var hud = get_node("/root/MainHud")
	if player_in_zone and hud.key > 0 and not opened:#player in zone & has key & box is closed
		
		hud.set_key(hud.key - 1) # subtract key
				   
		open_chest()
		opened = true

# =========================
#	OPEN CHEST
#===========================
func open_chest():
	$AnimatedSprite.play("Open")
	$open.play()
