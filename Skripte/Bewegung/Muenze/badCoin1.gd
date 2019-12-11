extends "res://Skripte/Bewegung/Muenze/Muenze.gd"

"""
Szene / Klasse für die schlechten Coins Typ 1
Setzt die Coin Spezifischen Variablen

Erbt die Methoden und Variablen von der Super Klasse Muenze
"""

func _ready():
	coinWert = -1
	Geschwindigkeit = 200


"""
Methode um Badcoin vom Regenschirm verschwinden zu lassen
"""
func blockiereMuenze():
	queue_free()