extends Button


var target_scale: float = 1.0


func _process(delta: float) -> void:
	scale = lerp(scale, Vector2(target_scale, target_scale), delta * 40.0)


func _on_focus_entered() -> void:
	target_scale = 1.25


func _on_mouse_entered() -> void:
	target_scale = 1.25


func _on_mouse_exited() -> void:
	target_scale = 1


func _on_button_down() -> void:
	target_scale = 1.0
