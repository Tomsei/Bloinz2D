extends KinematicBody2D


#Signale bei Erkennung einer Kollision
signal m1_beruerht (wert)
signal neueMuenze


#Abgepeicherte Coin Informationen
var coinWert = 1

#Variablen zur Bewegung der Coins
export var Geschwindigkeit = 100
var Bewegung = Vector2(0,0)


var UP_Vektor = Vector2(0, -1)
var screen_size


#Als Konstruktor der Münze wird die Screensize ermittelt und eine zufällige Position gesetzt
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
	
	#wenn der Boden brührt wird, soll die Münze auch verschwinden
	if is_on_floor() and position.y > 607:
		emit_signal("neueMuenze")
		queue_free()


#ermittelt eine Zufällige Position an der oberen Kante des Bildfensters
func ZufallsPosition():
	position.x = rand_range(0, screen_size.x)
	position.y = 0
	


#Bei Kollision mit Blob wird die Methode aufgerufen 
#--> Die Münze schmeißt die Signale, dass sie weg ist und wird dann entfernt
func blobKollision():
	
	emit_signal("m1_beruerht", coinWert)
	print("Münze Kollidiert")
	emit_signal("neueMuenze")
	
	queue_free()