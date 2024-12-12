extends Area2D

var open = false
var player_in_area = false
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_area = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_area = false

func _process(_delta):
	if player_in_area and Input.is_action_just_pressed("interaction") and not open:
		open_chest()

func open_chest():
	print("pulsado")
	animated_sprite_2d.play("closedopen")
	open = true
	print("%d pociones antes de cofre" % Player.player_potion_counter)
	Player.player_potion_counter += 1
	print("%d pociones despues de cofre" % Player.player_potion_counter)
	animated_sprite_2d.play("open")
