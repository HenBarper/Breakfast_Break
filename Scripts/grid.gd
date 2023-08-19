extends Node2D

# timers
@onready var destroy_timer = $"../destroy_timer"
@onready var collapse_timer = $"../collapse_timer"
@onready var refill_timer = $"../refill_timer"

# grid variables
@export var width: int
@export var height: int
@export var x_start: int
@export var y_start: int
@export var offset: int

# SFX
@onready var swap_sfx = $"../swapSFX"
@onready var match_sfx = $"../matchSFX"

# piece array
var possible_pieces = [
	preload("res://Scenes/blue_piece.tscn"),
	preload("res://Scenes/green_piece.tscn"),
	preload("res://Scenes/light_green_piece.tscn"),
	preload("res://Scenes/orange_piece.tscn"),
	preload("res://Scenes/pink_piece.tscn"),
	preload("res://Scenes/yellow_piece.tscn")
]

# current pieces in the scene
var all_pieces = []

# touch variables
var first_touch = Vector2(0, 0)
var final_touch = Vector2(0, 0)
var controlling = false

func _ready():
	randomize()
	all_pieces = make_2d_array() # Sets all the pieces of the array to a variable
	spawn_pieces()

func make_2d_array():
	var array = []
	for i in width: # appends an array per column
		array.append([])
		for j in height: # appends an item per row
			array[i].append(null)
	return array

func spawn_pieces():
	for i in width:
		for j in height:
			var rand = floor(randf_range(0, possible_pieces.size())) # choose a random number and store it
			var piece = possible_pieces[rand].instantiate() # Instantiate that piece from the array
			var loops = 0
			while match_at(i, j, piece.color) && loops < 100: #check for match-3s before spawning in piece
				rand = floor(randf_range(0, possible_pieces.size()))
				loops += 1
				piece = possible_pieces[rand].instantiate()
			add_child(piece) # Adds piece to grid as child of grid
			piece.position = grid_to_pixel(i, j) # Sets the position of the piece to the next position in the grid
			all_pieces[i][j] = piece # sets the element of the 2d array to the piece at that position

func match_at(column, row, color): # check the surrounding piece to see if their spawning would cause a match
	if column > 1: # if there are pieces to the left
		if all_pieces[column - 1][row] != null && all_pieces[column - 2][row] != null:
			if all_pieces[column - 1][row].color == color && all_pieces[column - 2][row].color == color:
				return true
	if row > 1:
		if all_pieces[column][row - 1] != null && all_pieces[column][row - 2] != null:
			if all_pieces[column][row - 1].color == color && all_pieces[column][row - 2].color == color:
				return true

func grid_to_pixel(column, row): # Sets the position of the new piece
	var new_x = x_start + offset * column
	var new_y = y_start + -offset * row
	return Vector2(new_x, new_y) # return the new position

func pixel_to_grid(pixel_x, pixel_y): # translate pixel screen posiiton to grid position
	var new_x = round((pixel_x - x_start) / offset) # pemdas baybee
	var new_y = round((pixel_y - y_start) / -offset)
	return Vector2(new_x, new_y)

func is_in_grid(grid_position): # checks if the clicked position if within the grid of pieces
	if grid_position.x >= 0 && grid_position.x < width:
		if grid_position.y >= 0 && grid_position.y < height:
			return true
	return false

func touch_input(): # register click inputs
	if Input.is_action_just_pressed("ui_touch"):
		if is_in_grid(pixel_to_grid(get_global_mouse_position().x, get_global_mouse_position().y)): # checks if the click is in the grid
			first_touch = pixel_to_grid(get_global_mouse_position().x, get_global_mouse_position().y) # sets a var with the click pos
			controlling = true
		else:
			controlling = false
	if Input.is_action_just_released("ui_touch"):
		if is_in_grid(pixel_to_grid(get_global_mouse_position().x, get_global_mouse_position().y)) && controlling: # checks if the unclick is in the grid and the previous click was in the grid
			controlling = false
			final_touch = pixel_to_grid(get_global_mouse_position().x, get_global_mouse_position().y) # sets a var with the unlick pos
			swap_sfx.play() # PLAY SFX
			touch_difference(first_touch, final_touch) # gets the direction from click to unclick

func swap_pieces(column, row, direction):
	print("sawpping pieces")
	var first_piece = all_pieces[column][row] # sets the first selection
	var other_piece = all_pieces[column + direction.x][row + direction.y] # sets the second piece
	if first_piece != null && other_piece != null:
		all_pieces[column][row] = other_piece # sets the first piece to be the second piece
		all_pieces[column + direction.x][row + direction.y] = first_piece # sets the second piece to be first piece
