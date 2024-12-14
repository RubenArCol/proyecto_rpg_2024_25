extends Control

signal textbox_closed

# enemy used in combat
@export var enemy:Resource = null

# math operations applied to this variables to avoid posible errors
var current_player_health = 0
var current_enemy_health = 0
var defending = false

var turn_counter = 0

func _ready():
	Player.movement = false
	
	set_health($enemy_container/ProgressBar, enemy.health, enemy.health)
	$enemy_container/enemy.texture = enemy.texture
	current_enemy_health = enemy.health
	
	set_health($player_panel/player_data/ProgressBar, Player.current_health, Player.health)
	Player.player_dmg = 0
	current_player_health = Player.current_health
	enemy.damage = Player.health
	
	$text_box.hide()
	$action_panel.hide()
	
	display_text("%s: ¡Haber entrado aquí será la ultima decisión que tomes!" % enemy.name)
	await textbox_closed
	$action_panel.show()

func set_health(progress_bar, health, max_health):
	progress_bar.value = health
	progress_bar.max_value = max_health
	progress_bar.get_node("Label").text = "Hp: %d/%d" % [health, max_health]

func _input(event: InputEvent):
	if (Input.is_action_just_pressed("interaction") or Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and $text_box.visible):
		$text_box.hide()
		emit_signal("textbox_closed")

func display_text(text):
	$text_box.show()
	$text_box/Label.text = text

func _on_huir_pressed() -> void:
	display_text("!La sala esta cerrada, no hay escape posible¡")
	await textbox_closed

func _on_atacar_pressed() -> void:
	display_text("!Golpeas con todas tus fuerzas¡")
	await textbox_closed
	
	current_enemy_health = max(0, current_enemy_health - Player.player_dmg)
	set_health($enemy_container/ProgressBar, current_enemy_health, enemy.health)
	
	$AnimationPlayer.play("enemy_damaged")
	await get_tree().create_timer(0.5)
	
	display_text("Realizaste %d de daño" % Player.player_dmg)
	await textbox_closed
	
	if current_enemy_health == 0:
		display_text("%s: ¡ES IMPOSIBLE!" % enemy.name)
		await textbox_closed
		
		display_text("%s: ¡UN MALDITO PUEBLERINO HUMANO NO PUEDE DESTROZAR MIS PLANES!" % enemy.name)
		await textbox_closed
		
		display_text("%s: ¡NO IMPORTA, POR MUCHO QUE LO INTENTEIS NO PODREIS PARAR SU LLEGADA JAJAJAJA!" % enemy.name)
		await textbox_closed
		
		$AnimationPlayer.play("enemy_death")
		await get_tree().create_timer(0.5)
		
		display_text("Player: Lo...")
		await textbox_closed
		
		display_text("Player: ¿Lo conseguí?")
		await textbox_closed
		
		display_text("Player: A que se refería con mi destino...")
		await textbox_closed
		
		display_text("Payer: ¿Y la llegada de quíen?")
		await textbox_closed
		
		display_text("¡Recibiste %d puntos de experiencia!" % enemy.experience)
		await textbox_closed
		
		Player.player_current_exp += enemy.experience
		
		if (Player.player_current_exp >= Player.exp_to_level_up):
			Player.player_level += 1
			display_text("¡Subiste a nivel %d!" % Player.player_level)
			await textbox_closed
			
			exp_actualization()
			
			print("%d es la nueva cantidad de experiencia para subir" % Player.exp_to_level_up)
		
		Player.in_battle = false
		Player.current_health = current_player_health
		Player.global_position = Global.player_position
		get_tree().change_scene_to_file("res://recursos_proyecto_godot/maps/firstCave.tscn")
		return  
		
	enemy_turn()
	
func enemy_turn():
	display_text("!%s trata de darte muerte¡" % enemy.name)
	await textbox_closed
	
	if defending:
		defending = false
		$AnimationPlayer.play("player_damaged_while_defending")
		await get_tree().create_timer(0.5)
	
	else:
		current_player_health = max(1, current_player_health - enemy.damage)
		set_health($player_panel/player_data/ProgressBar, current_player_health, Player.health)

		$AnimationPlayer.play("player_damaged")
		await get_tree().create_timer(0.5)
		
		if turn_counter == 0:
			display_text("%s: Pronto acabará todo" % enemy.name)
			await textbox_closed
			display_text("¡Player: Maldita sea!")
			await textbox_closed
			display_text("??????: ...................")
			await textbox_closed
		elif turn_counter == 2:
			Player.player_dmg = 70
			display_text("??????: ...................")
			await textbox_closed
			display_text("??????: no te rindas hijo mío, este no es tu destino")
			await textbox_closed
		elif turn_counter == 3:
			display_text("%s: ¡Porqué no mueres!" % enemy.name)
			await textbox_closed
		elif turn_counter == 5:
			display_text("%s: ¡No quedará nada de tí maldito insecto!" % enemy.name)
			await textbox_closed
	
	if turn_counter >= 2:
		Player.current_health = Player.health
		set_health($player_panel/player_data/ProgressBar, Player.current_health, Player.health)
		current_player_health = Player.current_health
		display_text("La fuerza desborda en tí")
		await textbox_closed
	
	turn_counter += 1

func _on_defensa_pressed() -> void:
	if turn_counter >= 2:
		defending = true
	
		display_text("Player: ¡Mi vida no acabará aquí!")
		await textbox_closed
	
		await get_tree().create_timer(0.5)
	else:
		display_text("El miedo te impide pensar con claridad")
		await textbox_closed
	
	enemy_turn()

func _on_pocion_pressed() -> void:
	if Player.player_potion_counter >= 1:
		Player.player_potion_counter -= 1
		current_player_health = min((Player.current_health + 50), Player.health)
		
		display_text("Usaste una poción")
		await textbox_closed
		
		set_health($player_panel/player_data/ProgressBar, current_player_health, Player.health)
		
		display_text("Te curaste 50 puntos de salud")
		
		enemy_turn()
	else:
		display_text("No te quedan pociones...")
		await textbox_closed

func exp_actualization():
	Player.exp_to_level_up = Player.base_exp * (Player.factor ** (Player.player_level - 1))
