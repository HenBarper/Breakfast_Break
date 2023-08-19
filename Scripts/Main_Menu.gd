extends Node2D

@onready var main_menu_container = $Control/MarginContainer/MainMenuContainer
@onready var option_container = $Control/MarginContainer/OptionContainer
@onready var start_timer = $StartTimer
@onready var quit_timer = $QuitTimer
@onready var color_rect_3 = $ColorRect3


func _on_play_pressed():
	$ButtonPress.play()
	start_timer.start() # After SFX timer load game scene

func _on_options_pressed(): # open options menu
	$ButtonPress.play()
	main_menu_container.visible = false
	color_rect_3.visible = true
	option_container.visible = true

func _on_exit_pressed(): # quit game
	$ButtonPress.play()
	quit_timer.start()

func _on_back_pressed(): # go back from options to main menu
	$ButtonPress.play()
	option_container.visible = false
	color_rect_3.visible = false
	main_menu_container.visible = true


func _on_sfx_slider_drag_ended(value_changed): # play test SFX sound when changing the SFX volume
	$SFXTest.play()

func _on_start_timer_timeout():
	get_tree().change_scene_to_file("res://Scenes/Game_Scene.tscn") # Load level 1

func _on_quit_timer_timeout():
	get_tree().quit() # quit out of game
