extends KinematicBody2D
"""
Klasse / Szene für die KanonenKugel

Wenn eine Kanone instanziert wird fliegt sie Zufällig von recht / Links ins Bild
Dies geschiet auf der gesetzten Höhe

"""


signal kanoneberuehrt #wird ausgesendet wenn Kanone berührt wurde

#Kanonen Bewegung-Variablen
var geschwindigkeit = randomZahlZwischen(130, 180)
var Bewegung = Vector2(0,0)
var hoehe = 474
var richtungRechts = false

var screen_size


"""
Konstruktor der Klasse Kanone
-die Screen Größe wird ermittelt
-es wird zufällig festgelegt ob die Kanone von recht / links kommt
"""
func _ready():
	
	screen_size = get_viewport_rect().size
	
	if randomZahlZwischen(0,1) == 1:
		kanoneRechts()
		richtungRechts = true
		print("rechts")
	else:
		KanoneLinks()
		print("links")
	
	
	position.y = hoehe


"""
Methode um eine Random zahl aus einem Zahlenbereich auszuwählen
@param von: Startzahl des Bereichs
@param bis: Endzahl des Bereichs
@return: eine Random Zahl aus dem Bereich
"""
func randomZahlZwischen(var von, var bis):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var zufall = rng.randi_range(von,bis)
	return zufall



"""
Mehtode welche für jeden Frame aufgerufen wird und Bewegung initialisiert
--> Nach der Zufällig ermittelten Richtung wird dann Rakete bewegt
"""
func _physics_process(delta):
	if richtungRechts:
		bewegungrechts()
	else:
		bewegunglinks()



"""
Methode um die Kanone Rechts zu initialisieren
--> Position rechts neben Rand (Negativ, damit sie ins bild rein fliegt)
"""
func kanoneRechts():
	position.x = -50 


"""
Methode um die Kanone Links zu initialisieren
--> Screen_size + 50 damit Kanone von Seite reinfliegt
"""
func KanoneLinks():
	position.x = screen_size.x + 50 


"""
Methode um Kanone kontinuirlich nach Rechts zu bewegen
-die X Koordinate in Positiver X Richtung verändern
-das Bild in passende Richtung drehen
"""
func bewegungrechts():
	Bewegung.x = geschwindigkeit
	move_and_slide(Bewegung)
	$Sprite.flip_h = true
	if is_on_wall() and position.x > screen_size.x:
		queue_free()
		print("Kanone Weg")

"""
Methode um Kanone kontinuirlich nach Links zu bewegen
-die X Koordinate in negatvier X Richtung verändern
-das Bild in passende Richtung drehen
"""
func bewegunglinks():
	Bewegung.x = -geschwindigkeit
	move_and_slide(Bewegung)
	$Sprite.flip_h = false
	if is_on_wall() and position.x < 200:
		queue_free()
		print("Kanone Weg")

"""
Methode wenn die Kollision mit dem Blob stattgefunden hatt
Kanone verschwindet + entsendet passendes Signal für den Blob
"""
func blobKollision():
	emit_signal("kanoneberuehrt")
	queue_free()

