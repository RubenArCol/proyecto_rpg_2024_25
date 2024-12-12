extends Area2D

var is_battle_active: bool = false  # Prevents multiple battle triggers

func _ready() -> void:
	randomize()
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
	if not is_battle_active:  # Ensure only one battle starts
		is_battle_active = true
		print("Battle initiated!")
		# Change to the battle scene
		get_tree().change_scene_to_file("res://recursos_proyecto_godot/Reusable_Functions/battle.tscn")
