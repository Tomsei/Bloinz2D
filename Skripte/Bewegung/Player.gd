extends KinematicBody2D

#Variable um die Geschwindigkeit der Spielerbewegung einstellen zu können
export var speed = 300
export var Schwerkraft = 400
export var Sprungkraft = 500

# Szenengroesse
var screen_size

#Die Bewegung als Klassen Variable, damit über Delta Verönderungen stattfinden können | Vektor um in alle Richtungen bewegen zu können
var Bewegung = Vector2()

#ein Vektor der nach oben Zeigt (Zum Top des Spiels) | y = -1 wegen gedrehter Y Achse
var UP_Vector = Vector2(0,-1)


#Blob Eigenschaften
var doppelterSprung = false # wurde doppelSprung bereits ausgeführt oder nicht?

var blobHoehe = 409 #maximaleBLobhöhe in Sprung
var bounceAnzahl = 0
var bounceEffekt = 1000 - position.y # Wie start soll er wieder springen
var sprungRestBewegung = 0

var blobGroesse = 2 #die aktuelle Größe und das Blob Aussehen wird hierraus bestimmt
# --> Unterschiedliche Blobphasen aufgeteilt in 10 Schritte --> -10 | -5 | 0 | 5 | 10
var bilderSeitlich = false

var bodenhoehe = 470

#Funktion wird zu Beginn des Spiels aufgerufen und ermittelt die Spielfeld Größe und setzt die Startposition
func _ready():
	#Die Bildschirmgröße abspeichern
	screen_size = get_viewport_rect().size
	position.x = screen_size.x/2
	
	skalieren(0.8) #Kollisionshapes auf Startgröße skalieren
	
	#Am Start ist der blob im neutralen Zustand
	$AnimatedSprite.play("neutral_gerade")
	
	var sprungskraft_signal = load("res://Skripte/Slider.gd")
	sprungskraft_signal.connect("aendereSprungkraft",self,"sprungkraft_geaendert")


# Called every frame. 'delta' is the elapsed time since the previous frame. --> Delta wird also verwendet, damti Bewegung auch flÃ¼ssig wenn weniger fps vorhanden sind
func _physics_process(delta):
	
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
	
	kollisionsPruefung()
	
	#Sicherstellen, dass abhängig von der Bildschirmgröße das Objekt nicht raus laufen kann
	position.x = clamp(position.x, 0, screen_size.x)


#Funktion zum ermitteln welche Tasten gedrückt wurden 
func checkTastenEingabe():
	
	#Nach rechts --> Blob nach rechts bewegen
	if Input.is_action_pressed("ui_right"):
		Bewegung.x += 1 * speed
		sprungRestBewegung = 1*speed
		
		#Wenn nötig die Textur des Sprites passend ändern
		if spriteUpdateNoetig():
			blobVeranederung(true)
			$AnimatedSprite.flip_h = false #Spiegelung des seitlichen Richtung
	
	#Nach links --> Blob nach links bewegen
	if Input.is_action_pressed("ui_left"):
		Bewegung.x -= 1 * speed
		sprungRestBewegung = -1*speed
		
		#Wenn nötig die Textur des Sprites passen ändern
		if spriteUpdateNoetig():
			blobVeranederung(true)
			$AnimatedSprite.flip_h = true #Spiegelung des seitlichen Richtung
	
	#Wenn keine Bewegung stattfindet muss das Bild auf den Stand gewechselt werden
	if !Input.is_action_just_pressed("ui_left") and !Input.is_action_just_pressed("ui_right"):
		if spriteUpdateNoetig():
			blobVeranederung(false)
	
	#Wenn der Input für das Springen gerade gekommen ist und der Spieler ein Boden berührt
	if Input.is_action_just_pressed("jump"):
		#Dann soll gesprungen werden
		sprung() #Die Methode zum Springen wird genutzt





#Sprung Funktion
func sprung():
	
	#Die Blob Höhe auf Bodenhöhe setzen, damit für den Sprung neue höchste Höhe ermittelt werden kann
	blobHoehe = bodenhoehe
	
	
	if is_on_floor():
		doppelterSprung = false
		Bewegung.y = - Sprungkraft
		sprungRestBewegung = 0 #verhindert, das vom Boden Aus Sprung richtung weiter Rutscht
		
		#es soll nicht gesprungen werden, wenn der Blob gerade am Bounce ist!
		if bounceAnzahl == 3:
			bounceAnzahl = 0 #Bei einem neuen Sprung, soll Bounce wieder neu berechnet werden können
		
	#Wenn noch kein doppelSprung ausgeführt wurde, ist ein weiter Impuls nach oben möglich
	elif doppelterSprung == false:
		Bewegung.y = -Sprungkraft
		doppelterSprung = true


#Prozedur welche die Höchste Position in einem Flug abspeichert
func ermittelMaximalHoehe():
	
	if !is_on_floor():
		if position.y < blobHoehe:
			blobHoehe = position.y



