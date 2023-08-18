extends Node2D

@onready var main_menu_container = $Control/MarginContainer/MainMenuContainer
@onready var option_container = $Control/MarginContainer/OptionContainer


func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/Game_Scene.tscn") #Change to level 1

func _on_options_pressed():
	main_menu_container.visible = false
	option_container.visible = true

func _on_exit_pressed():
	get_tree().quit()

func _on_music_pressed():
	pass # Replace with function body.

func _on_sfx_pressed():
	pass # Replace with function body.

func _on_back_pressed():
	option_container.visible = false
	main_menu_container.visible = true
