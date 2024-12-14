extends Area2D

var is_battle_active: bool = false  # Prevents multiple battle triggers

func _ready() -> void:
	is_battle_active = false
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body: Node) -> void:
	# checks if the player is inside the "battle zone"
	if body.is_in_group("Player"):
		body.connect("encounter", Callable(self, "_on_encounter_triggered"))

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("Player"):
		#disconnects signal
		body.disconnect("encounter", Callable(self, "_on_encounter_triggered"))

func _on_encounter_triggered() -> void:
	is_battle_active = true
	# Change to the battle scene
	get_tree().change_scene_to_file("res://recursos_proyecto_godot/Reusable_Functions/battle.tscn")
