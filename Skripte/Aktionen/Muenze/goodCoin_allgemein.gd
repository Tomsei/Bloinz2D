extends "res://Skripte/Aktionen/Muenze/Muenze.gd"

#Szene / Klasse für alle guten Coins
#Beinhaltet alle Methoden die für beide goodCoin Klassen benötigt werden
#--> Münmagnet zieht beide guten Münzen an

#Erbt die Methoden und Variablen von der Super Klasse muenze




#Methode zum verändern der Flugbahn der Münze, sodass sie in Richtung des Spielers fliegt
#--> Bewegungsrichtung zum Blob wird ermittelt und als Bewegung gesetzt
#
#@param x_Position_Spieler die XPosition des Spielers

""" -------------------------------------------------- """
""" Die Münzen fliegen zu schnell in die Blobrichtung? """
""" Versuch die Geschwindigkeit zu verlangsamen        """
""" -------------------------------------------------- """
func muenzMagnet(var x_Position_Spieler):
	
	#Spieler Richtung + Entfernung ermitteln
	var differenz = x_Position_Spieler - position.x
	
	var bewegung = differenz*2.2
	
	#passend zur Spielerposition zur Münze die Bewegung festlegen
	if x_Position_Spieler < position.x:
		Bewegung.x = bewegung
	elif x_Position_Spieler > position.x:
		Bewegung.x = bewegung
	else:
		Bewegung.x = 0
