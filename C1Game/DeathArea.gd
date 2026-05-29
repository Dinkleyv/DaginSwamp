extends Area2D

var is_damaged = false

func _ready():
	pass # Replace with function body.





func _on_DeathArea_body_entered(body):
	if body.name == "Player":
		is_damaged = true
		get_node("/root/MainHud").lives -= 5
	pass # Replace with function body.


func _on_DeathArea_body_exited(body):
	if body.name == "Player":
		is_damaged = false
	pass # Replace with function body.
