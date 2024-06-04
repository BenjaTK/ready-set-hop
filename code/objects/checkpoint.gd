class_name Checkpoint
extends Area2D


static var current_checkpoints: Dictionary = {1:Vector2.INF,2:Vector2.INF}


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		current_checkpoints[body.id] = global_position
