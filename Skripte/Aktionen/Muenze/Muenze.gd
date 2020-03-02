
extends KinematicBody2D


#Abstrakte Klasse / Szene für alle Münzen

#Diese Klasse als auch Szene in Godot dient als Vorlage für alle Münzen die im Spiel vorhanden sind
#--> es werden die Methoden und Eigenschaften definiert, welche für jede Münze gleich sind

#Implementierung von 
#1. dem Bewegungsverhalten der Münze
#2. dem Kollisionsverhalten der Münze
#3. der Positionierung beim erzeugen
#--> alles Eigenschaften die für alle Münzen gleich sind und daher vererbt werden können



#Signale um nach Kollision reagieren zu können zu können 
signal muenze_beruehrt (wert)
signal randomAktion


var coinWert #wie viel Punkte bringt eine Münze


#Variablen zur Bewegung der Coins
var geschwindigkeit = 0
var Bewegung = Vector2(0,0) 	#Bewegung in x / Y Richtung
var UP_Vektor = Vector2(0, -1) 	#Wo ist Oben

onready var bild_Groesse #Größe des gemalten Bildes
var persistenz = preload("res://Szenen/Spielverwaltung/Persistenz.tscn").instance()


#Beim Instanzieren der Szene / Klasse der Münze (Konstruktor)
#wird eine Zufällige Position gewählt
func _ready():
	zufalls_Position()



#Methode wird jeden Frame aufgerufen
#Ablauf einer Münze --> die münze fällt / bewegt sich 
func _physics_process(delta):
	fallen()                            #Berechnet Bewegung
	move_and_slide(Bewegung, UP_Vektor) #Bewegungs ausführung



#Methode um eine Münze konstant mit der Münzgeschwindigkeit fallen zu lassen
func fallen():
	Bewegung.y = geschwindigkeit
	
	#Wenn Münze verschwinden soll, die Münze "frei" setzen
	if soll_Muenze_Verschwinden():
		queue_free()



#Methode zum überprüfen ob Münze verschwinden soll oder nicht
#Es werden alle Kollisionen der Münze ermittelt und geprüft
#Sie soll selbst verschwinden, wenn die Kanone / der Boden berührt wird
#Nicht wenn andere Münze / Spieler berührt wird --> Spieler setzt entfernen in Gang
#
#@return true wenn Münze Kanone / Boden berührt -> sie soll verschwinden
func soll_Muenze_Verschwinden():
	for body in $Area2D.get_overlapping_bodies():
		if body.name == "Kanone" or body.name == "BodenCollisionShape":
			return true 


#Methode zum ermitteln einer Zufälligen Position an der oberen Kante des Bildfensters
func zufalls_Position():
	position.x = rand_range(0, 448)
	position.y = 0
	



#Methode zum reagieren auf eine Kollision mit der Spielerfigur 
#--> wird aufgerufen, sobald die Spielfigur eine Kollision mit der Münze registriert
#Senden des Signals der Münzberührung mit dem individuellen coinWert + Münze entfernen
func blobKollision():
	emit_signal("muenze_beruehrt", coinWert)
	queue_free()




#Methode zum erstellen der Hitbox / des Trefferbereichs einer Münze passend zu ihrem Bild
#Bild Größe wird durch die Subklassen festgelegt --> passend zur Größe ein Shape berechnen
func erstelle_Hitbox():
	#Passende Bild Maße berechnen
	var bild_breite = bild_Groesse[1].x - bild_Groesse[0].x
	var bild_hoehe = bild_Groesse[1].y - bild_Groesse[0].y
	
	#Area Shape erstellen
	var shape = RectangleShape2D.new()
	shape.set_extents(Vector2(bild_breite/2,bild_hoehe/2))
	
	#Collisionshape für die Area berechnen
	$Area2D/CollisionShape2D.set_shape(shape)
	
	#KinematicBody shape erstellen
	var shape2 = RectangleShape2D.new()
	shape2.set_extents(Vector2(bild_breite/2.5,bild_hoehe/2.5))
	
	
	#CollisionShape für den Kinematic Body festlegen
	$CollisionShape2D.set_shape(shape2)
	
	#Positionierung des Bildes passend zum Shape
	$Sprite.position.x = 0
	$Sprite.position.x += 32-bild_Groesse[0].x - bild_breite/2
	
	$Sprite.position.y = 0
	$Sprite.position.y += 32-bild_Groesse[0].y - bild_hoehe/2
	


# Methode zum einladen eines Bildes aus dem Userverzeichnis 
func lade_bild_von_user(pfad):
	return persistenz.lade_bildtextur(pfad)


