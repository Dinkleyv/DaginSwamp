extends KinematicBody2D

var water_bullet = preload("res://EnemyScenes/FrogSpit.tscn")

var is_attacking = false

var velocity = Vector2.ZERO
var gravity = 900
var move_speed = 100
var direction = 1

var energy = 10
var player = null
var player_in_range = false #If player is in long range for start of shots
var player_in_melee = false #if player is in FrogArea

# ------------------------
# NODES
# ------------------------
onready var sprite = $AnimatedSprite
onready var ray_front = $RayCast2DFront
onready var ray_back = $RayCast2DBack
onready var spawn_point = $ProjectileSpawn
onready var timer = $Timer

# ------------------------
# MAIN LOOP
# ------------------------
func _physics_process(delta):
	velocity.y += gravity * delta

	if player_in_melee:
		velocity.x = 0
		
	elif player_in_range and player:
		# Stop moving when player detected
		velocity.x = 0
		
	else:
		patrol()

	velocity = move_and_slide(velocity, Vector2.UP)

# =============================
# PATROL MOVEMENT
# ==============================
func patrol():
	velocity.x = move_speed * direction
	sprite.play("Hop")
	#activate raycast to sense edges
	var active_ray = ray_front if direction == 1 else ray_back
	if not active_ray.is_colliding():
		direction *= -1
		sprite.flip_h = direction < 0

		ray_front.force_raycast_update()
		ray_back.force_raycast_update()

# ------------------------
# TIMER (SHOOT LOOP)
# ------------------------
func _on_Timer_timeout():
	if player_in_range and player:
		shoot()

# ============================
# FACE PLAYER
# ===============================
func face_player():
	if not player:
		return

	var dir = sign(player.global_position.x - global_position.x)
	sprite.flip_h = dir < 0
	direction = dir
# ============================
# LONG RANGE SHOOTING
# ===============================
func shoot():
	if not player or is_attacking:
		return

	face_player()
	sprite.play("Spit")
	$FrogSpit.play()
# ============================
# WATER BULLETS 
# ===============================
func fire_from_anim():
	if not player:
		return
		
	var dir = (player.global_position - spawn_point.global_position)
	var angle = dir.angle()

	fire(spawn_point.global_position, angle)

func fire(bulletPos, bulletRot):
	var new_water = water_bullet.instance()
	get_parent().add_child(new_water)
	new_water.global_position = bulletPos
	new_water.global_rotation = bulletRot



# =============================
# DAMAGE PLAYER (ON TOUCH): CLOSE RANGE ATTAKCS
# =================================

func _on_FrogArea_body_entered(body):
	if body.name == "Dag":
		player =body
		is_attacking = true
		player_in_melee = true
		face_player()
		velocity.x =0
		sprite.play("Tongue")
		get_node("/root/MainHud").lives -= 1
	
	
	
# ============================
# RETURN TO PATROL WHEN PLAYER HAS LEFT LONG RANGE REGION
# ===============================
func _on_FrogArea_body_exited(body):
	if body.name == "Dag":
		print("Exited frog area")
		player_in_melee = false
		is_attacking = false
		
		if player_in_range and player:
			shoot()  # go straight into ranged attack
		else:
			sprite.play("Hop")
			
# ------------------------
# DETECTION: IF PLAYER GET'S TO CLOSE RANGE
# ------------------------


func _on_DetectRange_body_entered(body):
	if body.name == "Dag":
		player_in_range = true
		player = body
		
		if not player_in_melee:
			shoot() # 🔥
			#timer.start()

func _on_DetectRange_body_exited(body):
	if body.name == "Dag":
		player_in_range = false
		player = null
		
		timer.stop()



# ============================
# SHOOT WATER BULLET AT SPECIFIC FRAME
# ===============================
func _on_AnimatedSprite_frame_changed():
	if sprite.animation == "Spit" and sprite.frame == 7:
		fire_from_anim()
	pass # Replace with function body.
# ============================
# FROG DIE
# ===============================
func die():
	is_attacking = false
	set_physics_process(false)
	
	$CollisionShape2D.disabled = true
	$FrogArea.monitoring = false
	
	sprite.hide()  # or sprite.modulate.a = 0
	
	yield(get_tree().create_timer(0.2), "timeout")
	queue_free()


# ============================
# DAG'S BULLET LANDS ON AREA
# ===============================
func _on_TakeDamage_area_entered(area):
	if area.is_in_group("player_bullet"):
		energy -= 1
		sprite.play("Hurt")
		$death.play()
		area.queue_free()
		if energy <= 0:
			die()
		
	pass # Replace with function body.

# ============================
# GET OUT OF HURT ANIMATION;if still alive and dag's not shooting
# ===============================
func _on_AnimatedSprite_animation_finished():
	if sprite.animation == "Hurt":
		is_attacking = false
		
		if player_in_melee:
			sprite.play("Tongue")
		elif player_in_range and player:
			shoot()
		else:
			sprite.play("Hop")
