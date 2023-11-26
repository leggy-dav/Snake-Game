extends Node2D


var move_direction: Vector2 = Vector2.ZERO
var can_move = false
var tail_parent: Node2D
var previous_position: Vector2


func _ready():
	pass

func _process(delta):
	pass


func set_parent(obj):
	tail_parent = obj


func get_previous_position():
	return previous_position

func move():
	previous_position = position
	position = tail_parent.get_previous_position()
	# move_direction = tail_parent.get_move_direction()
