extends Sprite

var dialog_message = preload("res://dialog/DialogMessage.tscn")
export var no_card_message : String = ""
export var card_message : String = ""
export var gate_already_open_message : String = ""

func interact():
	if get_parent().is_gate_open:
		show_message(gate_already_open_message)
	elif get_parent().has_keycard:
		show_message(card_message)
		get_parent().get_node("Gate").queue_free()
	else:
		show_message(no_card_message)

func show_message(msg):
	var dialog = dialog_message.instance()
	dialog.message = no_card_message
	dialog.resume_on_close = true
	add_child(dialog)