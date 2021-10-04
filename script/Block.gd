extends Node2D

var hp setget hp_set

func setText(val):
	if hp < 10000:
		$BlockStaticBody2D/RichTextLabel.bbcode_text = "[center]" + str(val) + "[/center]"
		# [center]12345[/center]
	else:
		$BlockStaticBody2D/RichTextLabel.bbcode_text = "[center]" + str(val % 1000) + 'k' + "[/center]"

func hp_set(val):
	hp = val
	setText(val)

#func _ready():
	
func decreaseHp():
	hp -= 1
	if hp < 1:
		destroyBlock()
	setText(hp)
	

func destroyBlock():
	queue_free()
	
