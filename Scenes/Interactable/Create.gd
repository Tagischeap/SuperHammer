extends StaticBody2D

var health = 3

func _on_hitbox_area_entered(area):
	if area.name == "Hammer":
		$AnimationPlayer.play("Hurt")
		health -= 1
		await $AnimationPlayer.animation_finished
		$AnimationPlayer.play("Active")
	if health <= 0:
		$AnimationPlayer.play("Destroyed")
		await $AnimationPlayer.animation_finished
		queue_free()
