extends Sprite2D


var t: float = 0.0

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		#body.velocity = Vector2(body.jump_max_velocity * 0.75, body.jump_velocity * 1.5)
		body.do_jump(body.jump_velocity * 1.5, body.jump_max_velocity * 0.75)
		var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
		scale = Vector2(1.5, 0.5)
		tween.tween_property(self, "scale", Vector2.ONE, 0.25)


func _process(delta: float) -> void:
	t += delta
	offset.y = 5 + roundi(sin(t * 2))
