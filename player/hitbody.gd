extends Area2D

func _on_area_entered(area):
	Player.lose_game()
