extends KinematicBody2D

#Signale bei Erkennung einer Kollision
signal m1_beruerht
signal m2_beruehrt
signal negativ1_beruehrt
signal negativ2_beruehrt


#Abgepeicherte Coin Informationen


#Variablen zur Bewegung der Coins
export var Geschwindigkeit = 100
var Bewegung = Vector2(0,0)

var UP_Vektor = Vector2(0, -1)
var screen_size

#Als Konstruktor der Klasse wird die Screensize ermittelt und eine zufällige Position gesetzt
func _ready():
	screen_size = get_viewport_rect().size
	ZufallsPosition()


#Ablauf für eine Münze --> sie fällt bis eine Kollision geprüft wird
func _process(delta):
	
	fallen()
	move_and_slide(Bewegung, UP_Vektor)


#lässt eine Münze konstant fallen um die angegebene Geschwindigkeit
func fallen():
	Bewegung.y = Geschwindigkeit


#ermittelt eine Zufällige Position an der oberen Kante des Bildfensters
func ZufallsPosition():
	position.x = rand_range(0, screen_size.x)
	position.y = 0
	

#Münze soll entfernt werden
func blobKollision():
	
	print("Münze Kollidiert")
	queue_free()





