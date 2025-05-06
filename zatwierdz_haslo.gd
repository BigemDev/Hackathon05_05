extends Button

@onready var linia = $"../LineEdit"
@onready var odp = $"../odpowiedz"
var czy_poprawne = false

func _ready():
	pressed.connect(_button_pressed)

func _button_pressed():
	var tekst = linia.text
	print(tekst)
	if tekst == "1114610119":
		odp.text = "poprawne hasło"
		czy_poprawne = true
	else:
		odp.text = "niepoprawne hasło"
