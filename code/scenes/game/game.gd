extends Node


const MAIN_MENU_FROG = preload("res://code/objects/main_menu_frog.tscn")

@onready var player_1_viewport: SubViewport = $VBoxContainer/SubViewportContainer/Player1Viewport
@onready var player_1_camera: Camera2D = $VBoxContainer/SubViewportContainer/Player1Viewport/Player1Camera
@onready var player_2_viewport: SubViewport = $VBoxContainer/SubViewportContainer2/Player2Viewport
@onready var player_2_camera: Camera2D = $VBoxContainer/SubViewportContainer2/Player2Viewport/Player2Camera
@onready var player_1: Player = $VBoxContainer/SubViewportContainer/Player1Viewport/Level/Player1
@onready var player_2: Player = $VBoxContainer/SubViewportContainer/Player1Viewport/Level/Player2



func _ready() -> void:
	player_2_viewport.world_2d = player_1_viewport.world_2d
	player_1.camera_transform.remote_path = player_1_camera.get_path()
	player_2.camera_transform.remote_path = player_2_camera.get_path()
	player_1_viewport.size.x = $HSeparator.get_viewport_rect().size.x
	player_2_viewport.size.x = $HSeparator.get_viewport_rect().size.x


func start_game() -> void:
	$VBoxContainer/SubViewportContainer/Player1Viewport/Level/Music.play()
	Player.can_move = true


func _process(delta: float) -> void:
	player_1_viewport.size.x = $HSeparator.get_viewport_rect().size.x
	player_2_viewport.size.x = $HSeparator.get_viewport_rect().size.x


func game_over(winning_id: int) -> void:
	$AnimationPlayer.play("game_over")
	$CanvasLayer/Label.text = "Congrats!\nYou win, player %s" % winning_id
	await get_tree().create_timer(1.5).timeout
	for i in 15:
		var frog = MAIN_MENU_FROG.instantiate()
		$CanvasLayer.add_child.call_deferred(frog)
		frog.z_index = 2
		frog.force_idx = winning_id - 1
		await get_tree().create_timer(randf_range(0.9, 1.1)).timeout


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		var player: Player
		if event.position.x < 240:
			player = player_1
		elif event.position.x > 240:
			player = player_2
		player.is_pressing = event.pressed
		if event.is_released() and player.is_on_floor() and is_instance_valid(player.event) and event.index == player.event.index:
			player._jump()
			player.event = null
			return
		player.event = event


func _on_restart_button_pressed() -> void:
	Transition.transition_to_file("res://code/scenes/main_menu/main_menu.tscn")


func show_back_button() -> void:
	var tween = create_tween()
	$CanvasLayer/BackButton.position.x = $CanvasLayer/BackButton.get_viewport_rect().size.x + 62
	tween.tween_property($CanvasLayer/BackButton, "position:x", $CanvasLayer/BackButton.get_viewport_rect().size.x / 2.0 - 31, 0.1)
