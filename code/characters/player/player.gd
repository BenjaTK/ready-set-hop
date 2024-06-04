class_name Player
extends CharacterBody2D


const ACCEL = 0.15
const JUMP_ACCEL = 0.1
const AIR_FRICTION = 0.1
const FRICTION = 0.2

@export var id: int = 1
@export_group("Sprites")
@export var sprite_texture: Texture
@export var sprite_visibility_layer: int = 1
@export var keybind_texture: Texture
@export var outline_sprite_modulate: Color = Color("184a4a")
@export var outline_visibility_layer: int = 2
@export_group("Jump", "jump")
@export var jump_min_velocity: float = 150.0
@export var jump_max_velocity: float = 750.0
@export var jump_height: float = 48.0
@export var jump_time_to_peak: float = 0.25
@export var jump_time_to_descent: float = 0.2
@export var jump_max_hold_time: float = 0.75
@export_group("Keybinds", "key")
@export var key_move_left: StringName = "move_left_1"
@export var key_move_right: StringName = "move_right_1"
@export var key_jump: StringName = "jump_1"

static var can_move: bool = false
var x_velocity: float = 0.0
var is_pressing: bool = false
var event: InputEventScreenTouch

@onready var jump_velocity: float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity: float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity: float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0
@onready var camera_transform: RemoteTransform2D = $CameraTransform

@onready var sprite: Sprite2D = $Sprite
@onready var keybind_sprite: Sprite2D = $Sprite/KeybindSprite
@onready var outline_sprite: Sprite2D = $OutlineSprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_state_machine: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")

@onready var jump_bar: ProgressBar = $JumpBar

@onready var sfx_jump: AudioStreamPlayer = $SFXJump


func _ready() -> void:
	jump_bar.max_value = jump_max_hold_time
	sprite.texture = sprite_texture
	sprite.set_visibility_layer_bit(0, false)
	sprite.set_visibility_layer_bit(sprite_visibility_layer, true)
	outline_sprite.modulate = outline_sprite_modulate
	outline_sprite.set_visibility_layer_bit(outline_visibility_layer, true)
	jump_bar.set_visibility_layer_bit(sprite_visibility_layer, true)
	keybind_sprite.texture = keybind_texture


func _physics_process(delta: float) -> void:
	outline_sprite.frame = sprite.frame

	jump_bar.visible = Input.is_action_pressed(key_jump) or is_pressing

	if Input.is_action_pressed(key_jump) or is_pressing:
		jump_bar.value += delta

	if not is_on_floor():
		velocity.y += _get_gravity() * delta
		if velocity.y < 0.0:
			animation_state_machine.travel("Jump")
		else:
			animation_state_machine.travel("Fall")
	else:
		animation_state_machine.travel("Idle")

		if Input.is_action_just_released(key_jump):
			_jump()
	_apply_friction()
	velocity.x = lerp(velocity.x, x_velocity, 0.25)
	if not can_move:
		velocity.x = 0.0
	move_and_slide()

	for i in get_slide_collision_count():
		var collision: KinematicCollision2D = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is RigidBody2D:
			collider.apply_impulse(-collision.get_normal() * 5.0, collider.to_local(collision.get_position()))



func _get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity


func _get_dir() -> float:
	return Input.get_axis(key_move_left, key_move_right)


func _apply_friction() -> void:
	x_velocity = lerp(x_velocity, 0.0, FRICTION if is_on_floor() else AIR_FRICTION)


func _jump() -> void:
	do_jump(jump_velocity, remap(jump_bar.value, jump_bar.min_value, jump_bar.max_value, jump_min_velocity, jump_max_velocity))
	jump_bar.value = 0.0
	sfx_jump.play()
	keybind_sprite.hide()


func do_jump(y, x) -> void:
	velocity.y = y
	x_velocity = x
	jump_bar.value = 0.0


func die() -> void:
	global_position = Checkpoint.current_checkpoints[id]
	velocity = Vector2.ZERO
	x_velocity = 0.0


func _on_death_box_detector_area_entered(area: Area2D) -> void:
	die()
	$SFXDie.play()


func _on_death_box_detector_body_entered(body: Node2D) -> void:
	die()
	$SFXSplash.play()



