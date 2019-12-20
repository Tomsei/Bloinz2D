extends "user://Skripte/Aktionen/Muenze/goodCoin_allgemein.gd"

"""
Szene / Klasse für die guten Coins Typ 2
Setzt die Coin Spezifischen Variablen

Erbt die Methoden und Variablen von der Super Klasse goodCoin_allgemein
"""

func _ready():
	$Sprite.texture = .lade_bild_von_user("user://Bilder/Standardspielfiguren/Coins/GoodCoin1.png");
	coinWert = 2
	Geschwindigkeit = 200


