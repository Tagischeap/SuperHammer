extends CharacterBody2D

enum States {MOVE, JUMP, SWINGX, SWINGY}
enum LegStates {IDLE, MOVE, JUMP, FALL}
enum ArmStates {IDLE, SWINGX, SWINGY}
enum DirectionStates {LEFT, RIGHT}

var CurrentLegState = LegStates.IDLE
var CurrentArmState = ArmStates.IDLE
var CurrentDirectionState = DirectionStates.RIGHT

var CurrentState = States.MOVE

const SPEED = 125.0
const JUMP_VELOCITY = -250.0
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
		States.SWINGY:
			SwingY()
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
			$AnimationPlayer.play("Idle")
	# Handle Jump.
	if Input.is_action_just_pressed("ui_select") and is_on_floor():
		Jump()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		$AnimationPlayer.play("Walk")
		if direction > 0:
			ChangeDirection(DirectionStates.RIGHT)
		else:
			ChangeDirection(DirectionStates.LEFT)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if Input.is_action_just_pressed("ui_action"):
			CurrentState = States.SWINGX
	if Input.is_action_just_pressed("ui_action2"):
			CurrentState = States.SWINGY

func PushPlayer(dir):
	velocity += dir
	
func Jump():
		$AnimationPlayer.play("Jump")
		velocity.y = JUMP_VELOCITY

func SwingX():
	$AnimationPlayer.play("Swing X")
func ShoveX():
	if CurrentDirectionState == DirectionStates.RIGHT:
		PushPlayer(Vector2(300,-100))
	else:
		PushPlayer(Vector2(-300,-100))
		
func SwingY():
	$AnimationPlayer.play("Swing Y")
func ShoveY():
	if CurrentDirectionState == DirectionStates.RIGHT:
		PushPlayer(Vector2(100,-250))
	else:
		PushPlayer(Vector2(-100,-250))
		
func ChangeDirection(dir):
	if dir == null:
		if CurrentDirectionState == DirectionStates.RIGHT:
			dir = DirectionStates.RIGHT
		else:
			dir = DirectionStates.LEFT
	if dir == DirectionStates.RIGHT:
			CurrentDirectionState = DirectionStates.RIGHT
			$Sprite2D.flip_h = false
			$Hammer/CollisionShape2D.position.x = 28
	elif dir == DirectionStates.LEFT:
			CurrentDirectionState = DirectionStates.LEFT
			$Sprite2D.flip_h = true
			$Hammer/CollisionShape2D.position.x = -28

func OnStateFinished():
	CurrentState = States.MOVE
