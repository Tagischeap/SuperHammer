extends CharacterBody2D

enum States {MOVE, JUMP, SWINGX, SWINGY, POUND}
var CurrentState = States.MOVE
#TODO: Have Movement States be different than Action States
enum LegStates {IDLE, MOVE, JUMP, FALL}
var CurrentLegState = LegStates.IDLE

enum ArmStates {IDLE, SWINGX, SWINGY, POUND}
var CurrentArmState = ArmStates.IDLE

enum DirectionStates {LEFT, RIGHT}
var CurrentDirectionState = DirectionStates.RIGHT


const SPEED = 125.0
const JUMP_VELOCITY = -250.0
#TODO: Differnt charges
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var chargX = 1
var chargY = 1
var chargP = 1

func _ready():
	$HurtBox/CollisionShape2D.disabled = true
	
func _physics_process(delta):
	match CurrentState:
		States.MOVE:
			Move(delta)
		States.SWINGX:
			SwingX()
		States.SWINGY:
			SwingY()
		States.POUND:
			Pound()
	if is_on_floor():
		chargX = 1
		chargY = 1
		chargP = 1
	else:
		# Add the gravity.
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
		if chargY > 0:
			CurrentState = States.SWINGY
		else:
			CurrentState = States.POUND

func PushPlayer(dir):
	velocity += dir
	
func Jump():
		$AnimationPlayer.play("Jump")
		velocity.y = JUMP_VELOCITY

func SwingX():
	if chargX > 0:
		$AnimationPlayer.play("Swing X")
		chargX = 0
func ShoveX():
	var m = 1
	if not is_on_floor():
		m = 1.5
	else:
		m = 1
	if CurrentDirectionState == DirectionStates.RIGHT:
		PushPlayer(Vector2(-JUMP_VELOCITY*m,-70*m))
	else:
		PushPlayer(Vector2(JUMP_VELOCITY*m,-70*m))
		
func SwingY():
	if chargY > 0:
		$AnimationPlayer.play("Swing Y")
		chargY = 0
func ShoveY():
	var m = 1
	if not is_on_floor():
		m = 1.5
	else:
		m = 1
	if CurrentDirectionState == DirectionStates.RIGHT:
		PushPlayer(Vector2(100*m,JUMP_VELOCITY*m))
	else:
		PushPlayer(Vector2(-100*m,JUMP_VELOCITY*m))

func Pound():
	if chargP > 0:
		$AnimationPlayer.play("Pound")
		chargP = 0
func ShoveP():
	var m = 1
	if not is_on_floor():
		m = 1.5
	else:
		m = 0
	if CurrentDirectionState == DirectionStates.RIGHT:
		PushPlayer(Vector2(100,-JUMP_VELOCITY*m))
	else:
		PushPlayer(Vector2(-100,-JUMP_VELOCITY*m))
	
func ChangeDirection(dir):
	if dir == null:
		if CurrentDirectionState == DirectionStates.RIGHT:
			dir = DirectionStates.RIGHT
		else:
			dir = DirectionStates.LEFT
	if dir == DirectionStates.RIGHT:
			CurrentDirectionState = DirectionStates.RIGHT
			$Sprite2D.flip_h = false
			$HurtBox/CollisionShape2D.position.x = 28
	elif dir == DirectionStates.LEFT:
			CurrentDirectionState = DirectionStates.LEFT
			$Sprite2D.flip_h = true
			$HurtBox/CollisionShape2D.position.x = -28

func OnStateFinished():
	CurrentState = States.MOVE
