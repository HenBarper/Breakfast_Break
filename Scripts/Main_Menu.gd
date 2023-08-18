extends Node2D

@onready var main_menu_container = $Control/MarginContainer/MainMenuContainer
@onready var option_container = $Control/MarginContainer/OptionContainer
@onready var start_timer = $StartTimer
@onready var quit_timer = $QuitTimer


func _on_play_pressed():
	$ButtonPress.play()
	start_timer.start()

func _on_options_pressed():
	$ButtonPress.play()
	main_menu_container.visible = false
	option_container.visible = true

func _on_exit_pressed():
	$ButtonPress.play()
	quit_timer.start()

func _on_back_pressed():
	$ButtonPress.play()
	option_container.visible = false
	main_menu_container.visible = true


func _on_sfx_slider_drag_ended(value_changed):
	$SFXTest.play()

func _on_start_timer_timeout():
	get_tree().change_scene_to_file("res://Scenes/Game_Scene.tscn") #Change to level 1

func _on_quit_timer_timeout():
	get_tree().quit()
