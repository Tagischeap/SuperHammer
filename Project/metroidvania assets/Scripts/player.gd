extends CharacterBody2D
const SPEED = 300.0
const JUMP = 400.0
const GRAVITY = 20
func _physics_process(delta):
	Move(delta)
	velocity.y += GRAVITY
	move_and_slide()

func Move(delta):
	var movement = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if movement != 0:
		if movement > 0.0:
			velocity.x += SPEED*delta
			velocity.x = clamp(SPEED, 100, SPEED)
			$Sprite2D.flip_h = false
			$AnimationPlayer.play("Walk")
		if movement < 0.0:
			velocity.x -= SPEED*delta
			velocity.x = clamp(SPEED, -100, -SPEED)
			$Sprite2D.flip_h = true
			$AnimationPlayer.play("Walk")
	if movement == 0:
		velocity.x = 0.0
		$AnimationPlayer.play("Idle")
	if is_on_floor() && Input.is_action_just_pressed("ui_accept"):
		$AnimationPlayer.play("Jump")
		Jump()
	if !is_on_floor() && velocity.y > 10:
		$AnimationPlayer.play("Fall")
func Jump():
	velocity.y -= JUMP
