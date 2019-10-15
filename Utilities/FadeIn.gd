extends CanvasLayer

func start():
	var fd = get_node("Fade")
	$Tween.interpolate_property(fd, "color", fd.color, Color(0, 0, 0, 0), 1.25, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

func _on_Tween_tween_all_completed():
	get_tree().paused = false
	queue_free()
