extends Button

@onready var popup = $"../PopupPanel"
@onready var _blacha = $"../../../TileMap/Control/blacha_przycisk"
@onready var _haslo = $"../../../TileMap/Control/komputer_kontrolny/VBoxContainer/zatwierdz_haslo"
@onready var _kawa = $"../../../TileMap/Control/ekspres_przycisk"
@onready var _cyfry = $"../../../TileMap/Control/komputer_cyferki_przycisk"
@onready var info = $"../PopupPanel/info"

func _ready():
	pressed.connect(_button_pressed)
	
func _button_pressed():
	popup.popup()
	if _blacha.czy_zdobyta && _haslo.czy_poprawne && _kawa.czy_zrobiona && _cyfry.czy_przepisane: #1111
		info.text = "Zdobyłeś blachę pokrywową i podałeś poprawne hasło. Ucieczka udała się."
		#await(get_tree().create_timer(3))
		var timer = get_tree().create_timer(2)
		await timer.timeout
		get_tree().quit()
		
	elif _blacha.czy_zdobyta && _haslo.czy_poprawne && _kawa.czy_zrobiona && !_cyfry.czy_przepisane: #1110
		info.text = "Hiob odmawia wejścia na pokład przed przepisaniem danych na odpowiedni komputer."
	elif _blacha.czy_zdobyta && _haslo.czy_poprawne && !_kawa.czy_zrobiona && _cyfry.czy_przepisane: #1101
		info.text = "Hiob odmawia wejścia na pokład przed zaparzeniem kawy."
	elif _blacha.czy_zdobyta && !_haslo.czy_poprawne && _kawa.czy_zrobiona && _cyfry.czy_przepisane: #1011
		info.text = "Musisz jeszcze podać poprawne hasło."
	elif !_blacha.czy_zdobyta && _haslo.czy_poprawne && _kawa.czy_zrobiona && _cyfry.czy_przepisane: #0111
		info.text = "Musisz jeszcze uszczelnić szalupę ratunkową."
		
	elif _blacha.czy_zdobyta && _haslo.czy_poprawne && !_kawa.czy_zrobiona && !_cyfry.czy_przepisane: #1100
		info.text = "Hiob odmawia wejścia na pokład przed zaparzeniem kawy i przepisaniem danych na odpowiedni komputer."
	elif _blacha.czy_zdobyta && !_haslo.czy_poprawne && _kawa.czy_zrobiona && !_cyfry.czy_przepisane: #1010
		info.text = "Musisz jeszcze podać poprawne hasło. Ponadto, Hiob odmawia wejścia na pokład przed przepisaniem danych na odpowiedni komputer."
	elif _blacha.czy_zdobyta && !_haslo.czy_poprawne && !_kawa.czy_zrobiona && _cyfry.czy_przepisane: #1001
		info.text = "Musisz jeszcze podać poprawne hasło. Ponadto, Hiob odmawia wejścia na pokład przed zaparzeniem kawy."
	elif !_blacha.czy_zdobyta && _haslo.czy_poprawne && _kawa.czy_zrobiona && !_cyfry.czy_przepisane: #0110
		info.text = "Musisz jeszcze uszczelnić szalupę ratunkową. Ponadto, Hiob odmawia wejścia na pokład przed przepisaniem danych na odpowiedni komputer."
	elif !_blacha.czy_zdobyta && _haslo.czy_poprawne && !_kawa.czy_zrobiona && _cyfry.czy_przepisane: #0101
		info.text = "Musisz jeszcze uszczelnić szalupę ratunkową. Ponadto, Hiob odmawia wejścia na pokład przed zaparzeniem kawy."
	elif !_blacha.czy_zdobyta && !_haslo.czy_poprawne && _kawa.czy_zrobiona && _cyfry.czy_przepisane: #0011
		info.text = "Musisz jeszcze podać poprawne hasło i uszczelnić szalupę ratunkową."
		
	elif _blacha.czy_zdobyta && !_haslo.czy_poprawne && !_kawa.czy_zrobiona && !_cyfry.czy_przepisane: #1000
		info.text = "Musisz jeszcze podać poprawne hasło. Ponadto, Hiob odmawia wejścia na pokład przed zaparzeniem kawy i przepisaniem danych na odpowiedni komputer."
	elif !_blacha.czy_zdobyta && _haslo.czy_poprawne && !_kawa.czy_zrobiona && !_cyfry.czy_przepisane: #0100
		info.text = "Musisz jeszcze uszczelnić szalupę ratunkową. Ponadto, Hiob odmawia wejścia na pokład przed zaparzeniem kawy i przepisaniem danych na odpowiedni komputer."
	elif !_blacha.czy_zdobyta && !_haslo.czy_poprawne && _kawa.czy_zrobiona && !_cyfry.czy_przepisane: #0010
		info.text = "Musisz jeszcze podać poprawne hasło i uszczelnić szalupę ratunkową. Ponadto, Hiob odmawia wejścia na pokład przed przepisaniem danych na odpowiedni komputer."
	elif !_blacha.czy_zdobyta && !_haslo.czy_poprawne && !_kawa.czy_zrobiona && _cyfry.czy_przepisane: #0001
		info.text = "Musisz jeszcze podać poprawne hasło i uszczelnić szalupę ratunkową. Ponadto, Hiob odmawia wejścia na pokład przed zaparzeniem kawy."
		
	elif !_blacha.czy_zdobyta && !_haslo.czy_poprawne && !_kawa.czy_zrobiona && !_cyfry.czy_przepisane: #0000
		info.text = "Musisz jeszcze podać poprawne hasło i uszczelnić szalupę ratunkową. Ponadto, Hiob odmawia wejścia na pokład przed zaparzeniem kawy i przepisaniem danych na odpowiedni komputer."
#1114610119
