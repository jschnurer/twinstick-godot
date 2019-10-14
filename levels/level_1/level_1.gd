extends Navigation2D

var dialog_scene = preload("res://dialog/DialogMessage.tscn")
var what_was_that_shown = false
var has_keycard = false
var is_gate_open = false

func _ready():
	for child_node in $Enemies.get_children():
		child_node.connect("killed", self, "_on_Enemy_killed")
	show_intro_text()

func show_intro_text():
	var dialog = dialog_scene.instance()
	dialog.message = "Ouch! That was one hell of a car crash. What is going on in this city!? At least I have my trusty pistol. I can shoot it using the arrow keys."
	add_child(dialog)

func _on_Enemy_killed(enemy):
	if !what_was_that_shown:
		what_was_that()

func what_was_that():
	what_was_that_shown = true
	var dialog = dialog_scene.instance()
	dialog.message = "What the?! Are these things coming out of the EnigmaTech facility?"
	add_child(dialog)

func _on_KeyReader_gate_opened():
	get_node("Gate").queue_free()
	is_gate_open = true

func _on_ScientistWithKeycard_interacted():
	has_keycard = true
