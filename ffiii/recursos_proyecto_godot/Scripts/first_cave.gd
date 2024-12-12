extends Node2D

var player_spawn:Vector2 = Vector2(162, 221)

func _ready() -> void:
	if Player.last_position == Vector2.ZERO:
		$jugador.global_position = player_spawn
	else:
		$jugador.global_position = Player.last_position
