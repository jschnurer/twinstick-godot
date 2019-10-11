extends Sprite

var dialog_message = preload("res://dialog/DialogMessage.tscn")

func interact():
	var dialog = dialog_message.instance()
	dialog.message = "This dead dude looks like a scientist. Could he be from EnigmaTech? Are they who caused all this? The facility is up north. I should check it out."
	dialog.resume_on_close = true
	add_child(dialog)