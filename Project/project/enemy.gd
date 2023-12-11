extends CharacterBody2D

var moving_left = true
const SPEED = 15
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var health = 1

func _ready():
	$AnimationPlayer.play("Idle")
func _physics_process(delta):
	Move()
	floor_detection(delta)
	health_detection()
func _on_hitbox_area_entered(area):
	print(area.name)
	if area.name == "HurtBox":
		health -= 1
		print(health)

func Move():
	if moving_left:
		velocity.x = SPEED
	else:
		velocity.x = -SPEED
	move_and_slide()
func health_detection():
	if health <= 0:
		velocity.x = 0
		$AnimationPlayer.play("Death")	
		await $AnimationPlayer.animation_finished
		queue_free()
func floor_detection(delta):
	if is_on_floor():
		if !$"RayCast2D - y".is_colliding():
			moving_left = !moving_left
			scale.x = -scale.x
		elif $"RayCast2D - x".is_colliding():
			moving_left = !moving_left
			scale.x = -scale.x
	else:
		# Add the gravity.
		velocity.y += gravity * delta
		
