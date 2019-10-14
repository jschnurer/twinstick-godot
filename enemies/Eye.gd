extends KinematicBody2D
signal killed

var dir_sprite = preload("res://images/enemies/eye/eye_left.png")
var nav : Navigation2D
export var nav_node_path : String
var dude
export var dude_node_path : String
var path : PoolVector2Array
var target_ix : int
var current_point
var target_direction : Vector2
var velocity : Vector2
var speed : int = 75
var health = 3
var is_active = false

func _ready():
	dude = get_node(dude_node_path)
	nav = get_node(nav_node_path)

func _physics_process(delta):
	if !nav:
		return
	
	if is_active:
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
			update_sprite(current_point)
		else:
			if target_ix < path.size() - 1:
				target_ix += 1
				current_point = path[target_ix]
			else:
				current_point = null

func update_sprite(target_point):
	if target_point == position:
		return
	
	rotation = (current_point - position).angle() + 135

func take_damage(amount):
	health -= amount
	if health <= 0:
		queue_free()
		emit_signal("killed", self)
	else:
		show_damage()
	
	if !is_active:
		become_active()

func show_damage():
	if $Tween.is_processing():
		$Tween.stop()
	$Tween.interpolate_property(self, "modulate", Color(1, 0, 0, 1), Color(1, 1, 1, 1), .15, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

func become_active():
	is_active = true
	$Sprite.texture = dir_sprite
	$Detection.queue_free()

func _on_Detection_body_entered(body):
	if body == dude:
		become_active()