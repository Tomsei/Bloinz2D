extends "res://Skripte/Aktionen/Muenze/Muenze.gd"

"""
Szene / Klasse für den Random Coin
Setzt die Coin Spezifischen Variablen

Erbt die Methoden und Variablen von der Super Klasse Muenze
"""


func _ready():
	coinWert = 5
	Geschwindigkeit = 100
	


"""
Methode fallen aus der Superklasse überschrieben
Zusätzlich zu dem Normalen Fallen soll noch die Kurven Bewegung mit einberechnet werden
"""
func fallen():
	Bewegung.y = Geschwindigkeit
	berechneKurve()
	
	#Wenn Münze verschwinden soll, die Münze "frei" setzen
	if sollMuenzeVerschwinden():
		emit_signal("neueMuenze")
		queue_free()
		



#Variablen für die Kurven Berechnung
var kurvenbreite = 200
var inRechtsBewegung = false


"""
Methode zum Berechnen der besonderen Flugkurve eines Random Coins
"""
func berechneKurve():
	if(Bewegung.x > kurvenbreite):
		inRechtsBewegung = false
	elif Bewegung.x < -kurvenbreite:
		inRechtsBewegung = true
	
	if inRechtsBewegung:
		Bewegung.x += 5
	else:
		Bewegung.x -= 5



"""
Methode zum reagieren auf eine Kollision mit der Spielerfigur 
--> wird aufgerufen, sobald die Spielfigur eine Kollision mit dem RandomCoin registriert

Senden des Signals das eine Random Aktion folgen soll
"""
func blobKollision():
	
	emit_signal("randomAktion")
	emit_signal("neueMuenze")
	
	queue_free()