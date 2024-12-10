extends Control

@onready var main_menu = $VBoxContainer
@onready var options_popup = $OptionsPopup
@onready var volume_slider = $OptionsPopup/vboxOpciones/sldVolumen
@onready var vbox_options = $OptionsPopup/vboxOpciones
@onready var controls_popup = $ControlsPopup

var current_action: String = ""
var key_string: String = ""
var customizable = false

enum actions {up, down, left, right, interaction, pause, inventory}

func _ready():
	main_menu.get_child(0).grab_focus()
	update_action_keys()

func _on_btn_inicio_pressed() -> void:
	get_tree().change_scene_to_file("res://recursos_proyecto_godot/maps/firstCave.tscn")


func _interact_button(event: InputEvent) -> void:
	if event.is_action_pressed("interaction"):
		var focused = get_tree().get_focus_owner()  # obtains selected node
		if focused and focused.is_class("Button"):  # if its a button the interact button acts as "enter"
			focused.emit_signal("pressed")

func _on_btn_salir_pressed() -> void:
	get_tree().quit()

func _on_btn_opciones_pressed() -> void:
	options_popup.popup_centered()

func _on_sld_volumen_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)

func _on_btn_cerrar_pressed() -> void:
	options_popup.hide()

func _on_btn_movimiento_pressed() -> void:
	options_popup.hide()
	controls_popup.popup_centered()

func _on_btn_cerrar_controles_pressed() -> void:
	controls_popup.hide()

###################### Bloque de codigo no implementado todavia ######################################


func update_action_keys():
	for input_action in actions:
		var action_name = str(input_action)
		var action_button = get_node("ControlsPopup/VBoxControles/HBox_" + action_name + "/Button")
		action_button.set_pressed(false)
		if InputMap.has_action(action_name):
			var action_events = InputMap.action_get_events(action_name)
			if not action_events.is_empty():
				action_button.text = action_events[0].as_text()
			else:
				action_button.text = "?????"

func _on_button_pressed() -> void:
	toggle_action_button(actions.up)

func _on_down_button_pressed() -> void:
	toggle_action_button(actions.down)

func _on_left_button_pressed() -> void:
	toggle_action_button(actions.left)

func _on_right_button_pressed() -> void:
	toggle_action_button(actions.right)

func _on_int_button_pressed() -> void:
	toggle_action_button(actions.interaction)

func _on_pause_button_pressed() -> void:
	toggle_action_button(actions.pause)

func _on_inv_button_pressed() -> void:
	toggle_action_button(actions.inventory)

func toggle_action_button(value):
	var action_key = actions.find_key(value)
	
	customizable = true
	key_string = str(action_key)
	
	for input_action in actions:
		if input_action != action_key:
			var control = input_action
			get_node("ControlsPopup/VBoxControles/HBox_" + control + "/Button").set_pressed(false)
			

func _input(event):
	if event is InputEventKey and customizable:
		change_action_button(event)
		customizable = false

func change_action_button(new_key):
	var action_events = InputMap.action_get_events(key_string)
	
	if not action_events.is_empty():
		InputMap.action_erase_event(key_string, action_events[0])
	
	for i in actions:
		if InputMap.action_has_event(i, new_key):
			InputMap.action_erase_event(i, new_key)
	
	InputMap.action_add_event(key_string, new_key)
	
	update_action_keys()

#############################################################################################
