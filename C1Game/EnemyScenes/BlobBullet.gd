extends Area2D

export(int) var bulletSpeed = 900

	
func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * delta*bulletSpeed






# =========================
#	BULLET HITS DAG
#===========================
func _on_BlobBullet_body_entered(body):
	if body.name == "Dag":
		get_node("/root/MainHud").lives -= 10
		queue_free()
