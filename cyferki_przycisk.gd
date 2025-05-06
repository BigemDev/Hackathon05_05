extends Button

@onready var popup = $"../cyferki"
var czy_przepisane = false

func _ready():
	pressed.connect(_button_pressed)

func _button_pressed():
	popup.popup()
