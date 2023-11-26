extends CanvasLayer

var game_manager

signal start_game


func _ready():
	game_manager = $"../Game_Manager"
	print(game_manager)


func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()


func show_game_over():
	show_message("Game Over")
	
	await  get_tree().create_timer(2.0).timeout
	
	$MessageLabel.text = "Play Again!"
	$MessageLabel.show()
	
	await get_tree().create_timer(1.0).timeout
	$Button.show()
	


func update_score(score):
	$ScoreLabel.text = str(score)


func _on_button_pressed():
	$Button.hide()
	$MessageLabel.hide()
	
	game_manager.reset_game()
	game_manager.start_game()
	
	pass # Replace with function body.

