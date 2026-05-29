extends Area2D


#declare member variables here. Example:
export(String, FILE, "*.tscn") var world_scene
export (int) var pies_required = 6
onready var portal = $AnimatedSprite
onready var collision = $CollisionShape2D
var is_open = false






#called when the node enters the scene tree for 
func _ready():
	portal.visible = false
	collision.disabled = true
	if not portal.is_connected("animation_finished", self, "_on_AnimatedSprite_animation_finished"):
		portal.connect("animation_finished", self, "_on_AnimatedSprite_animation_finished")
	#called every frame "delta to the elapsed 
func _process(delta):
	var bodies = get_overlapping_bodies()
	
	if not is_open:
		var pies_collected = get_node("/root/MainHud").pie
		if pies_collected >= pies_required:
			open_portal()
			
	
	
	for body in bodies:
		if body.name == "Dag":
			get_tree().change_scene(world_scene)
	pass


func open_portal():
	is_open = true
	portal.visible = true
	collision.disabled = false
	portal.play("Appear")
	
	



func _on_AnimatedSprite_animation_finished():
	if portal.animation =="Appear":
		$portalSFX.play()
		portal.play("Idle")
	
