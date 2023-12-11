extends CharacterBody2D

var health = 3

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
		
func _ready():
	$AnimationPlayer.play("Active")
	
func _physics_process(delta):
	if !is_on_floor():
		# Add the gravity.
		velocity.y += gravity * delta
func _on_hitbox_area_entered(area):
	print("Hit")
	if area.name == "HurtBox":
		if health == 3:
			print("3")
			$AnimationPlayer.play("Hurt")
		if health == 2:
			print("2")
			$AnimationPlayer.play("Hurt 2")
		if health == 1:
			print("1")
			$AnimationPlayer.play("Hurt 3")
		health -= 1
	if health <= 0:
		$AnimationPlayer.play("Destroyed")
		await $AnimationPlayer.animation_finished
		queue_free()
		
