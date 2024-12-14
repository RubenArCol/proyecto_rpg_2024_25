extends Control

func _on_retry_pressed() -> void:
	Global.player_position = Vector2(162, 221)
	Player.player_current_exp = 0
	Player.player_level = 1
	Player.current_health = Player.health
	get_tree().change_scene_to_file("res://recursos_proyecto_godot/maps/firstCave.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
