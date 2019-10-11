extends Area2D

onready var orig_hint_positions = [$Hint.rect_position, $Hint.rect_position + Vector2(0, 5)]
onready var hint_positions = [$Hint.rect_position, $Hint.rect_position + Vector2(0, 5)]

func _process(_delta):
	if !$Hint.visible:
		return
	
	if Input.is_action_just_pressed("action"):
		interact()

func interact():
	var p = get_parent()
	if p.has_method("interact"):
		p.interact()

func display_hint():
	$Hint.visible = true
	
	hint_positions[0] = orig_hint_positions[0]
	hint_positions[1] = orig_hint_positions[1]
	
	$Tween.stop_all()
	$Tween.interpolate_property($Hint,
		"rect_position",
		orig_hint_positions[0],
		orig_hint_positions[1],
		1,
		Tween.TRANS_SINE,
		Tween.EASE_IN_OUT)
	$Tween.start()

func hide_hint():
	$Hint.visible = false
	$Tween.stop_all()

func _on_InteractableHint_body_entered(body):
	if body.is_in_group("dude"):
		display_hint()

func _on_InteractableHint_body_exited(body):
	if body.is_in_group("dude"):
		hide_hint()

func _on_Tween_tween_completed(_object, _key):
	hint_positions.invert()
	$Tween.interpolate_property($Hint,
		"rect_position",
		hint_positions[0],
		hint_positions[1],
		1,
		Tween.TRANS_SINE,
		Tween.EASE_IN_OUT)
	$Tween.start()
