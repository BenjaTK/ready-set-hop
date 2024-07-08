extends CanvasLayer


@onready var color_rect: ColorRect = $ColorRect


func transition_to_scene(scene: PackedScene) -> void:
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	color_rect.position = Vector2(-color_rect.get_viewport_rect().size.x, 0)
	color_rect.visible = true
	tween.tween_property(color_rect, "position", Vector2.ZERO, 0.2)
	tween.tween_callback(get_tree().change_scene_to_packed.bind(scene))
	tween.tween_property(color_rect, "position", Vector2(color_rect.get_viewport_rect().size.x, 0), 0.2).set_delay(0.2)
	tween.tween_callback(color_rect.hide)


func transition_to_file(path: String) -> void:
	transition_to_scene(load(path))
