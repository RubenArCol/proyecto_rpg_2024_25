extends CharacterBody2D

var direccion: Vector2 = Vector2.ZERO
var velocidad:int = 250

func _process(_delta):
	direccion = Input.get_vector("left", "right", "up", "down")
	
	
func _physics_process(_delta):
	velocity = direccion * velocidad
	move_and_slide()
	
