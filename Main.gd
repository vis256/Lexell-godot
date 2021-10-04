extends Control

onready var World = preload("World.gd").new()

class PlayerClass:
	var hp = 1
	var bullets = 1

var Player = PlayerClass.new()


var is_dragging = false
var touchpos = 0
var dir: Vector2
var rem = 0
var returned = 0
var turn = 0
var activeZone = 0
var bulletCannonPos = Vector2(540, 1800)
var baseSpeed = 1300
var canSend = true
var toFixShit = true

var bulletscn = load("res://Bullet.tscn")
var _timer = null
var _startTimer = null
var _fixTimer = null


var helpscn = load("res://AimBullet.tscn")
var help0
var help1
var help2
var help3 
var help4
var help5
var help6
var help7

var blockscn = load("res://scenes/Block.tscn")
var lifeblockscn = load("res://scenes/LifeBlock.tscn")
const blockLeftPadding = 0

func _ready():
	randomize()
	help0 = helpscn.instance()
	help1 = helpscn.instance()
	help2 = helpscn.instance()
	help3 = helpscn.instance()
	help4 = helpscn.instance()
	help5 = helpscn.instance()
	help6 = helpscn.instance()
	help7 = helpscn.instance()
	add_child(help0)
	add_child(help1)
	add_child(help2)
	add_child(help3)
	add_child(help4)
	add_child(help5)
	add_child(help6)
	add_child(help7)
	
	World.newData(0)
	_timer = Timer.new()
	add_child(_timer)
	
	_timer.connect("timeout", self, "_on_Timer_timeout")
	_timer.set_wait_time(0.1)
	_timer.set_one_shot(false)
	
	_startTimer = Timer.new()
	add_child(_startTimer)
	
	_startTimer.connect("timeout", self, "nextTurn")
	_startTimer.set_wait_time(1)
	_startTimer.set_one_shot(true)
	_startTimer.start()
	
	_fixTimer = Timer.new()
	add_child(_fixTimer)
	_fixTimer.connect("timeout", self, "fixBulletsStuckInInfiniteLoop")
	_fixTimer.set_wait_time(15)
	_fixTimer.set_one_shot(true)

func _on_Timer_timeout():
	var new_bullet = bulletscn.instance()
	new_bullet.position = bulletCannonPos
	new_bullet.dir_set( dir )
	add_child(new_bullet)
	rem -= 1
	if rem == 0:
		_timer.stop()
		

			

				
var swipe_start = Vector2(0,0)
var minimum_drag = 100

func updateHelper(pos):
	var dir = (swipe_start - pos).normalized()
	#print(dir)
	if dir.x > -0.98 and dir.x < 0.98 and pos.y > swipe_start.y:
		help0.position = bulletCannonPos + dir
		help1.position = bulletCannonPos + dir * (baseSpeed * 0.1)
		help2.position = bulletCannonPos + dir * (baseSpeed * 0.2)
		help3.position = bulletCannonPos + dir * (baseSpeed * 0.3)
		help4.position = bulletCannonPos + dir * (baseSpeed * 0.4)
		help5.position = bulletCannonPos + dir * (baseSpeed * 0.5)
		help6.position = bulletCannonPos + dir * (baseSpeed * 0.6)
		help7.position = bulletCannonPos + dir * (baseSpeed * 0.7)
	else:
		help0.position = bulletCannonPos + dir
		help1.position = bulletCannonPos + dir * (baseSpeed * 0.02)
		help2.position = bulletCannonPos + dir * (baseSpeed * 0.04)
		help3.position = bulletCannonPos + dir * (baseSpeed * 0.06)
		help4.position = bulletCannonPos + dir * (baseSpeed * 0.08)
		help5.position = bulletCannonPos + dir * (baseSpeed * 0.1)
		help6.position = bulletCannonPos + dir * (baseSpeed * 0.12)
		help7.position = bulletCannonPos + dir * (baseSpeed * 0.14)
		

func _input(event):
	var tpos = get_global_mouse_position()
	updateHelper(tpos)
	
	if event is InputEventScreenTouch and canSend:
		if event.is_pressed():
			$StartHelper.position = tpos
			print("swipe started")
			swipe_start = tpos
		else:
			print("swipe ended")
			_calculate_swipe(tpos)
			$StartHelper.position = Vector2(-1000, -1000)
	
		
func _calculate_swipe(swipe_end):
	returned = 0
	if swipe_start == null: 
		return
	var swipe = swipe_start - swipe_end
	dir = swipe.normalized()
	if dir.x > -0.98 and dir.x < 0.98 and swipe_end.y > swipe_start.y:
		dir.x *= baseSpeed
		dir.y *= baseSpeed
		rem = Player.bullets
		_timer.start()
		_fixTimer.start()
		canSend = false

func addToReturned():
	returned += 1
	$RichTextLabel.bbcode_text = "[center]" + str(Player.bullets - returned) + "[/center]"
	if returned == Player.bullets:
		canSend = true
		$RichTextLabel.bbcode_text = ""
		nextTurn()

		
func addBullet():
	Player.bullets += 1
	returned += 1
	$BulletLabel.bbcode_text = "[center]" + str(Player.bullets) + "[/center]"

func nextTurn():
	turn += 1
	
	for i in self.get_children():
		if "Block" in i.name:
			i.global_position.y += 108
			if i.global_position.y > 108 * 16:
				print("GAME OVER")
	var newRow = World.worldList.pop_front()
	print(len(World.worldList))
	var new_block
	for i in range(10):
		if newRow[i] == null or typeof(newRow[i]) == 2:
			continue
		elif newRow[i][0] == "block":
			new_block = blockscn.instance()
		elif newRow[i][0] == "lifeblock":
			new_block = lifeblockscn.instance()
		new_block.position = Vector2(blockLeftPadding + (i * 108), 0)
		new_block.hp_set( newRow[i][1] )
		add_child(new_block)
	if turn == 30:
		World.newData(1)

func fixBulletsStuckInInfiniteLoop():
	print("fix")
	for i in self.get_children():
		if "Bullet" in i.name:
			if i.name != "BulletLabel":
				i.sendToRandom(baseSpeed)
