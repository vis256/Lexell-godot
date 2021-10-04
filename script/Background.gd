extends Node2D

var _timer = null
var arr = []
var c = 0

func _ready():
	for i in self.get_children():
		arr.append(true)
		i.modulate = Color(1,1,1, float(randi() % 255) / float(255))
	_timer = Timer.new()
	get_children()[0].add_child(_timer)
	
	_timer.connect("timeout", self, "_on_Timer_timeout")
	_timer.set_wait_time(0.05)
	_timer.set_one_shot(false)
	_timer.start()

func _on_Timer_timeout():
	c = 0
	for i in self.get_children():
		var alpha = i.modulate.a
		if arr[c] == true:
			alpha += 0.015
		else:
			alpha -= 0.015
		if alpha < 0.001 or alpha > 0.999:
			arr[c] = !arr[c]
		i.modulate = Color(1,1,1,alpha)
		c += 1
		
