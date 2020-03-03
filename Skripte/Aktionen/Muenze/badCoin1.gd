extends "res://Skripte/Aktionen/Muenze/badCoin_allgemein.gd"

#Szene / Klasse für die schlechten Coins Typ 1
#Setzt die Coin Spezifischen Variablen

#Erbt die Methoden und Variablen von der Super Klasse badCoin_allgemein
#-> somit auch von Muenze (Vererbungshierarchie)

""" ------------------------------------------------------------ """
""" Jaa stimmt keiner Mag Punkt Abzug. Tricks das Spiel aus      """
""" Anstelle eines Punktabzuges sollen Punkte hinzugefügt werden """
""" ------------------------------------------------------------ """
#Methode Wird beim instanzieren aufgerufen (Konstruktor)
#Die Münze wird als bad Coin 1 erstellt
func _ready():
	$Sprite.texture = .lade_bild_von_user("res://Bilder/Standardspielfiguren/Coins/BadCoin1.png");
	coinWert = -1
	geschwindigkeit = 200
	bild_Groesse = einstellungen.figurengroesse["BadCoin1"]
	erstelle_Hitbox()