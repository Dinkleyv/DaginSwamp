extends KinematicBody2D

var blob_bullet = preload("res://EnemyScenes/BlobBullet.tscn")
onready var sprite = $AnimatedSprite
onready var spawn_point = $AnimatedSprite/ProjectileSpawn 
onready var timer = $Timer


onready var ray_front = $RayCast2DFront
onready var ray_back = $RayCast2D2Back




var velocity = Vector2.ZERO
var gravity = 900
var move_speed = 100
var direction = 1

var energy = 10
var player = null


var player_in_range = false
var player_in_melee = false 
var is_hurt = false
var is_attacking = false



func _physics_process(delta):
	if is_hurt:
		velocity.x = 0
		velocity.y += gravity * delta
		velocity = move_and_slide(velocity, Vector2.UP)
		return
	
	velocity.y += gravity * delta
	if player:
		face_player()#face player
	if not is_hurt and not is_attacking:#player not attacking and blob not hurt
		if player_in_melee:#dag is at close range 
			start_attack()#start close range attack
		elif player_in_range:#if player in long range
			start_shoot()# shoot player
	if player_in_melee:
		velocity.x = 0 # don't move
	elif player_in_range and player:
		velocity.x = 0
	else:
		patrol()
	
	velocity = move_and_slide(velocity, Vector2.UP)

# =========================
#	PATROL MOVEMENT
#===========================
func patrol():
	velocity.x = move_speed * direction
	sprite.play("Walk")
	
	var active_ray = ray_front if direction == 1 else ray_back
	if not active_ray.is_colliding():
		direction *= -1
		sprite.flip_h = direction > 0
		
		ray_front.force_raycast_update()
		ray_back.force_raycast_update()
# =========================
#	TAKE DAMAGE AREA
#===========================
func _on_TakeDamage_area_entered(area):
	if area.is_in_group("player_bullet"):#if the bullet lands in the area
		energy -= 1#reduce the energy of the blob
		is_hurt = true
		is_attacking = false
		sprite.play("Hurt")
		area.queue_free()#delete from screen
		if energy <= 0:
			die()

# =========================
#	GET OUT OF THE HURT STATE, IF PLAYER STOPS FIRING
#===========================
func _on_AnimatedSprite_animation_finished():
	if sprite.animation == "Hurt":
		is_hurt = false
		if player_in_melee:#at distance long range attacking
			start_attack()
		elif player_in_range:
			sprite.play("Idle")
		else:
			sprite.play("Walk")
	elif sprite.animation == "Attack":
		is_attacking = false
		if player_in_melee:
			start_attack()
		else:
			sprite.play("Walk")
	elif sprite.animation == "Shoot":
		is_attacking = false
		if player_in_range:
			sprite.play("Idle")
		else:
			sprite.play("Walk")

# =========================
#	AREA RANGE FOR LONG RANGE ATTACKS
#===========================
func _on_DetectRange_body_entered(body):
	if body.name == "Dag":
		player = body
		player_in_range = true
		if not player_in_melee and not is_hurt:
			start_shoot()
# =========================
#	OUT OF AREA RANGE GO BACK TO  PREVIOUS PATROL
#===========================
func _on_DetectRange_body_exited(body):
	if body.name == "Dag":
		player = null
		player_in_range = false
		timer.stop()

# =========================
#	AREA RANGE FOR SHORT DISTANCE ATTACKS
#===========================
# --- Detect player entering melee (BlobArea) ---
func _on_BlobArea_body_entered(body):
	if body.name == "Dag":
		player = body
		player_in_melee = true
		if not is_hurt:
			start_attack()
# =========================
#	AFTER GETTING OUT OF SHORT DISTANCE RANGE EXITED GO BACK TO OTHER STATES
#===========================
func _on_BlobArea_body_exited(body):
	if body.name == "Dag":
		player_in_melee = false
		is_attacking = false

# =========================
#	MELEE ATTACK: short range attacks
#===========================
func start_attack():
	if is_attacking or is_hurt:
		return
	is_attacking = true
	face_player()
	sprite.play("Attack")
	$Slash.play()
	
# =========================
#	LONG RANGE ATTACK: 
#===========================
func start_shoot():
	if is_attacking or is_hurt:
		return
	is_attacking = true
	face_player()
	sprite.play("Shoot")

# =========================
#	BLOB SHOULD ALWAYS FACE PLAYER
#===========================
func face_player():
	if not player:
		return
	var dir = sign(player.global_position.x - global_position.x)
	if dir == 0:
		dir = 1
	direction = dir
	sprite.flip_h = dir > 0
# =========================
# FIRE PROJECTILES 
#===========================
# --- Fire projectile on specific animation frame ---
func _on_AnimatedSprite_frame_changed():
	if sprite.animation == "Shoot" and sprite.frame == 2:
		fire_projectile()
	if sprite.animation == "Attack" and sprite.frame == 4:
		if player_in_melee and player:
			# Assuming player has a method called 'take_damage'
			get_node("/root/MainHud").lives -= 10

# --- Projectile spawning ---
func fire_projectile():
	if not player:
		return
	var bullet_instance = blob_bullet.instance()
	get_parent().add_child(bullet_instance)
	bullet_instance.global_position = spawn_point.global_position
	
	var dir = (player.global_position - bullet_instance.global_position).normalized()
	bullet_instance.rotation = dir.angle()

# =========================
#	DIE
#===========================
func die():
	
	sprite.play("Die")
	$death.play()
	yield(sprite, "animation_finished")
	queue_free()
	
