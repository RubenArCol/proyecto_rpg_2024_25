extends Node2D

var player_spawn:Vector2 = Vector2(162, 221)

func _ready() -> void:
	if Global.first_dialog:
		Global.first_dialog = false
		$jugador/CharacterBody2D.movement = false
		$CanvasLayer.display_text("¿Como he llegado aquí?", "Player:")
		await $CanvasLayer.textbox_closed
		$jugador/CharacterBody2D.movement = true
	

func _process(delta: float) -> void:
	if Battlezone.is_battle_active:
		$encounter_found/Audio.play()
		$encounter_found/AnimationPlayer.play("encounter")

func _on_boss_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and not Global.battle_completed:
		$jugador/CharacterBody2D.movement = false
		
		$CanvasLayer.display_text("Noto algo...", "Player:")
		await $CanvasLayer.textbox_closed
		$CanvasLayer.display_text("¿Que hace un humano aquí?", "??????:")
		await $CanvasLayer.textbox_closed
		$CanvasLayer.display_text("Elegí este sitio por que era una zona bastante alejada. Mmmmm....", "??????:")
		await $CanvasLayer.textbox_closed
		$CanvasLayer.display_text("No importa, supongo que llegó la hora de hacer limpieza", "??????:")
		await $CanvasLayer.textbox_closed
		$CanvasLayer.display_text("¡¡¡¡!!!!", "Player:")
		await $CanvasLayer.textbox_closed
		Global.battle_completed = true
		get_tree().change_scene_to_file("res://recursos_proyecto_godot/Reusable_Functions/battle_boss.tscn")
