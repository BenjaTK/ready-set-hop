extends RigidBody2D


@export_range(0, 360, 1.0, "suffix:°") var rotation_range: float = 45


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	rotation_degrees = clamp(rotation_degrees, -rotation_range, rotation_range)
