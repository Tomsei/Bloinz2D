extends "res://Skripte/Bewegung/Muenze/Muenze.gd"
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
	
	#Bestimmten der X Entfernung zum Spieler
	var differenz = xPosSpieler - position.x
	
	#Bestimmen der Geschwindigkeit mit hilfe der Münz Höhe
	var bewegung = (differenz / (position.x-bodenhoehe))*1000
	
	#Die Bewegung zum Spieler auf die Münze setzen
	if xPosSpieler == position.x:
		Bewegung.x = 0
	else:
		Bewegung.x = bewegung
	