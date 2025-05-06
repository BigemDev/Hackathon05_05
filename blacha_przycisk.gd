extends Button

@onready var popup = $"../blacha"

func _ready():
	pressed.connect(_button_pressed)

func _button_pressed():
	popup.popup()
