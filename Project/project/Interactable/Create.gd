extends StaticBody2D

var health = 3

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _on_hitbox_area_entered(area):
	if area.name == "HurtBox":
		if health == 3:
			$AnimationPlayer.play("Hurt")
		if health == 2:
			$AnimationPlayer.play("Hurt 2")
		if health == 1:
			$AnimationPlayer.play("Hurt 3")

		health -= 1
		await $AnimationPlayer.animation_finished
	if health <= 0:
		$AnimationPlayer.play("Destroyed")
		await $AnimationPlayer.animation_finished
		queue_free()
		
func _physics_process(delta):
	floor_detection(delta)
func floor_detection(delta):
		
