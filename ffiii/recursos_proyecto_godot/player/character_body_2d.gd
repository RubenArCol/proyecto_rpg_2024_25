extends CharacterBody2D

var direccion:Vector2 = Vector2.ZERO
var velocidad:int = 30
var movement:bool = true

#player's stats
var player_level:int = 1
var player_current_exp = 0
var health = 50 + (3 * player_level)
var current_health = health
var player_dmg = 20 + (3 * player_level)
var player_potion_counter = 1 # set to 1 for debugging

var exp_to_level_up = 0

# player's inventory
@export var inv: Inv 
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

func _ready() -> void:
	exp_to_level_up = 100 + (50 * (player_level - 1))
	
	var tp_nodes = get_tree().get_nodes_in_group("Teleports") # gets every tp in the group
	for tp_node in tp_nodes:
		tp_node.connect("tp", Callable(self, "toggle_movement")) # connects the function to the player

func _physics_process(_delta):
	if movement:
		velocity = direccion * velocidad
		direccion = Input.get_vector("left", "right", "up", "down") # direction

		# animations
		if direccion != Vector2.ZERO:
			if (sprite_2d):
				sprite_2d.play("run")
				# player's looking direction
				sprite_2d.flip_h = direccion.x < 0
		else: # player idle
			if (sprite_2d):
				sprite_2d.play("idle")
	else:
		direccion = Vector2.ZERO # doesn't allow changing direction
		velocity = Vector2.ZERO # doesn't allow movement
		sprite_2d.play("idle") # idle  in case the player is standing still
	move_and_slide()

func toggle_movement():
	movement = not movement # Toggle movement state
	await get_tree().create_timer(1.2)
	movement = not movement # Toggle movement state back to true
