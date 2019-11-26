extends KinematicBody2D

signal hit

#Variable um die Geschwindigkeit der Spielerbewegung einstellen zu können
export var speed = 300
export var Schwerkraft = 400
export var Sprungkraft = 500



# Szenengroesse
var screen_size

#Die Bewegung als Klassen Variable, damit über Delta Verönderungen stattfinden können | Vektor um in alle Richtungen bewegen zu können
var Bewegung = Vector2()

#ein Vektor der nach oben Zeigt (Zum Top des Spiels) | y = -1 wegen gedrehter Y Achse
var UP_Vector = Vector2(0, -1)


#Blob Eigenschaften
var doppelterSprung = false # wurde doppelSprung bereits ausgeführt oder nicht?

var blobHoehe = 607 #maximaleBLobhöhe in Sprung
var bounceAnzahl = 0
var bounceEffekt = 1000 - position.y # Wie start soll er wieder springen
var sprungRestBewegung = 0

#Funktion wird zu Beginn des Spiels aufgerufen und ermittelt die Spielfeld Größe und setzt die Startposition
func _ready():
	#Die BildschirmgrÃ¶ÃŸe abspeichern
	screen_size = get_viewport_rect().size
	position.x = screen_size.x/2


# Called every frame. 'delta' is the elapsed time since the previous frame. --> Delta wird also verwendet, damti Bewegung auch flÃ¼ssig wenn weniger fps vorhanden sind
func _process(delta):
	
	#Grundätzlich soll keine Bewegung zur Zeite existieren
	Bewegung.x = 0;
	
	#die Schwerkraft berechnen --> Je länger der Fall ist, umso stärker wird die Schwerkraft
	#delta steht für jeden Frame --> mit jedem Frame wird die Schwerkraft stärker
	Bewegung.y = Bewegung.y + Schwerkraft * delta*2
	
	#Die Bewegung abhängig von den betätigten Tasten
	checkTastenEingabe()
	
	#Sofern der Blob in der Luft ist wird ermittelt wie hoch er in dem jeweiligen Sprung gekommen ist
	ermittelMaximalHoehe()
	
	#die BauneKraft berechnen, sofern der Blob vorher noch nicht gebounce ist
	if bounceAnzahl == 0:
		bounceEffekt = 1000-blobHoehe 
	
	#nach einem Sprung soll die Bounce Fähigkeit gegeben sein
	sprungUpdate()
	
	
	#Ausführen der Bewegung fürr den Cinematic Body | Up Vektor um zu erkennen was der Boden ist
	move_and_slide(Bewegung, UP_Vector);
	
	#Sicherstellen, dass abhängig von der Bildschirmgröße das Objekt nicht raus laufen kann
	position.x = clamp(position.x, 0, screen_size.x)

#Funktion zum ermitteln welche Tasten gedrückt wurden 
func checkTastenEingabe():
	
	#Nach rechts --> Blob nach rechts bewegen
	if Input.is_action_pressed("ui_right"):
		Bewegung.x += 1 * speed
		sprungRestBewegung = 1*speed
	
	#Nach links --> Blob nach links bewegen
	if Input.is_action_pressed("ui_left"):
		Bewegung.x -= 1 * speed
		sprungRestBewegung = -1*speed
	
	#Wenn der Input für das Springen gerade gekommen ist und der Spieler ein Boden berÃ¼hrt
	if Input.is_action_just_pressed("jump"):
		#Dann soll gesprungen werden
		sprung() #Die Methode zum Springen wird genutzt



#Sprung Funktion
func sprung():
	
	#Die Blob Höhe auf Bodenhöhe setzen, damit für den Sprung neue höchste Höhe ermittelt werden kann
	blobHoehe = 607
	
	
	if is_on_floor():
		doppelterSprung = false
		Bewegung.y = - Sprungkraft
		sprungRestBewegung = 0 #verhindert, das vom Boden Aus Sprung richtung weiter Rutscht
		
	#Wenn noch kein doppelSprung ausgeführt wurde, ist ein weiter Impuls nach oben möglich
	elif doppelterSprung == false:
		Bewegung.y = -Sprungkraft
		doppelterSprung = true
		
	bounceAnzahl = 0 #Bei einem neuen Sprung, soll Bounce wieder neu berechnet werden können
	
	


#Prozedur welche die Höchste Position in einem Flug abspeichert
func ermittelMaximalHoehe():
	
	if !is_on_floor():
		if position.y < blobHoehe:
			blobHoehe = position.y


#beinhaltet Funktionen, das beispielsweise ein Bounce des Blobs statfindet
#Auch das die Sprungrichtung noch leicht "nachzieht" ist hier mit enthalten
func sprungUpdate():
	
	#Ein weiterer Impuls soll gebeben werden, sofern Blob auf dem Boden und nicht zu oft gesprungen ist. 
	#Außerdem wird unterbunden, dass ein Sprung von den Effekten beeinflusst wird 
	if is_on_floor() and bounceAnzahl < 3 and !Input.is_action_just_pressed("jump"): 
		bounceEffekt = bounceEffekt/2
		Bewegung.y = -bounceEffekt
		bounceAnzahl = bounceAnzahl+1
		sprungRestBewegung = 0
		
	elif !Input.is_action_pressed("ui_left") and !Input.is_action_pressed("ui_right") and !is_on_floor():
		sprungRestBewegung = sprungRestBewegung / 1.05
		Bewegung.x = sprungRestBewegung

