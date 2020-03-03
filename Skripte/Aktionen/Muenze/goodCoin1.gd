extends "res://Skripte/Aktionen/Muenze/goodCoin_allgemein.gd"

#Szene / Klasse für die guten Coins Typ 1
#Setzt die Coin Spezifischen Variablen

#Erbt die Methoden und Variablen von der Super Klasse goodCoin_allgemein
#-> somit auch von Muenze (Vererbungshierarchie)

#Methode Wird beim instanzieren aufgerufen (Konstruktor)
#Die Münze wird als Good Coin 1 erstellt
func _ready():
	$Sprite.texture = .lade_bild_von_user("res://Bilder/Standardspielfiguren/Coins/GoodCoin1.png");
	coinWert = 1
	geschwindigkeit = 100
	bild_Groesse = einstellungen.figurengroesse["GoodCoin1"]
	erstelle_Hitbox()
	


