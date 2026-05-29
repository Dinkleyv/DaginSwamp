extends KinematicBody2D

export var speed = 100
onready var parent = get_parent()

func _ready():
	pass # Replace with function body.

func _process(delta):
	if parent is PathFollow2D:
		parent.set_offset(parent.get_offset() + speed * delta)
	pass


