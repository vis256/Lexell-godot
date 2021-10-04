extends Node2D

var dir setget dir_set

func dir_set(val):
	dir = val

func _physics_process(delta):
	var collision = $Bullet.move_and_collide(dir * delta)
	if $Bullet.global_position.y > 1800:
		get_node("..").addToReturned()
		queue_free()
	if collision:
		if collision.collider.name == "BlockStaticBody2D":
			get_node("..")._fixTimer.stop()
			get_node("..")._fixTimer.start()
			collision.collider.get_node("../").decreaseHp()
		var reflect = collision.remainder.bounce(collision.normal)
		dir = dir.bounce(collision.normal)
		$Bullet.move_and_collide(reflect)

func sendToRandom(baseSpeed):
	var rx = float(randi() % 100) / float(100)
	var ry = float(randi() % 100) / float(100)
	dir_set(Vector2(rx * baseSpeed, ry * baseSpeed))
