extends Navigation2D

var dialog_scene = preload("res://dialog/DialogMessage.tscn")
var what_was_that_shown = false

func _ready():
	for child_node in $Enemies.get_children():
		child_node.connect("killed", self, "_on_Enemy_killed")

func _on_Enemy_killed(enemy):
	if !what_was_that_shown:
		what_was_that()

func what_was_that():
	what_was_that_shown = true
	var dialog = dialog_scene.instance()
	dialog.message = "What the hell was that giant eye thing?! Are these things coming out of the EnigmaTech facility?"
	get_parent().add_child(dialog)