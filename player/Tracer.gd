extends Line2D

var velocity = Vector2(0, 0)
var start_point = Vector2(0, 0)
var end_point = Vector2(0, 0)
var ray_length = 500
export var shot_spread = 32
var damage = 1

func _ready():
	if velocity == Vector2(0, 0):
		queue_free()
		return
	
	discover_collision()
	
	if end_point == start_point:
		queue_free()
		return
	
	draw()
	$Tween.interpolate_property(self, "modulate", modulate, Color(1, 1, 1, 0), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

func discover_collision():
	$Ray.cast_to = start_point + velocity * ray_length + Vector2(rand_range(-shot_spread, shot_spread), rand_range(-shot_spread, shot_spread))
	$Ray.force_update_transform()
	$Ray.force_raycast_update()
	if !$Ray.is_colliding():
		end_point = $Ray.cast_to
		return
	
	var collider = $Ray.get_collider()
	end_point = to_local($Ray.get_collision_point())
	
	if collider.is_in_group("terrain"):
		return
	
	if collider.is_in_group("damageable"):
		collider.take_damage(damage)

func draw():
	add_point(start_point)
	add_point(end_point)

func _on_Tween_tween_all_completed():
	queue_free()
