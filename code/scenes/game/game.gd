extends Node


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


func start_game() -> void:
	$VBoxContainer/SubViewportContainer/Player1Viewport/Level/Music.play()
	Player.can_move = true


func game_over(winning_id: int) -> void:
	$AnimationPlayer.play("game_over")
	$CanvasLayer/Label.text = "Felicidades!\nGanaste, Jugador %s" % winning_id
