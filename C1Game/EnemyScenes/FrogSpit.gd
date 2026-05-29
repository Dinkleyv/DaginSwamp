extends Area2D
#FrogSpitProjectile

export(int) var bulletSpeed = 900

	
func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * delta*bulletSpeed



# =========================
#	BULLET HITS DAG
#===========================


func _on_FrogSpit_body_entered(body):
	if body.name == "Dag":
		#reduce player's lives
		get_node("/root/MainHud").lives -= 1
		queue_free()
	pass # Replace with function body.
