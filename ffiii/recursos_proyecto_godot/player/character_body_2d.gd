extends CharacterBody2D

var direccion:Vector2 = Vector2.ZERO
var velocidad:int = 100
var movement:bool = true

func _process(_delta):
	if movement: 
		direccion = Input.get_vector("left", "right", "up", "down")
	else:
		direccion = Vector2.ZERO
	

func _physics_process(_delta):
	if movement:
		velocity = direccion * velocidad
	else:
		velocity = Vector2.ZERO
	move_and_slide()

func toggle_movement():
	movement = not movement
	await wait(1.2)
	movement = not movement

func wait(tiempo: float) -> void: # gracias stack overflow ;3
	var timer = Timer.new()  # Crear un nuevo Timer
	timer.one_shot = true    # Para que solo se dispare una vez
	timer.wait_time = tiempo # Configurar el tiempo de espera
	add_child(timer)         # Añadir el Timer a la escena
	timer.start()            # Iniciar el Timer
	await timer.timeout      # Esperar a que termine
	timer.queue_free()       # Eliminar el Timer después de usarlo
