extends Node
signal interacted

var dialog_message = preload("res://dialog/DialogMessage.tscn")
export var message : String

func interact():
	var dialog = dialog_message.instance()
	dialog.message = message
	dialog.resume_on_close = true
	dialog.connect("closed", self, "_on_Dialog_closed")
	add_child(dialog)
	
func _on_Dialog_closed():
	emit_signal("interacted")