extends Node2D

var player_spawn:Vector2 = Vector2(162, 221)

func _ready() -> void:
	pass
	#if Global.player_position == Vector2.ZERO:
		#print("Usando posición inicial:", player_spawn)
		##$jugador.global_position = player_spawn
		#Player.global_position = player_spawn
	#else:
		#Player.movement = true
		##$jugador.global_position = Global.player_position
		#
		#
