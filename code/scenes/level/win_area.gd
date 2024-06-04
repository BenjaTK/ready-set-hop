extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		monitoring = false
		monitorable = false
		Player.can_move = false
		$AnimationPlayer.play("fireworks")
		await $AnimationPlayer.animation_finished
		get_tree().current_scene.game_over(body.id)

