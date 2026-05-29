extends KinematicBody2D

# ------------------------
# EXPORT VARIABLES
# ------------------------
export var run_speed = 200
export var gravity = 1000
export var patrol_speed = 100
export var attack_range = 50  # distance to start attacking

# ------------------------
# VARIABLES
# ------------------------
var velocity = Vector2()
var direction = 1  # 1 = right, -1 = left
var player = null
var player_in_range = false

var is_dead = false
var is_attacking = false
var energy = 15


var can_flip = true
var flip_cooldown = 0.3
# ------------------------
# NODES
# ------------------------
onready var ray_front = $RayCast2DFront
onready var ray_back = $RayCast2DBack
onready var sprite = $AnimatedSprite

# ------------------------
# PHYSICS LOOP
# ------------------------
func _physics_process(delta):
	if is_dead:
		return  # stop all actions if dead

	# Apply gravity
	velocity.y += gravity * delta

	if is_attacking:
		velocity.x = 0
		sprite.play("Attack")
		$attack.play()
	elif player_in_range and player:
		chase_player()
	else:
		patrol()

	velocity = move_and_slide(velocity, Vector2.UP)

# ===================
# PATROL
# =====================
func patrol():
	velocity.x = patrol_speed * direction
	sprite.play("Walk") 
	var active_ray = ray_front if direction == 1 else ray_back
	if not active_ray.is_colliding():
		direction *= -1
		sprite.flip_h = direction < 0

		# change the rays 
		ray_front.force_raycast_update()
		ray_back.force_raycast_update()
		
# ============================
# fFLIP SPIDER
# ===============================
func flip_direction():
	direction *= 1
	sprite.flip_h = direction < 0
	
# ------------------------
# CHASE PLAYER
# ------------------------
func chase_player():
	if not player:
		return

	var dir = sign(player.global_position.x - global_position.x)
	direction = dir
	sprite.flip_h = direction < 0

	# Stop at edges
	var active_ray = ray_front if direction == 1 else ray_back
	if not active_ray.is_colliding():
		# Edge detected → stop chasing, go back to patrol
		player_in_range = false
		is_attacking = false
		return

	# Move towards player
	velocity.x = run_speed * direction
	sprite.play("Run")

	

# ------------------------
# ATTACK RESET 
# ------------------------
func stop_attack():
	is_attacking = false






# ------------------------
# PLAYER DETECTION : CLOSE RANGE
# ------------------------
func _on_DetectRange_body_entered(body):
	if body.name == "Dag":
		player_in_range = true
		player = body

func _on_DetectRange_body_exited(body):
	if body.name == "Dag":
		player_in_range = false
		player = null
		is_attacking = false

# ------------------------
# TAKE DAMAGE FROM PLAYER'S FIRE BALL
# ------------------------
func _on_TakeDamage_area_entered(area):
	if area.is_in_group("player_bullet"):
		energy -= 1
		area.queue_free()
		sprite.play("Hit")#change to dizzy
		if energy <= 0:
			die()

	

# ------------------------
# DEATH
# ------------------------
func die():
	is_dead = true
	is_attacking = false
	
	velocity = Vector2.ZERO
	
	sprite.play("Die")
	
	
	
	
func _on_AnimatedSprite_animation_finished():
	if sprite.animation == "Die":
		yield(get_tree().create_timer(1.0), "timeout")
		call_deferred("queue_free")

# ============================
# FACE PLAYER
# ===============================
func face_player():
	if not player:
		return
	var dx = player.global_position.x - global_position.x
	if dx == 0:
		return
	direction = sign(dx)
	sprite.flip_h = direction < 0
		
		

# ============================
# AREA TO ATTACK PLAYER
# ===============================
func _on_AttackArea_body_entered(body):
	if body.name == "Dag":
		player = body
		is_attacking = true
		face_player()
		sprite.play("Attack")
		get_node("/root/MainHud").lives -= 15
	pass # Replace with function body.

# ============================
# IF PLAYER EXITS ATTACK AREA CHASE  PLAYER
# ===============================
func _on_AttackArea_body_exited(body):
	if body.name == "Dag":
		is_attacking = false
		if player_in_range and player:
			chase_player()
		else:
			sprite.play("Walk")
	pass # Replace with function body.
