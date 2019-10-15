extends Area2D
var fade_in = preload("res://Utilities/FadeIn.tscn")

export var level_scene : PackedScene

func _on_LevelTransition_body_entered(body):
	if body.is_in_group("player"):
		start()

func start():
	get_tree().paused = true
	
	var cl = get_node("CanvasLayer")
	var fd = cl.get_node("Fade")
	
	$Tween.interpolate_property(fd, "color", fd.color, Color.black, 1.25, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

func _on_Tween_tween_all_completed():
	# load new scene, add it as child
	var lvl = level_scene.instance()
	get_tree().root.add_child(lvl)
	
	# remove old level
	var old_lvl = get_tree().root.get_node("Level")
	get_tree().root.remove_child(old_lvl)
	old_lvl.call_deferred("free")
	
	# fade in
	var fade = fade_in.instance()
	lvl.add_child(fade)
	fade.start()