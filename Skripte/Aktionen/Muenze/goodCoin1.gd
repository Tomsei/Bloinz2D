extends "res://Skripte/Aktionen/Muenze/goodCoin_allgemein.gd"

"""
Szene / Klasse für die guten Coins Typ 1
Setzt die Coin Spezifischen Variablen

Erbt die Methoden und Variablen von der Super Klasse goodCoin_allgemein
"""

func _ready():
	$Sprite.texture = .lade_bild_von_user("res://Bilder/Standardspielfiguren/Coins/GoodCoin1.png");
	coinWert = 1
	cointyp = 1 #repräsentiert Coin (nicht selbst umstellen)
	Geschwindigkeit = 100
	bild_Groesse = 20
	bild_Groesse = einstellungen.figurengroesse["GoodCoin1"]
	erstelle_Hitbox()
	


