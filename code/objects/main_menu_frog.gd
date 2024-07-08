extends RigidBody2D


@export var textures: Array[Texture]

@onready var sprite: Sprite2D = $Sprite
@onready var sfx_land: AudioStreamPlayer = $SFXLand
@onready var sfx_splash: AudioStreamPlayer = $SFXSplash
@onready var sfx_die: AudioStreamPlayer = $SFXDie

var offset: Vector2
var queued_delete: bool = false
var force_idx: int = -1


func _ready() -> void:
	sprite.texture = textures.pick_random()
	if force_idx != -1:
		sprite.texture = textures[force_idx]
	queued_delete = true


func delete() -> void:
	queued_delete = true
	if get_tree().current_scene.has_method("new_frog"):
		get_tree().current_scene.new_frog()


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if queued_delete:
		global_position = Vector2(randi_range(get_viewport_rect().size.x / 2 - 240, get_viewport_rect().size.x / 2 + 240), 0) + offset
		queued_delete = false
		linear_velocity = Vector2.ZERO


func _on_death_box_detector_body_entered(body: Node2D) -> void:
	delete()
	sfx_splash.play()


func _on_body_entered(body: Node) -> void:
	sfx_land.play()


func _on_death_box_detector_area_entered(area: Area2D) -> void:
	delete()
	if area.name != "DeathBox":
		sfx_die.play()
