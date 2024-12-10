extends CharacterBody2D

var direccion:Vector2 = Vector2.ZERO
var velocidad:int = 30
var movement:bool = true

# player's inventory
@export var inv: Inv 
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

func _ready() -> void:
	var tp_nodes = get_tree().get_nodes_in_group("Teleports") # gets every tp in the group
	for tp_node in tp_nodes:
		tp_node.connect("tp", Callable(self, "toggle_movement")) # connects the function to the player

func _physics_process(_delta):
	if movement:
		velocity = direccion * velocidad
		direccion = Input.get_vector("left", "right", "up", "down") # direction

		# animations
		if direccion != Vector2.ZERO:
			sprite_2d.play("run")
			# player's looking direction
			sprite_2d.flip_h = direccion.x < 0
		else: # player idle
			sprite_2d.play("idle")
	else:
		direccion = Vector2.ZERO # doesn't allow changing direction
		velocity = Vector2.ZERO # doesn't allow movement
		sprite_2d.play("idle") # Cuando no se puede mover, poner idle
	move_and_slide()

func toggle_movement():
	movement = not movement # Toggle movement state
	await wait(1.2)
	movement = not movement # Toggle movement state back to true

func wait(tiempo: float) -> void: # stack overflow ;3
	var timer = Timer.new()  # new timer
	timer.one_shot = true    # one use only
	timer.wait_time = tiempo # set timer to "tiempo"
	add_child(timer)         # add timer
	timer.start()
	await timer.timeout      # wait for ending
	timer.queue_free()       # deletes the timer after ending
