extends CanvasLayer

signal closed

onready var label = $Panel/MarginContainer/Label
onready var button_prompt = $Panel/MarginContainer/ButtonPrompt
onready var tween = $Tween

export var message = ""
export var resume_on_close = true
var controls_enabled = false

func _ready():
	get_tree().paused = true
	label.text = message
	tween.interpolate_property(label, "percent_visible", 0, 1, message.length() / 35.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()

func _process(delta):
	if Input.is_action_just_pressed("action"):
		if button_prompt.visible:
			close()
		else:
			finish()

func close():
	emit_signal("closed")
	if resume_on_close:
		queue_free()
		get_tree().paused = false

func finish():
	tween.stop(label)
	label.percent_visible = 1
	button_prompt.visible = true

func _on_Tween_tween_all_completed():
	button_prompt.visible = true