#		first_piece.position = grid_to_pixel(column + direction.x, row + direction.y) # moves the 1st piece
#		other_piece.position = grid_to_pixel(column, row) # moves the second piece
		first_piece.move(grid_to_pixel(column + direction.x, row + direction.y)) # TWEEN VERSION
		other_piece.move(grid_to_pixel(column, row)) # TWEEN VERSION
		find_matches()

func touch_difference(grid_1, grid_2): # find the direction of mouse drag to use for swapping pieces
	print("checking touch dif")
	var difference = grid_2 - grid_1
	if abs(difference.x) > abs(difference.y):
		if difference.x > 0:
			swap_pieces(grid_1.x, grid_1.y, Vector2(1, 0))
		elif difference.x < 0:
			swap_pieces(grid_1.x, grid_1.y, Vector2(-1, 0))
	elif abs(difference.y) > abs(difference.x):
		if difference.y > 0:
			swap_pieces(grid_1.x, grid_1.y, Vector2(0, 1))
		elif difference.y < 0:
			swap_pieces(grid_1.x, grid_1.y, Vector2(0, -1))

func _process(delta): # _process runs every frame
	touch_input() # check for input eavery frame update

func find_matches():
	print("finding matches")
	for i in width: # check each column
		for j in height: # check each row
			if all_pieces[i][j] != null: # check that the current piece exists
				var current_color = all_pieces[i][j].color # set color of current piece
				if i > 0 && i < width - 1:
					if all_pieces[i - 1][j] != null && all_pieces[i + 1][j] != null: # check that 3 pieces in a row exist
						if all_pieces[i - 1][j].color == current_color && all_pieces[i + 1][j].color == current_color: # check that the colors match
							all_pieces[i - 1][j].matched = true
							all_pieces[i - 1][j].dim()
							all_pieces[i][j].matched = true
							all_pieces[i][j].dim()
							all_pieces[i + 1][j].matched = true
							all_pieces[i + 1][j].dim()
							match_sfx.play()
							#destroy_timer.start() # starts the timer that checks for matched pieces to destroy
				if j > 0 && j < height - 1:
					if all_pieces[i][j - 1] != null && all_pieces[i][j + 1] != null: # check that 3 pieces in a row exist
						if all_pieces[i][j - 1].color == current_color && all_pieces[i][j + 1].color == current_color: # check that the colors match
							all_pieces[i][j - 1].matched = true
							all_pieces[i][j - 1].dim()
							all_pieces[i][j].matched = true
							all_pieces[i][j].dim()
							all_pieces[i][j + 1].matched = true
							all_pieces[i][j + 1].dim()
							match_sfx.play()
							#destroy_timer.start() # starts the timer that checks for matched pieces to destroy
	destroy_timer.start() # starts the timer that checks for matched pieces to destroy

func destroy_matched(): # looks through all pieces and destroys ones marked matched
	print("destroying matches")
	for i in width:
		for j in height:
			if all_pieces[i][j] != null: # if the current piece isn't null
				if all_pieces[i][j].matched: # and it's marked matched
					all_pieces[i][j].queue_free() # destroy it
					all_pieces[i][j] = null # set the piece's space to null
					collapse_timer.start() # check for pieces to move down
	#print("past collapse timer")

func collapse_columns(): # looks through all the pieces for empty spaces and moves down the next piece up
	print("collapsing columns")
	for i in width:
		for j in height:
			if all_pieces[i][j] == null: # if the current piece isn't null
				for k in range(j + 1, height): # check each piece above it
					if all_pieces[i][k] != null: # if that piece isn't null
#						all_pieces[i][k].position = grid_to_pixel(i, j) # move it down
						all_pieces[i][k].move(grid_to_pixel(i, j)) #TWEEN VERSION
						all_pieces[i][j] = all_pieces[i][k] # set the current space to the moved down piece
						all_pieces[i][k] = null # set the above space to null
						#find_matches()
						break
	refill_timer.start()
						
func refill_columns():
	for i in width:
		for j in height:
			if all_pieces[i][j] == null:
				var rand = floor(randf_range(0, possible_pieces.size())) # choose a random number and store it
				var piece = possible_pieces[rand].instantiate() # Instantiate that piece from the array
				var loops = 0
				while match_at(i, j, piece.color) && loops < 100: #check for match-3s before spawning in piece
					rand = floor(randf_range(0, possible_pieces.size()))
					loops += 1
					piece = possible_pieces[rand].instantiate()
				add_child(piece) # Adds piece to grid as child of grid
				piece.position = grid_to_pixel(i, j) # Sets the position of the piece to the next position in the grid
				all_pieces[i][j] = piece
	find_matches()

func _on_destroy_timer_timeout(): # runs .5 seconds after matches are checked for
	#print("destroy timer started")
	destroy_matched() 

func _on_collapse_timer_timeout():
	#print("Collapse timer started")
	collapse_columns()

func _on_refill_timer_timeout():
	refill_columns()
