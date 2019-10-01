extends KinematicBody2D

var bullet_scene = preload("res://Bullet.tscn")

var velocity = Vector2(0, 0)
var speed = 160
var shoot_velocity = Vector2(0, 0)
var is_shooting = false
var is_cooling_down = false

func _ready():
	pass

func _physics_process(_delta):
	controls_loop()
	movement_loop(_delta)
	shoot_bullet()
	sprite_loop()

func controls_loop():
	velocity = Vector2(0, 0)
	shoot_velocity = Vector2(0, 0)
	
	if Input.is_action_pressed('right'):
		velocity.x += 1
	if Input.is_action_pressed('left'):
		velocity.x -= 1
	if Input.is_action_pressed('down'):
		velocity.y += 1
	if Input.is_action_pressed('up'):
		velocity.y -= 1
	
	if Input.is_action_pressed('shoot_right'):
		shoot_velocity.x += 1
		is_shooting = true
	if Input.is_action_pressed('shoot_left'):
		shoot_velocity.x -= 1
		is_shooting = true
	if Input.is_action_pressed('shoot_down'):
		shoot_velocity.y += 1
		is_shooting = true
	if Input.is_action_pressed('shoot_up'):
		shoot_velocity.y -= 1
		is_shooting = true

func movement_loop(delta):
	move_and_slide(velocity.normalized() * speed)

func shoot_bullet():
	if !is_shooting || is_cooling_down || shoot_velocity == Vector2(0, 0):
		return
	
	is_shooting = false
	var bullet = bullet_scene.instance()
	bullet.position = position + Vector2(21 * shoot_velocity.x, 21 * shoot_velocity.y)
	bullet.velocity = shoot_velocity
	get_parent().add_child(bullet)
	start_cooldown()

func sprite_loop():
	$Eyes.position = Vector2(velocity.x * 3, 0)
	$Eyes.visible = velocity.y >= 0
	$Mouth.visible = $Eyes.visible

func start_cooldown():
	is_cooling_down = true
	$ShootCooldown.start()

func _on_ShootCooldown_timeout():
	is_cooling_down = false
