extends Area2D

signal tp()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		emit_signal("tp") # emit signal
		await  Load.transition() # aprox 1.2 secs
		body.global_position = $Destination.global_position # change position
