extends KinematicBody2D

var speed = 400
var velocity = Vector2(0, 0)
var damage = 1

func _ready():
	if velocity.x > 0:
		if velocity.y < 0:
			rotation_degrees = -45
		elif velocity.y > 0:
			rotation_degrees = 45
	elif velocity.x < 0:
		if velocity.y < 0:
			rotation_degrees = -135
		elif velocity.y > 0:
			rotation_degrees = 135
		else:
			rotation_degrees = 180
	else:
		if velocity.y < 0:
			rotation_degrees = -90
		elif velocity.y > 0:
			rotation_degrees = 90

func _physics_process(_delta):
	movement_loop(_delta)

func movement_loop(_delta):
	var collision = move_and_collide(velocity.normalized() * speed * _delta)
	
	if collision:
		if collision.collider.is_in_group("terrain"):
			queue_free()
		elif collision.collider.is_in_group("shootable"):
			queue_free()
			if collision.collider.has_method("take_damage"):
				collision.collider.take_damage(damage)
