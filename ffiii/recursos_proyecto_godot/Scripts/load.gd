extends CanvasLayer

func transition() -> void:
	$AnimationPlayer.play("dissolve")
	$AnimationPlayer.play_backwards("dissolve")
