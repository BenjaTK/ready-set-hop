extends Area2D


func _process(delta: float) -> void:
	global_position = get_global_mouse_position()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			gravity_space_override = SPACE_OVERRIDE_REPLACE
		else:
			gravity_space_override = SPACE_OVERRIDE_DISABLED
