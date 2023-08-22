extends TextureRect

@onready var sfx_test = $SFXTest
@onready var master_slider = $master_slider

# labels
@onready var score_label = $ScoreLabel
@onready var time_label = $TimeLabel
@onready var move_label = $MoveLabel
@onready var goal_label = $GoalLabel

# game over
@onready var title_text = $"../GAME_OVER/Title_text"
@onready var game_over = $"../GAME_OVER"
@onready var game_over_text = $"../GAME_OVER/game_over_text"
@onready var sad_bears = $"../GAME_OVER/Sad_bears"
@onready var happy_bears = $"../GAME_OVER/happy_bears"

# SFX
@onready var game_over_sfx = $"../gameOverSFX"
@onready var win_sfx = $"../winSFX"

# pause
var paused = false
@onready var pause_block = $pause_block
@onready var grid = $"../grid"

# score variables
var current_score = 0
var goal_score = 2000
signal goal_reached
var has_won = false
@onready var progress = $progress
@onready var texture_progress_bar = $TextureProgressBar

# time variables
var current_second = 0
var second_string = "00"
var current_minute = 3
var minute_string = "03"
signal time_up
var has_timed_out = false

# move variables
var num_moves = 50
signal out_moves
var has_no_moves = false

func _ready():
	progress.max_value = goal_score
	texture_progress_bar.max_value = goal_score
	var goal_format_string = "Goal: %s"
	var goal_string = goal_format_string % str(goal_score)
	goal_label.text = goal_string
	_on_grid_update_score(current_score)

func _on_grid_update_score(ammount_to_change): # updates the score from grid signal
	current_score += ammount_to_change
	score_label.text = str(current_score)
	progress.value = current_score
	texture_progress_bar.value = current_score

func _update_time():
	if current_second < 0:
		current_second = 0
	var second_format_string = ""
	var minute_format_string = ""
	var time_format_string = ""
	var time_string = ""
	if current_second < 10:
		second_format_string = "0%s"
		second_string = second_format_string % str(current_second)
	else:
		second_string = str(current_second)
	if current_minute < 10:
		minute_format_string = "0%s"
		minute_string = minute_format_string % str(current_minute)
	else:
		minute_string = str(current_minute)
	
	time_format_string = "%s:%s"
	time_string = time_format_string % [minute_string, second_string]
	time_label.text = time_string

func _on_timer_timeout():
	if !paused && !has_won && !has_no_moves:
		current_second -= 1
		if current_second <= 0:
			if current_minute > 0:
				current_minute -= 1
				current_second = 59
		_update_time()

func _process(delta):
	if current_score >= goal_score && !has_won:
		set_true_conditions() # set all win/lose conditions to true so they won't be called again
		emit_signal("goal_reached")
		print("GOAL REACHED")
		title_text.text = "YOU WIN!"
		game_over.visible = true
		happy_bears.visible = true
		game_over_text.text = "YOU WIN!!!"
		win_sfx.play()
	if current_minute <= 0 && current_second <= 0 && !has_timed_out:
		set_true_conditions() # set all win/lose conditions to true so they won't be called again
		emit_signal("time_up")
		print("TIME UP")
		title_text.text = "GAME OVER..."
		game_over.visible = true
		sad_bears.visible = true
		game_over_text.text = "You ran out of time..."
		game_over_sfx.play()
	if num_moves <= 0 && !has_no_moves:
		set_true_conditions() # set all win/lose conditions to true so they won't be called again
		emit_signal("out_moves")
		print("OUT OF MOVES")
		title_text.text = "GAME OVER..."
		game_over.visible = true
		sad_bears.visible = true
		game_over_text.text = "You ran out of moves..."
		game_over_sfx.play()

func set_true_conditions():  # set all win/lose conditions to true so they won't be called again
	has_won = true
	has_timed_out = true
	has_no_moves = true

func _on_grid_update_moves():
	num_moves -= 1
	move_label.text = str(num_moves)

func _on_sfx_slider_drag_ended(value_changed):
	sfx_test.play()

func _on_retry_pressed():
	get_tree().change_scene_to_file("res://Scenes/Game_Scene.tscn") # Load level 1

func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/Main_Menu.tscn") # Load main menu

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Main_Menu.tscn") # Load main menu

func _on_pause_button_pressed():
	if paused:
		paused = false
		pause_block.visible = false
		grid.set_move()
	else:
		paused = true
		pause_block.visible = true
		grid.set_wait()
