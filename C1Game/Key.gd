extends Area2D

signal key_collected

var key_Taken = false

func _on_Key_body_entered(body):
	if body.name == "Dag":
		key_Taken = true
		
		emit_signal("key_collected")
		get_node("/root/MainHud").key += 1
		queue_free()#deletes the node
	

