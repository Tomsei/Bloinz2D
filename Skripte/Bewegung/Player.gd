extends KinematicBody2D

#Variable um die Geschwindigkeit der Spielerbewegung einstellen zu können
export var speed = 300
export var Schwerkraft = 400
export var Sprungkraft = 400


var screen_size

#Die Bewegung als Klassen Variable, damit über Delta Veränderungen stattfinden können | Vektor um in alle Richtungen bewegen zu können
var Bewegung = Vector2()

#ein Vektor der nach oben Zeigt (Zum Top des Spiels) | y = -1 wegen gedrehter Y Achse
var UP_Vector = Vector2(0, -1)

#Funktion wird zu Beginn des Spiels aufgerufen und ermittelt die Spielfeld Größe und setzt die Startposition
func _ready():
	#Die Bildschirmgröße abspeichern
	screen_size = get_viewport_rect().size
	position.x = screen_size.x/2




# Called every frame. 'delta' is the elapsed time since the previous frame. --> Delta wird also verwendet, damti Bewegung auch flüssig wenn weniger fps vorhanden sind
func _process(delta):
	
	#Grunsätzlich soll keine Bewegung zur Zeite existieren
	Bewegung.x = 0;
	
	#die Schwerkraft berechnen --> Je länger der Fall ist, umso stärker wird die Schwerkraft
	#delta steht für jeden Fram --> mit jedem Frame wird die Schwerkraft stärker
	Bewegung.y = Bewegung.y + Schwerkraft * delta*2
	
	#Die Bewegung abhängig von den betätigten Tasten
	checkTastenEingabe();
	
	
	#Ausführen der Bewegung für den Cinematic Body | Up Vektor um später zu erkennen was der Boden ist
	move_and_slide(Bewegung, UP_Vector);
	
	
	#Sicherstellen, dass abhängig von der Bildschirmgröße das Objekt nicht raus laufen kann
	position.x = clamp(position.x, 0, screen_size.x)




#Funktion zum ermitteln welche Tasten gedrückt wurden
func checkTastenEingabe():
	
	#Nach rechts
	if Input.is_action_pressed("ui_right"):
		Bewegung.x += 1 * speed
	
	#Nach links
	if Input.is_action_pressed("ui_left"):
		Bewegung.x -= 1 * speed
	
	#Wenn der Input für das Springen gerade gekommen ist und der Spieler ein Boden berührt
	if Input.is_action_just_pressed("jump") and is_on_floor():
		#Dann soll gesprungen werden
		Bewegung.y = -Sprungkraft #Es wird minus gerechnet, da y Achse umgedreht ist



