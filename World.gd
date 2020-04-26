extends Node2D

onready var instruction = $CanvasLayer/InstructionUI
onready var pauseScreen = $CanvasLayer/PauseScreen

func _input(event):
	if event.is_action_pressed("close_instruction"):
		if instruction.is_show_instruction == true:
			instruction.close()
		else:
			pauseScreen.pause()


func _on_Player_player_die():
	get_tree().change_scene("res://Scenes/GameOver.tscn")
