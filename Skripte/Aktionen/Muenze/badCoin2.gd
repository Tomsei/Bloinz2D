extends "res://Skripte/Aktionen/Muenze/badCoin_allgemein.gd"

#Szene / Klasse für die schlechten Coins Typ 2
#Setzt die Coin Spezifischen Variablen

#Erbt die Methoden und Variablen von der Super Klasse badCoin_allgemein 
#-> somit auch von Muenze (Vererbungshierarchie)

#Methode Wird beim instanzieren aufgerufen (Konstruktor)
#Die Münze wird als bad Coin 2 erstellt
func _ready():
	$Sprite.texture = .lade_bild_von_user("res://Bilder/Standardspielfiguren/Coins/BadCoin2.png");
	coinWert = -2
	geschwindigkeit = 150
	bild_Groesse = einstellungen.figurengroesse["BadCoin2"]
	erstelle_Hitbox()



