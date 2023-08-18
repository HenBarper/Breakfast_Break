extends Node2D

# grid variables
@export var width: int
@export var height: int
@export var x_start: int
@export var y_start: int
@export var offset: int

var possible_pieces = [
	preload("res://Scenes/blue_piece.tscn"),
	preload("res://Scenes/green_piece.tscn"),
	preload("res://Scenes/light_green_piece.tscn"),
	preload("res://Scenes/orange_piece.tscn"),
	preload("res://Scenes/pink_piece.tscn"),
	preload("res://Scenes/yellow_piece.tscn")
]

var all_pieces = []

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
			add_child(piece) # Adds piece to grid as child of grid
			piece.position = grid_to_pixel(i, j) # Sets the position of the piece to the next position in the grid

func grid_to_pixel(column, row): # Sets the position of the new piece
	var new_x = x_start + offset * column
	var new_y = y_start + -offset * row
	return Vector2(new_x, new_y) # return the new position
