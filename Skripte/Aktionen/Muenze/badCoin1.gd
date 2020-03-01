extends "res://Skripte/Aktionen/Muenze/badCoin_allgemein.gd"

"""
Szene / Klasse für die schlechten Coins Typ 1
Setzt die Coin Spezifischen Variablen

Erbt die Methoden und Variablen von der Super Klasse Muenze
"""

func _ready():
	$Sprite.texture = .lade_bild_von_user("res://Bilder/Standardspielfiguren/Coins/BadCoin1.png");
	coinWert = -1
	cointyp = -1 #repräsentiert Coin (nicht selbst umstellen)
	Geschwindigkeit = 200
	bild_Groesse = einstellungen.figurengroesse["BadCoin1"]
	erstelle_Hitbox()