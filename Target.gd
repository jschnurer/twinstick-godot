extends StaticBody2D

var health = 1

func take_damage(amount):
	health -= amount
	if health <= 0:
		queue_free()