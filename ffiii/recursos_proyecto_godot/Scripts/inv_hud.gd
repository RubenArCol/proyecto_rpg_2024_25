extends Control

var is_open = false

func _ready():
	visible = is_open # starting as false

func _process(delta):
	if Input.is_action_just_pressed("inventory"):
		show_inv()

# show and hide inventory
func show_inv():
	visible = !is_open
	is_open = visible
