extends Button

@onready var linia = $"../LineEdit"
@onready var odp = $"../odpowiedz"

func _ready():
	pressed.connect(_button_pressed)

func _button_pressed():
	var tekst = linia.text
	print(tekst)
	if tekst == "1114610119":
		odp.text = "poprawne hasło"
	else:
		odp.text = "niepoprawne hasło"
