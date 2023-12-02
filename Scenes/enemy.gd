extends CharacterBody2D

var moving_left = true
const SPEED = 15
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	Move()
func Move():
	if moving_left:
		velocity.x = SPEED
	else:
		velocity.x = -SPEED
	move_and_slide()
	
func floor_detection():
	pass
