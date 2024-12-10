extends Control

@onready var main_menu = $VBoxContainer
@onready var options_popup = $OptionsPopup
@onready var volume_slider = $OptionsPopup/vboxOpciones/sldVolumen
@onready var vbox_options = $OptionsPopup/vboxOpciones

func _ready():
	main_menu.get_child(0).grab_focus()

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
