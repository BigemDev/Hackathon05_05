extends Button

@onready var popup = $"../komputer_kontrolny"

func _ready():
	pressed.connect(_button_pressed)

func _button_pressed():
	popup.popup()
