extends Button

@onready var popup = $"../ekspres"
var czy_zrobiona = false

func _ready():
	pressed.connect(_button_pressed)

func _button_pressed():
	czy_zrobiona = true
	popup.popup()
