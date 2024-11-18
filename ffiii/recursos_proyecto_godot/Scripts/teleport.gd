extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		await  Load.transition()
		body.global_position = $Destination.global_position
