extends Node2D

onready var instruction = $CanvasLayer/InstructionUI

func _input(event):
	if event.is_action_pressed("close_instruction"):
		instruction.close()


func _on_Player_player_die():
	get_tree().change_scene("res://Scenes/GameOver.tscn")
