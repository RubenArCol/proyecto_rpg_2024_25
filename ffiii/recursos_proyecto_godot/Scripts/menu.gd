extends Control

func _ready():
	$VBoxContainer/btnInicio.grab_focus()

func _on_btn_inicio_pressed() -> void:
	get_tree().change_scene_to_file("res://recursos_proyecto_godot/maps/firstCave.tscn")

func _on_btn_salir_pressed() -> void:
	get_tree().quit()
