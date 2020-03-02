extends KinematicBody2D

#Klasse / Szene für die KanonenKugel

#Wenn eine Kanone instanziert wird fliegt sie Zufällig von recht / Links ins Bild
#Dies geschiet auf der gesetzten Höhe


#Variable um die Warnung auf dem Spielfeld erzeugen zu können
onready var spiel = get_tree().get_root().get_node("Main").get_node("Spiel")


signal kanoneberuehrt #wird ausgesendet wenn Kanone berührt wurde

#Kanonen Bewegung-Variablen
var geschwindigkeit = random_Zahl_Zwischen(130, 180)
var Bewegung = Vector2(0,0) #Bewegung für X und Y
var hoehe = 500
var richtung_Links = false #repräsentiert Flugrichtung

var screen_size
var persistenz = preload("res://Szenen/Spielverwaltung/Persistenz.tscn").instance()


#Konstruktor der Klasse Kanone
#-das passende Bild wird geladen + die daraus Resultierende Kollisionsbox erzeugt
#-die Kanonenwarnung wird erstellt und eine Zufällige Flughähe festgelegt
#-die Screen Größe wird ermittelt
#-es wird zufällig festgelegt ob die Kanone von recht / links kommt
func _ready():
	lade_Sprite_Bild()
	erstelle_Hitbox()
	screen_size = get_viewport_rect().size
	
	hoehe = random_Zahl_Zwischen(400,482) #Zuffällige Flughöhe
	
	#Warnung laden
	var Kanonenwarnung = load("res://Szenen/Spielfiguren/Kanonenwarnung.tscn");
	var neue_Warnung
	
	#Zufällige Flugrichtung festlegen
	if random_Zahl_Zwischen(0,1) == 1:
		kanone_Links()
		richtung_Links = true
		
		#Warnung rechts erstellen
		neue_Warnung = Kanonenwarnung.instance()
		neue_Warnung.warnungLinks(hoehe)
	else:
		kanone_Rechts()
		
		#Warnung links erstellen
		neue_Warnung = Kanonenwarnung.instance()
		neue_Warnung.warnungRechts(hoehe)
	
	position.y = hoehe
	#Warnung im Spiel anzeigen
	spiel.add_child(neue_Warnung)


#Mehtode welche für jeden Frame aufgerufen wird und Bewegung initialisiert
#--> Nach der Zufällig ermittelten Richtung wird dann Rakete bewegt
func _physics_process(delta):
	if richtung_Links:
		bewegung_Links()
	else:
		bewegung_Rechts()


#Methode um eine Random zahl aus einem Zahlenbereich auszuwählen
#@param von: Startzahl des Bereichs
#@param bis: Endzahl des Bereichs
#@return: eine Random Zahl aus dem Bereich
func random_Zahl_Zwischen(var von, var bis):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var zufall = rng.randi_range(von,bis)
	return zufall




#Methode um die Kanone Rechts zu initialisieren
#--> Position rechts neben Rand (Negativ, damit sie ins bild rein fliegt)
func kanone_Links():
	position.x = -200 



#Methode um die Kanone Links zu initialisieren
#--> Screen_size + 200 damit Kanone von Seite reinfliegt
func kanone_Rechts():
	position.x = screen_size.x + 200 



#Methode um Kanone kontinuirlich nach Rechts zu bewegen
#-die X Koordinate in Positiver X Richtung verändern
#-das Bild in passende Richtung drehen
func bewegung_Links():
	Bewegung.x = geschwindigkeit
	move_and_slide(Bewegung)
	$Sprite.flip_h = true
	
	#Kanone Entfernen sobald sie aus dem Bild ist
	if is_on_wall() and position.x > screen_size.x:
		queue_free()


#Methode um Kanone kontinuirlich nach Links zu bewegen
#-die X Koordinate in negatvier X Richtung verändern
#-das Bild in passende Richtung drehen
func bewegung_Rechts():
	Bewegung.x = -geschwindigkeit
	move_and_slide(Bewegung)
	$Sprite.flip_h = false
	
	#Kanone Entfernen sobald sie aus dem Bild ist
	if is_on_wall() and position.x < 10:
		queue_free()


#Methode wenn die Kollision mit dem Blob stattgefunden hatt
#Kanone verschwindet + entsendet passendes Signal für den Blob
func blobKollision():
	emit_signal("kanoneberuehrt")
	queue_free()



#Methode zum erstellen des Collision Shapes der Kanone abhängig von gewählten Bild
#Zuerst wird die Bild Größe ermittelt, woraus ein Shape erzeugt wird
#Dann wird das Shape als Hitbox gesetzt
func erstelle_Hitbox():
	#Bild Größe ermitteln
	var alle_Groessen = einstellungen.figurengroesse
	var bild_Groesse = alle_Groessen["Kanonenkugel"]
	
	#Passende Bild Maße berechnen
	var bild_breite = bild_Groesse[1].x - bild_Groesse[0].x
	var bild_hoehe = bild_Groesse[1].y - bild_Groesse[0].y
	
	print (bild_breite)
	print (bild_hoehe)
	
	
	#Collision Shape für die Area
	var shape = RectangleShape2D.new()
	shape.set_extents(Vector2(bild_breite/2,bild_hoehe/2))
	$Area2D/CollisionShape2D2.set_shape(shape)
	$Area2D/CollisionShape2D2.position.y = 0
	#$Area2D/CollisionShape2D2.position.y += ((64-groesse.y) /2) 
	
	#Collision Shape für den Kinematic Body
	var shape2 = RectangleShape2D.new()
	shape.set_extents(Vector2(bild_breite/2.5,bild_hoehe/2.5))
	$CollisionShape2D.set_shape(shape)
	$CollisionShape2D.position.y = 0
	#$CollisionShape2D.position.y += ((64-groesse.y) /2) 


# Methode zum laden des Bildes ins Sprite 
# Muss ueber umweg geschehen, da Bilder nicht direkt aus dem userverzeichnis geladen werden koennen.
func lade_Sprite_Bild():
	$Sprite.texture =  persistenz.lade_bildtextur("res://Bilder/Standardspielfiguren/Spielfiguren/Kanonenkugel.png")
