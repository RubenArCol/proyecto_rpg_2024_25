extends Area2D

signal tp()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		emit_signal("tp") # needs implementation
		body.toggle_movement()
		await  Load.transition()
		body.global_position = $Destination.global_position
