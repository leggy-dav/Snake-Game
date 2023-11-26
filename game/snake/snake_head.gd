extends Node2D

@export var tail_obj: PackedScene
@export var food_value = 3

var start_position
var move_direction: Vector2
var previous_position: Vector2

var food_points: int
var tail_array = Array()

var game_manager: Node2D

var can_move = false


# MIGHT HAVE TO MAKE A MOVE BUFFER

func _ready():
	start_position = position
	move_direction = Vector2.ZERO
	food_points = food_value
	game_manager = $"../Game_Manager"
	


func _process(delta):
	get_input()


func toggle_can_move():
	can_move = !can_move


func get_input():
	if can_move:
		if Input.is_action_pressed("move_up") and valid_move(Vector2.UP):
			move_direction = Vector2.UP
		if Input.is_action_pressed("move_down") and valid_move(Vector2.DOWN):
			move_direction = Vector2.DOWN
		if Input.is_action_pressed("move_left") and valid_move(Vector2.LEFT):
			move_direction = Vector2.LEFT
		if Input.is_action_pressed("move_right") and valid_move(Vector2.RIGHT):
			move_direction = Vector2.RIGHT
		pass


func valid_move(direction: Vector2):
	if (position + (direction * 16)) == previous_position:
		return false
	if direction == move_direction * -1:
		return false
	return true


func move():
	previous_position = position
	if (move_direction != Vector2.ZERO):
		var new_position = position + (move_direction * 16)
		# check for food
		if new_position == game_manager.get_food_position():
			# play eating sound
			$"../CrunchSound".play()
			food_points += food_value
			game_manager.delete_food()
			game_manager.add_food()
		
		grow_tail()
		
		if check_tail_position(new_position):
			# print('TAILED!!!')
			game_manager.game_over()
		
		# Check for walls
		if game_manager.check_tile_wall(game_manager.tileMap_local_position(new_position)):
			# print('Hit Wall!!!')
			game_manager.game_over()
		else:
			position += move_direction * 16
			for obj in tail_array:
				obj.move()


func grow_tail():
	if food_points > 0:
		food_points -= 1
		var new_tail = tail_obj.instantiate()
		if tail_array.size() > 0:
			new_tail.position = tail_array.back().position
			new_tail.set_parent(tail_array.back())
		else:
			new_tail.set_parent(self)
			new_tail.position = position
		
		get_node('/root/Main').add_child(new_tail)
		tail_array.append(new_tail)


func clear_tail():
	for elem in tail_array:
		elem.queue_free()
	tail_array = Array()
	food_points = food_value
	


func reset_snake():
	clear_tail()
	position = start_position
	move_direction = Vector2.ZERO
	can_move = false


func get_move_direction():
	return move_direction


func get_previous_position():
	return previous_position


func check_tail_position(pos):
	for obj in tail_array:
		if pos == obj.position:
			return true
	return false


func _on_timer_turn_timeout():
	pass # Replace with function body.
	move()
