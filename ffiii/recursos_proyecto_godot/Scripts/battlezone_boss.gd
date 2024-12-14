extends Area2D

signal boss_encounter

func _on_body_entered(body: Node) -> void:
	# checks if the player is inside the "battle zone"
	if body.is_in_group("Player") and not Global.battle_completed:
		emit_signal("boss_encounter", body)
