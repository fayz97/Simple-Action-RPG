extends Control

signal continued

func _ready():
	self.connect("continued", self, "_on_continued")

func pause():
	visible = true
	get_tree().paused = true


func _input(event):
	if event.is_action_pressed("ui_accept"):
		visible = false
		get_tree().paused = false