#beinhaltet Funktionen, das beispielsweise ein Bounce des Blobs statfindet
#Auch das die Sprungrichtung noch leicht "nachzieht" ist hier mit enthalten
func sprungUpdate():
	
	#Ein weiterer Impuls soll gebeben werden, sofern Blob auf dem Boden und nicht zu oft gesprungen ist. 
	#Sicherstellen, dass on Floor nur für den Boden getriggert
	if is_on_floor() and bounceAnzahl < 3 and position.y > bodenhoehe and not Input.is_action_just_pressed("jump"):
		bounceEffekt = bounceEffekt/2
		Bewegung.y = -bounceEffekt
		bounceAnzahl = bounceAnzahl+1
		sprungRestBewegung = 0
		
	elif !Input.is_action_pressed("ui_left") and !Input.is_action_pressed("ui_right") and !is_on_floor():
		sprungRestBewegung = sprungRestBewegung / 1.05
		Bewegung.x = sprungRestBewegung



"""
Methode zum erkennen von Kollisionen mit anderen Objekten

für alle erkannten Objekte welche in die Area des Blobs gekommen sind 
wird die Methode blobKollision aufgerufen, sofern diese vorhanden ist
--> somit können die Objekte passend auf Kollision mit Spielfigur reagieren
"""
func kollisionsPruefung():
	for body in $Hitbox.get_overlapping_bodies():
		if body.has_method("blobKollision"):
			body.blobKollision()





"""
Abhängig von der Blobgroese und Ausrichtung des Spielers soll die passende Textur geladen werden

Sobald die Blobgröße kleiner 10 ist, ist das Spiel verloren
Sobald die Blobgrößer größer als 15 ist, ist das Spiel gewonnen

Zusätzlich wird das Kollisionshape bei einer Größen änderung angepasst

@param setilich gibt an ob sich der Blob gerade in einer seitlichen Bewegung befindet
"""

func blobVeranederung(var seitlich):
	
	#switch Casse über alle Größen des Blobs es wird jeweils das passende Bild gesetzt
	#Zustäzlich wird überprüft ob Blob in Bewegung bzw. seitlich ist
	
	match blobGroesse:
		-11:
			print ("verloren")
		-10, -9, -8, -7, -6:
			if seitlich:
				$AnimatedSprite.play("negativ_2_seitlich")
				skalieren(0.5)
			else:
				$AnimatedSprite.play("negativ_2_gerade")
				skalieren(0.5)
		
		-5, -4, -3, -2, -1:
			if seitlich:
				$AnimatedSprite.play("negativ_1_seitlich")
				skalieren(0.7)
			else:
				$AnimatedSprite.play("negativ_1_gerade")
				skalieren(0.7)
		
		0, 1, 2, 3, 4:
			if seitlich:
				$AnimatedSprite.play("neutral_seitlich")
				skalieren(0.8)
			else:
				$AnimatedSprite.play("neutral_gerade")
				skalieren(0.8)
		5, 6, 7, 8,  9:
			if seitlich:
				$AnimatedSprite.play("positiv_1_seitlich")
				skalieren(0.9)
			else:
				$AnimatedSprite.play("positiv_1_gerade")
				skalieren(0.9)
		10, 11, 12, 13, 14:
			if seitlich:
				$AnimatedSprite.play("positiv_2_seitlich")
				skalieren(1.0)
			else:
				$AnimatedSprite.play("positiv_2_gerade")
				skalieren(1.0)
		15:
			print ("gewonnen")

"""
Methode um die Hitboxen des Spielers der Größe anzupassen
@param faktor: um welchen Faktor das Shape skaliert werden soll
"""
func skalieren(var faktor):
	$physischeKollisionBox.scale = (Vector2(faktor, faktor))
	$Hitbox/areaKollisionBox.scale = (Vector2(faktor, faktor))



"""
Methode zum überprüfen ob eine neue Textur geladen werden muss, oder ob die aktuelle Textur noch
zum Verhalten des Users passt

@return true: wenn die aktuelle Textur sich von der neuen unterscheiden würde (bild ist noch seitlich, aber keine Bewegung mehr + anders herum)
Sonst false
"""
func spriteUpdateNoetig():
	#keine Bewegung und noch Seitlich
	if Bewegung.x == 0 and bilderSeitlich == true:
		bilderSeitlich = false
		return true
	#Bewegung und noch Starr
	elif Bewegung.x != 0 and bilderSeitlich == false:
		bilderSeitlich = true
		return true
	else:
		return false



"""
Wenn eine Münze berührt wurde muss blob passend darauf reagieren

Blobgröße wird in abhängigkeit von dem Wert der Münze verändert
Ebenfalls werden im Anschluss die Texturen verändert, sofern das nötig ist

@param wert: der Wert den die kollidierte Münze hatte
"""
func _on_Muenze_muenze_beruehrt(wert):
		blobGroesse = blobGroesse + wert
		blobVeranederung(false)


func verbinde_meunze(muenze):
	muenze.connect("muenze_beruehrt", self, "_on_Muenze_muenze_beruehrt")


"""
Wenn die Kanone das berührt wurde, soll Blob passend darauf reagieren
--> Blobgroeße wird um eine Stufe (5) reduziert

Textur des Blobs wird ebenfalls angepasst
"""
func _on_Kanone_kanoneberuehrte():
	blobGroesse = blobGroesse - 5
	blobVeranederung(false)