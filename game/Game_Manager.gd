extends Node2D

@export var food: PackedScene

var hud
var snakeHead
var tileMap: TileMap
var current_food_obj: Node2D
var score = 0

var map_width: int
var map_height: int

var map_offset_x: int
var map_offset_y: int

var rng = RandomNumberGenerator.new()

# food objects should be able to tell game manager when they got ate
# when food get eated it goes away and a new piece of food is placed in the 
# world
# food cannot be place on the snake
# if there is not where for food to be placed then the player wins
# there needs to be a minimume of 3 spaces for food to be place
# assuming the tail grows three places when food is eated


func _ready():
	snakeHead = $"../SnakeHead"
	tileMap = $"../TileMap"
	hud = $"../HUD"
	
	
	map_offset_x = tileMap.transform.origin.x
	map_offset_y = tileMap.transform.origin.y
	
	
	add_food()
	#for cel in tileMap.get_used_cells(0):
	#	print(cel, '\t', )
	
	# TODO: get tilemap size to be used for randomly placing food
	
	set_pre_start()


func reset_game():
	snakeHead.reset_snake()


func set_pre_start():
	hud.update_score(score)
	hud.show_message("Snake!")


func start_game():
	score = 0
	hud.update_score(score)
	snakeHead.toggle_can_move()
	$"../TimerTurn".start()


func game_over():
	$"/root/Main/TimerTurn".stop()
	hud.show_game_over()
	
	

func random_tile():
	
	var tile_array = tileMap.get_used_cells(0)
	var rand_tile = tile_array[rng.randf_range(0, tile_array.size())]
	
	rand_tile = tile_array[rng.randf_range(0, tile_array.size())]
	return rand_tile
	

func get_tile_global_position(tile):
	var obj_position = tileMap.map_to_local(tile)
	obj_position.x += map_offset_x
	obj_position.y += map_offset_y
	return obj_position


func add_food():
	score += 10
	hud.update_score(score)
	var rand_tile = random_tile()
	var obj_position = get_tile_global_position(rand_tile)
	
	while not check_empty_tile(rand_tile, obj_position):
		rand_tile = random_tile()
		obj_position = get_tile_global_position(rand_tile)
	
	current_food_obj = food.instantiate()
	current_food_obj.position = obj_position
	
	add_child(current_food_obj)
	pass


func delete_food():
	remove_child(current_food_obj)


func get_food_position():
	if current_food_obj:
		return current_food_obj.position
	return null



func _on_timer_turn_timeout():
	pass # Replace with function body.


func check_tile_wall(pos):
	
	var data = tileMap.get_cell_tile_data(0, tileMap.local_to_map(pos))
	if data:
		return data.get_custom_data("wall")
	else:
		return 0


func check_empty_tile(tile, pos):
	
	var data = tileMap.get_cell_tile_data(0, tile)
	
	if data:
		if data.get_custom_data("wall"):
			return false
	
	if snakeHead.check_tail_position(pos):
		return false

	return true


func tileMap_local_position(pos):
	return tileMap.to_local(pos)



func _input(event):
	
	if event is InputEventMouseButton and event.pressed:
		print( event)
		print('\t', check_tile_wall(tileMap.get_local_mouse_position()))


