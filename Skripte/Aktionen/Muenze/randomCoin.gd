extends "res://Skripte/Aktionen/Muenze/Muenze.gd"


#Szene / Klasse für den Random Coin
#Setzt die Coin Spezifischen Variablen und beinhaltet die spezifischen Methoden

#Erbt die Methoden und Variablen von der Super Klasse Muenze

#Methode wird beim instanzieren ausgeführt (Kontruktor)
#Münze wird als Randomcoin erstellt


#Variablen für die Kurven Berechnung
var kurvenbreite = 200
var in_rechts_Bewegung = false


func _ready():
	$Sprite.texture = .lade_bild_von_user("res://Bilder/Standardspielfiguren/Coins/RandomCoin.png");
	coinWert = 5
	geschwindigkeit = 100
	bild_Groesse = einstellungen.figurengroesse["RandomCoin"]
	erstelle_Hitbox()
	



#Methode fallen aus der Superklasse überschrieben!!
#Zusätzlich zu dem Normalen Fallen soll noch die Kurven Bewegung mit einberechnet werden
func fallen():
	Bewegung.y = geschwindigkeit
	berechne_Kurve() #kurve dem Fallen hinzufügen
	
	#Wenn Münze verschwinden soll, die Münze "frei" setzen
	if soll_Muenze_Verschwinden():
		emit_signal("neueMuenze")
		queue_free()


""" ---------------------------------------------------------- """
""" Ist es möglich die Flugkurve des Randomcoins zu vergößern? """
""" ---------------------------------------------------------- """
#Methode zum Berechnen der besonderen Flugkurve eines Random Coins
#die Richtung in welcher die Kurve laufen soll wird geprüft und dann im 
#Anschluss in die Bewegung umgewandelt 
#Kurvenbreite gibt an wie weit Münze hin und her fliegt
func berechne_Kurve():
	if(Bewegung.x > kurvenbreite):
		in_rechts_Bewegung = false
	elif Bewegung.x < -kurvenbreite:
		in_rechts_Bewegung = true
	
	if in_rechts_Bewegung:
		Bewegung.x += 5
	else:
		Bewegung.x -= 5



#Methode zum reagieren auf eine Kollision mit der Spielerfigur 
#--> wird aufgerufen, sobald die Spielfigur eine Kollision mit dem RandomCoin registriert
#Senden des Signals das eine Random Aktion folgen soll + Münze entfernen
func blob_Kollision():
	
	emit_signal("randomAktion")
	queue_free()
