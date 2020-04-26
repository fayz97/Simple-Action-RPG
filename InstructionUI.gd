extends Label

export var is_show_instruction = true

func _ready():
	if !is_show_instruction:
		self.hide()

func close():
	self.is_show_instruction = false
	self.hide()
