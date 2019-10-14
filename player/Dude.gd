extends KinematicBody2D

var tracer_scene = preload("res://player/Tracer.tscn")

var velocity = Vector2(0, 0)
var speed = 160
var shoot_velocity = Vector2(0, 0)
var is_shooting = false
var is_shoot_cooling = false
var is_run_cooling = false
var is_running = false
var stamina_max = 3
var stamina = 3

func _ready():
	$ProgressBar.max_value = stamina_max
	$ProgressBar.value = stamina

func _process(_delta):
	$ProgressBar.value = stamina

func _physics_process(_delta):
	if !is_running:
		stamina = clamp(stamina + _delta * 0.8, 0, stamina_max)
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
	
	if Input.is_action_just_pressed("run") && !is_run_cooling:
		is_running = true
	elif Input.is_action_just_released("run"):
		stop_running()
	
	if !is_running:
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
	var spd = speed
	if is_running:
		stamina -= delta
		spd *= 1.85
		if stamina <= 0:
			stop_running()
			
# warning-ignore:return_value_discarded
	move_and_slide(velocity.normalized() * spd)

func shoot_bullet():
	if !is_shooting || is_shoot_cooling || shoot_velocity == Vector2(0, 0):
		return
	
	is_shooting = false
	
	var tracer = tracer_scene.instance()
	tracer.position = position + Vector2(14 * shoot_velocity.x, 14 * shoot_velocity.y)
	tracer.velocity = shoot_velocity
	get_parent().add_child(tracer)
	get_parent().move_child(tracer, 1)
	
	is_shoot_cooling = true
	$ShootCooldown.start()

func sprite_loop():
	$Eyes.position = Vector2(velocity.x * 3, 0)
	$Eyes.visible = velocity.y >= 0
	$Mouth.visible = $Eyes.visible

func stop_running():
	is_running = false
	is_run_cooling = true
	$RunCooldown.start()

func _on_ShootCooldown_timeout():
	is_shoot_cooling = false

func _on_RunCooldown_timeout():
	is_run_cooling = false