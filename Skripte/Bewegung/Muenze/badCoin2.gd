extends "res://Skripte/Bewegung/Muenze/Muenze.gd"

"""
Szene / Klasse für die schlechten Coins Typ 2
Setzt die Coin Spezifischen Variablen

Erbt die Methoden und Variablen von der Super Klasse Muenze
"""

func _ready():
	coinWert = -2
	Geschwindigkeit = 150


func blockiereMuenze():
	queue_free()