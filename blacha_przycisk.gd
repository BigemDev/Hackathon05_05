extends Button

@onready var popup = $"../blacha"
var czy_zdobyta = false

func _ready():
	pressed.connect(_button_pressed)

func _button_pressed():
	popup.popup()
	czy_zdobyta = true
