extends Button

@onready var popup = $"../biblia"
var czy_zdobyta = false

func _ready():
	pressed.connect(_button_pressed)

func _button_pressed():
	czy_zdobyta = true
	popup.popup()
