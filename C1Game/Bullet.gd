extends Area2D

export(int) var bulletSpeed = 300

func _ready():
	set_as_toplevel(true)
	
	
func _physics_process(delta):
#	if is_outside_view_bounds():
#		queue_free()
	move_local_x(delta*bulletSpeed)
	
#outside bounds calculations
func is_outside_view_bounds():
	return position.x>OS.get_screen_size().x or position.x<0.0\
		or position.y>OS.get_screen_size().y or position.y<0.0


func _on_Bullet_body_entered(body):
	if body.name == "Dag":
		return    
	queue_free()
	pass # Replace with function body.
