extends "res://Skripte/Bewegung/Muenze/Muenze.gd"

"""
Szene / Klasse für den Random Coin
Setzt die Coin Spezifischen Variablen

Erbt die Methoden und Variablen von der Super Klasse Muenze
"""


func _ready():
	coinWert = 5
	Geschwindigkeit = 100
	
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

func berechneKurve():
	if(Bewegung.x > kurvenbreite):
		inRechtsBewegung = false
	elif Bewegung.x < -kurvenbreite:
		inRechtsBewegung = true
	
	if inRechtsBewegung:
		Bewegung.x += 5
	else:
		Bewegung.x -= 5

func blobKollision():
	
	emit_signal("randomAktion")
	emit_signal("neueMuenze")
	
	queue_free()