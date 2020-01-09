extends "res://Skripte/Aktionen/Muenze/Muenze.gd"
"""
Szene / Klasse für alle guten Coins
Beinhaltet alle Methoden (ausgelöst durch Random) die für
beide goodCoin Klassen benötigt werden

Erbt die Methoden und Variablen von der Super Klasse muenze
"""


"""
Methode zum verändern der Flugbahn der Münze, 
sodass sie in Richtung des Spielers fliegt

--> es wird die X Entfernung von der Münze durch die Boden Höhe der Münze gerechnet 
um eine passende Geschwindigkeit in Blob Richtung zu errechnen

@param xPosSpieler die XPosition des Spielers
"""

func muenzMagnet(var xPosSpieler):
	
	var differenz = xPosSpieler - position.x
	
	var bewegung = (differenz / bodenhoehe)*1000
	
	if xPosSpieler < position.x:
		Bewegung.x = bewegung
	elif xPosSpieler > position.x:
		Bewegung.x = bewegung
	else:
		Bewegung.x = 0
