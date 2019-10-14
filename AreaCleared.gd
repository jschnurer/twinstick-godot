extends Node2D
signal area_cleared
signal enemy_added
signal enemy_killed

export var area_node_path = ""
onready var area = get_node(area_node_path)
var event_fired = false
var prev_num_enemies = 0
var num_enemies = 0

func _ready():
	if !area:
		queue_free()

func find_enemies(node):
	prev_num_enemies = num_enemies
	
	var num = 0
	for child_node in node.get_children():
		if child_node.is_in_group("enemies"):
			num += 1
		elif child_node.get_child_count() > 0:
			if(find_enemies(child_node)):
				num += 1
	
	num_enemies = num
	return num_enemies > 0

func _on_CheckTimer_timeout():
	if !find_enemies(area):
		$CheckTimer.stop()
		emit_signal("area_cleared")
		queue_free()
	else:
		print (str("Prev: ", prev_num_enemies, ", Now: ", num_enemies))
		if num_enemies > prev_num_enemies:
			emit_signal("enemy_added")
		elif num_enemies < prev_num_enemies:
			emit_signal("enemy_killed")