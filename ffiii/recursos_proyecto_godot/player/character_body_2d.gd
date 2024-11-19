extends CharacterBody2D

var direccion:Vector2 = Vector2.ZERO
var velocidad:int = 100
var movement:bool = true

func _ready() -> void:
	var tp_nodes = get_tree().get_nodes_in_group("Teleports") # gets every tp in the group
	for tp_node in tp_nodes:
		tp_node.connect("tp", Callable(self, "toggle_movement")) # connects the function to the player

func _process(_delta):
	if movement: 
		direccion = Input.get_vector("left", "right", "up", "down") # direction
	else:
		direccion = Vector2.ZERO # doesn't allow changing direction
	

func _physics_process(_delta):
	if movement:
		velocity = direccion * velocidad 
	else:
		velocity = Vector2.ZERO # doesn't allow movement
	move_and_slide()

func toggle_movement():
	movement = not movement # movement to false
	await wait(1.2)
	movement = not movement # movement to true

func wait(tiempo: float) -> void: # stack overflow ;3
	var timer = Timer.new()  # new timer
	timer.one_shot = true    # one use only
	timer.wait_time = tiempo # set timer to "tiempo"
	add_child(timer)         # add timer
	timer.start()
	await timer.timeout      # wait for ending
	timer.queue_free()       # deletes the timer after ending
