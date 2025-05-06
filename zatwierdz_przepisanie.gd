extends Button

@onready var linia = $"../LineEdit"
@onready var odp = $"../Label"
var czy_przepisane = false

func _ready():
	pressed.connect(_button_pressed)

func _button_pressed():
	var tekst = linia.text
	print(tekst)
	if tekst == "a:1233 grt:661 w:jyipi 3:jyip tl:37142":
		odp.text = "poprawne dane"
		czy_przepisane = true
	else:
		odp.text = "niepoprawne dane"
