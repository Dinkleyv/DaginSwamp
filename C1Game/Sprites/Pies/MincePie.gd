extends Area2D
onready var level = get_parent().get_parent()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_MincePie_body_entered(body):
	if body.name == "Dag":
		collect()
		#get_node("/root/MainHud").pie += 1
		queue_free()#deletes the node
	pass # Replace with function body.


func collect():
	visible = false
	set_deferred("monitoring", false)

	level.on_pie_collected()
