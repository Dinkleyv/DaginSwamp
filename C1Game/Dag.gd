extends KinematicBody2D

# export as a property for testing on the editor
#export var SPEED = 200
var sounds = {}
var bullet = preload("res://Bullet.tscn")
var on_ladder := false 
var is_climbing = false
var was_on_floor = false
var is_alive =true 

const UP = Vector2(0, -1)
const SPEED = 200
const GRAVITY = 20
const JUMP_HEIGHT = -600
const CLIMB_SPEED = 150
var motion = Vector2() # moving in 2d space
var shoot 

func _ready():
	sounds["Jump"] = $jump
	#sounds["fire"] = $fire_sound
	#sounds["hit"] = $hit_sound	

func _physics_process(delta):
	#print(on_ladder)
	is_climbing = should_climb_ladder()
	
	#ladder mvoement
	if is_climbing:
		motion.x =0 # 0000000
		motion.y =0
		set_collision_mask_bit(6, false)
	
		#motion= Vector2.ZERO #stop normal motion  2222
		
		if Input.is_action_pressed("up_ladder"):
			$climb_ladder.play()
			motion.y = -CLIMB_SPEED
		elif Input.is_action_pressed("down_ladder"):
			$climb_ladder.play()
			motion.y = CLIMB_SPEED

		else:
			motion.y=0
		
		
		if motion.y !=0:
			$Sprite.play("Climb")
			
		else:
			$Sprite.stop()
	else:
		set_collision_mask_bit(6, true)	
	
		#Noraml movement
		motion.y += GRAVITY
		
		if Input.is_action_pressed("ui_right"):
			$Sprite.flip_h = false #flip sprite to face direction
			$Sprite.play("Run")
			$Walk.play()
			motion.x = SPEED
		elif Input.is_action_pressed("ui_left"):
			$Sprite.flip_h =true
			$Sprite.play("Run")
			$Walk.play()
			motion.x = -SPEED
		else:
			motion.x = 0
			$Sprite.play("Idle")
		
	
		
		if is_on_floor():
			
			if Input.is_action_just_pressed("ui_up"):
				
				motion.y = JUMP_HEIGHT
				
			
			if Input.is_action_just_pressed("ui_fire"):
				shoot()
					
			if Input.is_action_pressed("ui_fire"):
						$Sprite.play("Fire")
						$Fire.play()
						
						
			else:
				if !$Sprite.is_playing():
					$Sprite.play("Idle")				
		else:
			if motion.y < 0:
				$Sprite.play("Jump")
				play_sfx("Jump")
				
			else:
				$Sprite.play("Fall")
				
	
	if is_climbing:
	
		#motion = move_and_slide(motion, Vector2.ZERO)
		motion = move_and_slide(motion, Vector2(0, 0), false, 4, 0.785398, false)
	else:
		# use move_and_slide to create movement on screen
		motion = move_and_slide(motion, UP)
	
	
	#
	
	pass
func should_climb_ladder() -> bool:
	return on_ladder and (
		Input.is_action_pressed("up_ladder") or 
		Input.is_action_pressed("down_ladder")
	)
		
func shoot():
	if $Sprite.flip_h == false:
		fire($ShootPosRight.global_position,$ShootPosRight.global_rotation)
	else:
		fire($ShootPosLeft.global_position, $ShootPosLeft.global_rotation)
		

func fire(bulletPos,bulletRot):
	var new_bullet= bullet.instance()
	add_child(new_bullet)
	new_bullet.global_position=bulletPos
	new_bullet.global_rotation=bulletRot


func _on_LadderChecker_body_entered(body):
	if body is TileMap:
		on_ladder = true
	pass # Replace with function body.


func _on_LadderChecker_body_exited(body):
	if body is TileMap:
		on_ladder = false
	pass # Replace with function body.

func play_sfx(name: String):
	var player = sounds.get(name)
	if player and !player.playing:
		print("Playing sound:", name)
		player.play()
