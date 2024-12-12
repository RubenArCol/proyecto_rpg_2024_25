extends Control

signal textbox_closed

@export var enemy_resources:Array = [
	preload("res://recursos_proyecto_godot/graphics/characters/enemies/undead_knight.tres"),
	preload("res://recursos_proyecto_godot/graphics/characters/enemies/bat.tres")
]
@export var enemy:Resource = null

var current_player_health = 0
var current_enemy_health = 0
var defending = false

func _ready():
	randomize()
	enemy = enemy_resources[randi() % enemy_resources.size()]
	
	set_health($enemy_container/ProgressBar, enemy.health, enemy.health)
	$enemy_container/enemy.texture = enemy.texture
	current_enemy_health = enemy.health
	
	set_health($player_panel/player_data/ProgressBar, Player.current_health, Player.health)
	current_player_health = Player.current_health
	
	$text_box.hide()
	$action_panel.hide()
	
	display_text("¡Un %s ha aparecido!" % enemy.name)
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
	display_text("La huida se realizó con éxito¡")
	await textbox_closed
	get_tree().change_scene_to_file("res://recursos_proyecto_godot/maps/firstCave.tscn")


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
		display_text("¡%s ha sido derrotado!" % enemy.name)
		await textbox_closed
		
		$AnimationPlayer.play("enemy_death")
		await get_tree().create_timer(0.5)
		
		display_text("¡Recibiste %d puntos de experiencia!" % enemy.experience)
		await textbox_closed
		
		Player.player_current_exp += enemy.experience
		
		if (Player.player_current_exp >= Player.exp_to_level_up):
			Player.player_level += 1
			display_text("¡Subiste a nivel %d!" % Player.player_level)
			await textbox_closed
			
			exp_actualization()
			
			print("%d es la nueva cantidad de experiencia para subir" % Player.exp_to_level_up)
		
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
		current_player_health = max(0, current_player_health - enemy.damage)
		set_health($player_panel/player_data/ProgressBar, current_player_health, Player.health)

		$AnimationPlayer.play("player_damaged")
		await get_tree().create_timer(0.5)

		display_text("%s realizó %d de daño" % [enemy.name, enemy.damage])
		await textbox_closed


func _on_defensa_pressed() -> void:
	defending = true
	
	display_text("Te defiendes como puedes")
	await textbox_closed
	
	await get_tree().create_timer(0.5)
	
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
