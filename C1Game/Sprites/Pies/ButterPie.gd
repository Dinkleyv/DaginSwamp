extends Area2D

onready var level = get_parent().get_parent()


# Called when the node enters the scene tree for the first time.
func _ready():
	#connect("body_entered", self, "_on_body_entered")
	pass # Replace with function body.




func _on_ButterPie_body_entered(body):
	if body.name == "Dag":
		collect()
		#get_node("/root/MainHud").pie += 1
		queue_free()#deletes the node
	pass # Replace with function body.


func collect():
	visible = false
	set_deferred("monitoring", false)

	level.on_pie_collected()
