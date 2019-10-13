extends Node2D
signal room_cleared

export var area_node_path = ""
onready var area = get_node(area_node_path)
var event_fired = false

func _ready():
	if !area:
		queue_free()

func find_enemies(node):
	for child_node in node.get_children():
		if child_node.is_in_group("enemies"):
			return true
		elif child_node.get_child_count() > 0:
			if(find_enemies(child_node)):
				return true
	return false

func _on_CheckTimer_timeout():
	if !find_enemies(area):
		$CheckTimer.stop()
		emit_signal("room_cleared")
		queue_free()
		print("fired")
