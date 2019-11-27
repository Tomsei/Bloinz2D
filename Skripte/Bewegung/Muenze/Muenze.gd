#Abstrakte Klasse Münze --> gibt vor was alle Münzen haben können
extends KinematicBody2D

"""
Abstrakte Klasse / Szene für alle Münzen

Diese Klasse als auch Szene in Godot dient als Vorlage für alle Münzen die im Spiel vorhanden sind
--> es werden die Methoden und eigenschaft gesetzt, welche für jede Münze gleich sind

Implementierung von 
1. dem Bewegungsverhalten der Münze
2. dem Kollisionsverhalten der Münze
3. der Positionierung beim erzeugen
--> alles Eigenschaften die für alle Münzen gleich sind und daher vererbt werden können

"""


#Signale bei Erkennung einer Kollision um Reaktionen im Spieler ausführen zu können
signal muenze_beruehrt (wert)
signal neueMuenze


#Der Coin Wert muss abgespeichert werden --> beinhaltet somit auch Coin Typ
var coinWert

#Variablen zur Bewegung der Coins
var Geschwindigkeit
var Bewegung = Vector2(0,0)
var UP_Vektor = Vector2(0, -1) #Wo ist Oben


var screen_size


"""
Beim Initialisieren der Szene / Klasse (Konstruktor) der Münze werden
-Bildgröße des Spiels ermittelt
-die Münze an einer zufälligen Position positioniert
"""
func _ready():
	screen_size = get_viewport_rect().size
	ZufallsPosition()


"""
Ablauf einer Münze --> wird bei jedem neuen Bild aufgerufen
-die münze fällt / bewegt sich 
"""
func _process(delta):	
	fallen() #Berechnet Bewegung
	move_and_slide(Bewegung, UP_Vektor) #führt die Bewegung aus


"""
Methode um eine Münze konstant mit der Münz geschwindigkeit fallen zu lassen
"""
func fallen():
	Bewegung.y = Geschwindigkeit
	
	#wenn der Boden brührt wird, soll die Münze auch verschwinden
	if is_on_floor() and position.y > 607:
		emit_signal("neueMuenze")
		queue_free()


"""
Methode zum ermitteln einer Zufälligen Position an der oberen Kante des Bildfensters
"""
func ZufallsPosition():
	position.x = rand_range(0, screen_size.x)
	position.y = 0
	


#Bei Kollision mit Blob wird die Methode aufgerufen 
#--> Die Münze schmeißt die Signale, dass sie weg ist und wird dann entfernt

"""
Methode zum reagieren auf eine Kollision mit der Spielerfigur 
--> wird aufgerufen, sobald die Spielfigur eine Kollision mit der Münze registriert

Senden des Signals der Münzberührung mit dem individuellen coinWert
"""
func blobKollision():
	
	emit_signal("muenze_beruehrt", coinWert)
	print("Münze Kollidiert")
	emit_signal("neueMuenze")
	
	queue_free()