extends "res://Skripte/Aktionen/Muenze/badCoin_allgemein.gd"

"""
Szene / Klasse für die schlechten Coins Typ 2
Setzt die Coin Spezifischen Variablen

Erbt die Methoden und Variablen von der Super Klasse Muenze
"""

func _ready():
	$Sprite.texture = .lade_bild_von_user("res://Bilder/Standardspielfiguren/Coins/BadCoin2.png");
	coinWert = -2
	cointyp = -2 #repräsentiert Coin (nicht selbst umstellen)
	Geschwindigkeit = 150
	bild_Groesse = einstellungen.figurengroesse["BadCoin2"]
	erstelle_Hitbox()



