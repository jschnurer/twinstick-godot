extends CanvasLayer

signal closed

onready var label = $Panel/MarginContainer/Label
onready var button_prompt = $Panel/MarginContainer/ButtonPrompt

export var message = ""
export var resume_on_close = true
var controls_enabled = false

func _ready():
	get_tree().paused = true
	label.text = message
	$Tween.interpolate_property(label, "percent_visible", 0, 1, message.length() / 35.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

func _process(delta):
	if !controls_enabled && Input.is_action_just_released("action"):
		controls_enabled = true
		return
		
	if controls_enabled && Input.is_action_just_released("action"):
		emit_signal("closed")
		if resume_on_close:
			queue_free()
			get_tree().paused = false
	
func _on_Tween_tween_all_completed():
	button_prompt.visible = true
