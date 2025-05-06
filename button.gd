extends Button

@onready var popup = $"../ekspres"

func _ready():
	pressed.connect(_button_pressed)

func _button_pressed():
	popup.popup()
