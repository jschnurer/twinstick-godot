extends KinematicBody2D

var nav : Navigation2D
var dude
var path : PoolVector2Array
var target_ix : int
var current_point
var target_direction : Vector2
var velocity : Vector2
var speed : int = 75

func _ready():
	dude = get_parent().get_node("Dude")
	nav = get_parent()

func _physics_process(delta):
	if !nav:
		return
	
	get_new_path()
	move_along_path(delta)

func get_new_path():
	path = nav.get_simple_path(position, dude.position)
	target_ix = 0
	current_point = path[target_ix]
	
	if current_point == position && path.size() > 1:
		target_ix = 1
		current_point = path[target_ix]

func move_along_path(delta):
	if current_point:
		if current_point.distance_to(position) > 0:
			velocity = (current_point - position).normalized() * speed
			move_and_slide(velocity)
		else:
			if target_ix < path.size() - 1:
				target_ix += 1
				current_point = path[target_ix]
			else:
				current_point = null