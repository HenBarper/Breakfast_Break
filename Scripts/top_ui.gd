extends TextureRect

# labels
@onready var score_label = $ScoreLabel
@onready var time_label = $TimeLabel
@onready var move_label = $MoveLabel

# timer vars
var current_score = 0
var current_second = 0
var second_string = "00"
var current_minute = 0
var minute_string = "00"

# move vars
var num_moves = 0

func _ready():
	_on_grid_update_score(current_score)

func _on_grid_update_score(ammount_to_change): # updates the score from grid signal
	current_score += ammount_to_change
	score_label.text = str(current_score)

func _update_time():
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
	print("timer:")
	print(current_second)
	current_second += 1
	if current_second >= 60:
		current_minute += 1
		current_second = 0
	_update_time()

func _process(delta):
	if Input.is_action_just_pressed("ui_touch"):
		_update_time()


func _on_grid_update_moves():
	num_moves += 1
	move_label.text = str(num_moves)
