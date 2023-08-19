extends Node2D

@export var color: String
var matched = false
#var move_tween

#func _ready():
#	move_tween = get_tree().create_tween().bind_node(self)
#	move_tween.set_trans(Tween.TRANS_ELASTIC)
#	move_tween.set_ease(Tween.EASE_OUT)

func move(target):
	var move_tween = get_tree().create_tween().bind_node(self) # creates a tween and binds it to this piece
	move_tween.set_trans(Tween.TRANS_ELASTIC) # sets the translate mode
	move_tween.set_ease(Tween.EASE_OUT) # sets the ease mode
	move_tween.tween_property(self, "position", target, 0.5) # calls the animation

func dim():
	var sprite = get_node("Sprite2D")
	sprite.modulate  = Color(1, 1, 1, 0.5)
	pass
