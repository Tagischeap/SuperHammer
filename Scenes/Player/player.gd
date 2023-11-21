extends CharacterBody2D

enum States {MOVE, SWINGX}
var CurrentState = States.MOVE

const SPEED = 125.0
const JUMP_VELOCITY = -200.0
var pressed = 2

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	$Hammer/CollisionShape2D.disabled = true

func _physics_process(delta):
	match CurrentState:
		States.MOVE:
			Move(delta)
		States.SWINGX:
			SwingX()
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()
	
func Move(delta):
	# Add the gravity.
	if not is_on_floor():
		if velocity.y > 100:
			$AnimationPlayer.play("Fall")
	else:
		if velocity.x == 0: 
			pressed = 2
			$AnimationPlayer.play("Idle")

	# Handle Jump.
	if Input.is_action_just_pressed("ui_select"):
		pressed -= 1
		
	if Input.is_action_just_pressed("ui_select") and is_on_floor():
		if pressed > 0:
			Jump()
	if Input.is_action_just_pressed("ui_select"):
		if pressed > 0:
			Jump()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		$AnimationPlayer.play("Walk")
		if direction > 0:
			$Sprite2D.flip_h = false
			$Hammer/CollisionShape2D.position.x = 28
		else:
			$Sprite2D.flip_h = true
			$Hammer/CollisionShape2D.position.x = -28
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if Input.is_action_just_pressed("ui_action"):
			CurrentState = States.SWINGX
	
func Jump():
		$AnimationPlayer.play("Jump")
		velocity.y = JUMP_VELOCITY
	
func SwingX():
	$AnimationPlayer.play("Swing X")
func OnStateFinished():
	CurrentState = States.MOVE
