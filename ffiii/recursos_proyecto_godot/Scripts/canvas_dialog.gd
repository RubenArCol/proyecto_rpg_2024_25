extends CanvasLayer

signal textbox_closed

func _ready():
	$text_box.hide()

func _input(event: InputEvent):
	if (Input.is_action_just_pressed("interaction") or Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and $text_box.visible):
		$text_box.hide()
		emit_signal("textbox_closed")

func display_text(text, text2):
	$text_box.show()
	$text_box/Label2.text = text2
	$text_box/Label.text = text
