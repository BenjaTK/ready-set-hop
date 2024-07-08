extends Control


const MAIN_MENU_FROG = preload("res://code/objects/main_menu_frog.tscn")
const GAME = preload("res://code/scenes/game/game.tscn")
const MAX_FROGS: int = 50


@onready var frog_container: Node2D = $FrogContainer


func new_frog() -> void:
	if frog_container.get_child_count() < MAX_FROGS:
		var frog = MAIN_MENU_FROG.instantiate()
		frog_container.add_child.call_deferred(frog)


func _on_start_button_pressed() -> void:
	Transition.transition_to_scene(GAME)


func _process(delta: float) -> void:
	$TileMapLayers.global_position.x = get_viewport_rect().size.x / 2 - 240


func _spawn_frogs() -> void:
	for i in 5:
		new_frog()
		await get_tree().create_timer(randf_range(0.1, 0.2)).timeout
