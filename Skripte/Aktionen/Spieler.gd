extends KinematicBody2D

#Spieler Szene / Klasse
#In der Klasse ist das Verhalten des Spielers implementiert:

#Bewegung (laufen / Springen) abhängig von Tastatru Eingabe
#Veränderung des Spieleraussehens  abhängig von der Spier Größe
#Kollisionserkennung mit anderen Spiel Objekten
#Spielerverhalten nach Neustart eines Spiels

""" ----------------------------------------------------------- """
""" Probiere doch mal die Werte hier zu anderen Zahlen zu ändern"""
""" ----------------------------------------------------------- """

#Variablen für die Spielerbewegung
var geschwindigkeit = 500
var Schwerkraft = 400
var Sprungkraft = 500


#Bewegungsvariable als Vektor -> X und Y Bewegung speicherbar
var Bewegung = Vector2()
#Orientierungsvektor der der nach oben zeigt (Zum Top des Spiels) 
#Wichtig: y = -1 wegen gedrehter Y Achse (- geht nach oben)
var up_Vektor = Vector2(0,-1)


#Blob Eigenschaften für das Springen
var doppelter_Sprung = false 			#wurde doppelSprung bereits ausgeführt oder nicht?
var hoechste_Blob_Hoehe = 409 			#maximaleBlobhöhe in Sprung
var bounce_Anzahl = 0
var bounce_Kraft = 1000 - position.y 	#Wie stark wird gebouncet
var sprung_Rest_Bewegung = 0 				#Seitliche Bewegung im Sprung

var blob_Groesse = 12 		#die aktuelle Spielergröße
var bilder_Seitlich = false
const boden_Hoehe = 482
var spieler_Auf_Boden


#Variablen zur Unterscheidung von Blob Stadien
var blobstatus = blobStati.NEUTRAL
# Repraesentation der Blobstati.
enum blobStati {NEGATIV2, NEGATIV1, NEUTRAL, POSITIV1, POSITIV2}


#Variablen zum Bilder Einladen
var bilder = SpriteFrames.new()
var persistenz = preload("res://Szenen/Spielverwaltung/Persistenz.tscn").instance()

signal spielVerloren
signal spielGewonnen


#Methode wird zu Beginn des Spiels aufgerufen. Ist also der Konstruktor der Klasse
#Spielerposition setzen Bilder Laden + Kollisionsbox erstellen
func _ready():
	#Blob Positionieren
	position.x = 224
	#Blob Bilder laden
	lade_sprites()
	
	#Am Start ist der blob im neutralen Zustand
	$AnimatedSprite.play("neutral_gerade")
	#Speileinstellungen übernehmen
	einstellungen.setzeSpielerEinstellungen(Sprungkraft, geschwindigkeit)
	erstelle_Kollisionsbox("Blob_3_gerade")




#Methode wird bei jedem Bild / Frame aufgerufen
#Führt die aktuelle Bewegung des Spielers in Abhängigkeit zu den Eingaben aus
#Es wird die Sprungkurve ermittelt + das Bouncen wenn nötig durchgeführt
#
#@param delta ist die Zeit zwischen zwei Bildern 
#-> ermöglicht flüssige Spieler Bewegung

func _physics_process(delta):
	
	#Berechnung der Bewegung:
	Bewegung.x = 0; #ohne Eingabe keine rechts / links Bewegung
	
	#Schwerkraftberechnung -> langer Fall = stärker fallen
	#delta -> mit jedem Bild stärkere Schwerkraft
	Bewegung.y = Bewegung.y + Schwerkraft * delta*2
	
	#Bewegung abhängig der User Eingaben
	pruefe_User_Eingaben()
	ermittel_Maximal_Hoehe()
	
	#Bouncekraft für 1 Bounce bestimmen 
	if bounce_Anzahl == 0:
		bounce_Kraft = 1000-hoechste_Blob_Hoehe 
	
	#zusätliche Sprungbewegung (Bouncen / Sprungkurve)
	weitere_Sprungbewegung()
	
	#Bewegungsausführung | Up Vektor um zu erkennen was der Boden ist
	move_and_slide(Bewegung, up_Vektor);
	
	kollisions_Pruefung()
	boden_Erkennung()
	
	#Spieler Position auf Spielfeld begrenzen
	position.x = clamp(position.x, 0, 448)
	position.y = clamp(position.y, -200, 483)





""" --------------------------------------- """
""" Lassen sich die Tasteneingaben umdrehen """
""" um bei ui_right nach links zu laufen?   """
""" --------------------------------------- """
#Methode ermittelt Tastatureingaben und reagiert passend darauf
#Abhängig von Eingabe Rechts Links Bewegung
#Wenn Spieler in der Luft -> Kurven Bewegung addieren
#Die Setilichen Bilder abspielen, bei Bewegung 
func pruefe_User_Eingaben():
	
	var bild_Groesse
	
	#Nach rechts --> Blob nach rechts bewegen
	if Input.is_action_pressed("ui_right"):
		Bewegung.x += 1 * geschwindigkeit
		if !spieler_Auf_Boden:
			sprung_Rest_Bewegung = 1*geschwindigkeit
		
		#Wenn nötig Bild Textur auf setilich ändern
		if bild_Update_Noetig():
			blob_Veraenderung(true)
			$AnimatedSprite.flip_h = false #Spiegelung des seitlichen Richtung
			positioniere_Bild_Zu_Kollisionsbox(false)
	
	#Nach links --> Blob nach links bewegen
	if Input.is_action_pressed("ui_left"):
		Bewegung.x -= 1 * geschwindigkeit
		if !spieler_Auf_Boden:
			sprung_Rest_Bewegung = -1*geschwindigkeit
		
		#Wenn nötig Bild Textur auf setilich ändern
		if bild_Update_Noetig():
			blob_Veraenderung(true)
			$AnimatedSprite.flip_h = true #Spiegelung des seitlichen Richtung
			positioniere_Bild_Zu_Kollisionsbox(true)
	
	#Bei keiner Bewegung muss gerade Bild geladen werden
	if !Input.is_action_just_pressed("ui_left") and !Input.is_action_just_pressed("ui_right"):
		if bild_Update_Noetig():
			blob_Veraenderung(false)
	
	#Sprunginput gerade gekommen --> springen
	if Input.is_action_just_pressed("jump"):
		sprung() #Die Methode zum Springen wird genutzt





#Sprung Methode berechnet das Springen 
#Der Sprung wird in 4 unterschiedliche Verhaltensweisen aufgeteilt
# 1. Der Blob befindet sind auf dem Boden
#--> Der Blob soll normal Springen, 
# 2. Der Blob befindet sich auf dem Boden ist aber nocht im Bounce Durchgang
#--> Kein Springen ist möglich
# 3. Der Blob befindet sich in der Luft und hat noch keinen Doppelsprung ausgeführt
#--> Der Blob soll ebenfalls springen können
# 4. Der Blob befindet sich in der Luft und hat bereits einen Doppelsprung ausgeführt
#--> es ist kein Sprung für den Blob erlaubt
func sprung():
	
	#höchste Blob Höhe resetten
	hoechste_Blob_Hoehe = boden_Hoehe
	
	#Der Blob befindet sich auf dem Boden
	if spieler_Auf_Boden:
		doppelter_Sprung = false
		Bewegung.y = - Sprungkraft #negativ (Y Achse gedreht)
		sprung_Rest_Bewegung = 0 #Sprungkurve nicht am Boden weiter
		
		#Nach 3 Bounces Anzahl resetten (Neuer Bounce für neuen Sprung)
		if bounce_Anzahl == 3:
			bounce_Anzahl = 0 
		
	#Wenn noch kein doppelSprung ausgeführt wurde den Sprungimpuls geben
	elif doppelter_Sprung == false:
		Bewegung.y = -Sprungkraft
		doppelter_Sprung = true



#Methode zum ermitteln der höchsten Position des Spielers nach seinem Flug
#Es wird geprüft ob aktuelle höhe des Spielers höher ist als die gespeicherte.
#Wenn sie Höher ist wird neue blobHoehe gespeichert
func ermittel_Maximal_Hoehe():
	
	if !spieler_Auf_Boden:
		if position.y < hoechste_Blob_Hoehe:
			hoechste_Blob_Hoehe = position.y




#Methode um die fortlaufenden Bewegungen des Blobs zu berechnen
# 1. es wird das Bouncen Des Blobs berechnent und ausgeführt
# --> zuätlicher Bounce Impuls, wenn Spieler auf Boden + Bouncanzahl nicht überschritten
# 2. Die Sprunkruve wird berechnet -> leichts nachziehen der Sprungrichtung 
func weitere_Sprungbewegung():
	
	#Bei Boden Berührung keine Sprungkruve
	if spieler_Auf_Boden:
		sprung_Rest_Bewegung = 0
		
	#Bounce nur wenn BLob auf boden + bounce_Anzahl nicht überschritten 
	if spieler_Auf_Boden and bounce_Anzahl < 3 and position.y > boden_Hoehe and not Input.is_action_just_pressed("jump"):
		bounce_Kraft = bounce_Kraft/2        #nächste Bounce halb so hoch
		Bewegung.y = -bounce_Kraft           #Bounce Impuls setzen
		bounce_Anzahl = bounce_Anzahl+1        
		sprung_Rest_Bewegung = 0             #Kein Kurve nach Bodenberührung

	
	#In der Luft ohne weitere Richtungseingabe -> Sprungkurve ermitteln
	elif !Input.is_action_pressed("ui_left") and !Input.is_action_pressed("ui_right") and !spieler_Auf_Boden:
		sprung_Rest_Bewegung = sprung_Rest_Bewegung / 1.05  #Bewegungsgeschwindigkeit verringern
		Bewegung.x = sprung_Rest_Bewegung


#Methode zum Erkennen ob Spieler den Boden berührt oder nicht
#Über die Kollisionen der Spieler Hitbox wird ermittelt ob der Boden berührt wird
func boden_Erkennung():
	#gibt es überhaubt eine Kollision
	if $Hitbox.get_overlapping_bodies().size() == 0:
		spieler_Auf_Boden = false
	#wenn ja Prüfe ob die Kollision der Boden ist
	else:
		for body in $Hitbox.get_overlapping_bodies():
			if body.get_name() == "BodenCollisionShape":
				spieler_Auf_Boden = true
			else:
				spieler_Auf_Boden = false



#Methode zum erkennen von Kollisionen mit anderen Objekten
#für alle erkannten Objekte welche in die Area des Blobs gekommen sind 
#wird die Methode blobKollision aufgerufen, sofern diese vorhanden ist
#--> somit können die Objekte passend auf Kollision mit Spielfigur reagieren
func kollisions_Pruefung():
	
	for body in $Hitbox.get_overlapping_bodies():
		if body.has_method("blob_Kollision"):
			body.blob_Kollision()


#Methode zur Reaktion auf eine Münz Berührung
#Blobgröße wird in abhängigkeit von dem Wert der Münze verändert
#eine mögliche Blob Veränderung wird eingeleitet
#@param wert: der Wert den die kollidierte Münze hatte
func _on_Muenze_muenze_beruehrt(wert):
		blob_Groesse = blob_Groesse + wert
		blob_Veraenderung(false)


""" --------------------------------------- """
""" Ist die Kanone Zu Stark? Sie könnte bei """
""" einer Kollision auch Punkte bringen     """
""" --------------------------------------- """
#Methode zur Reaktion auf eine Berührung mit der Rakete 
# Blobgroeße wird um eine Stufe (5) reduziert
# Textur des Blobs wird ebenfalls angepasst
func _on_Kanone_kanoneberuehrte():
	blob_Groesse = blob_Groesse - 5
	blob_Veraenderung(false)


#Methode um die Geschwindigkeit des Spielers zu verändern
# @geschwindigkeitsDifferenz ist der Wert der auf die Geschwindigkeit hinzugerechnet wird
# --> negativer Wert verringert die Geschwindigkeit | positiver Wert erhöht die Geschwindigkeit
func veraendere_Spieler_Geschwindigkeit(var geschwindigkeitsDifferenz):
	geschwindigkeit = geschwindigkeit + geschwindigkeitsDifferenz


#Methoden um die aktuellen Einstellungen in die OptionsSlider zu übertargen
func _on_Spiel_hide():
	einstellungen.setzeSpielerEinstellungen(Sprungkraft,geschwindigkeit)



#Methode wird ausgeführt sobald der Spieler Sichtbar wird
#also wenn das Spiel wieder startet nach Optionen / Spielneustart
# -Die Spieler Ausrichtung wird vorgenommen
# -Spieleinstellungen der Optionen werden übernommen
func _on_Spiel_draw():
	spielstart_Ausrichtung()
	if einstellungen.geschwindigkeitGeaendert:
		print("sliderGeschwindigkeit")
		geschwindigkeit = einstellungen.uebernehmeGeschwindigkeit()
		einstellungen.geschwindigkeitGeaendert = false
	if einstellungen.sprungkraftGeaendert:
		print ("sliderSprungkraft")
		Sprungkraft = einstellungen.uebernehmeSprungkraft()
		einstellungen.sprungkraftGeaendert = false


#Methode zum Ausrichten des Spielers (Spielstart)
#Position + Größe und weitere Eigenschaften auf Standard setzen
func spielstart_Ausrichtung():
	blob_Groesse = 12
	position.x = 224
	position.y = 483
	sprung_Rest_Bewegung = 0
	blobstatus = blobStati.NEUTRAL
	hoechste_Blob_Hoehe = 530
	
	$AnimatedSprite.play("neutral_gerade")
	erstelle_Kollisionsbox("Blob_3_gerade")
	$Schutz._on_Schutz_Dauer_timeout()


#Methode zum Ändern eines Spielers
#Abhängig von der Größe wird passendes Bild gesetzt
#Bei Stufenwechsel wird ein Sound abgespielt und eine neue Kollisionsbox ermittelt
# -Sobald die Blobgröße kleiner 0 ist, ist das Spiel verloren
# -Sobald die Blobgrößer größer als 25 ist, ist das Spiel gewonnen
# -Für die Anderen Stufen werden jeweils die passenden Bilder gesetzt + Sound abgespielt
#@param setilich gibt an ob sich der Blob gerade in einer seitlichen Bewegung befindet

func blob_Veraenderung(var seitlich):
	
	#switch Casse über alle Größen des Blobs es wird jeweils das passende Bild gesetzt
	#Zustäzlich wird überprüft ob Blob in Bewegung bzw. seitlich ist
	match blob_Groesse:
		-1,-2,-3,-4,-5:
			emit_signal("spielVerloren")
			$AnimatedSprite.play("neutral_gerade")
			
		0, 1, 2, 3, 4:
			# Prueft ob der Blobstatus sich veraendet hat.
			if blobstatus > blobStati.NEGATIV2:
				# Wenn der Blob vorher groesser war wird der aktuelle Status angepasst.
				blobstatus = blobStati.NEGATIV2
				# Spiele den Sound fuer das Schrumpfen.
				$AudioStreamPlayer2D.abspielen("Schrumpfen")
				erstelle_Kollisionsbox("Blob_1_gerade")
			
			if seitlich:
				$AnimatedSprite.play("negativ_2_seitlich")
			else:
				$AnimatedSprite.play("negativ_2_gerade")
				
		5, 6, 7, 8, 9:
			# Prueft ob der Blobstatus sich veraendet hat. Sound + Status anpassen
			if blobstatus > blobStati.NEGATIV1:
				blobstatus = blobStati.NEGATIV1
				$AudioStreamPlayer2D.abspielen("Schrumpfen")
				erstelle_Kollisionsbox("Blob_2_gerade")
			elif blobstatus < blobStati.NEGATIV1:
				blobstatus = blobStati.NEGATIV1
				$AudioStreamPlayer2D.abspielen("Wachsen")
				erstelle_Kollisionsbox("Blob_2_gerade")
				
			if seitlich:
				$AnimatedSprite.play("negativ_1_seitlich")
			else:
				$AnimatedSprite.play("negativ_1_gerade")
		
		10, 11, 12, 13, 14:
			# Prueft ob der Blobstatus sich veraendet hat. Sound + Status anpassen
			if blobstatus > blobStati.NEUTRAL:
				blobstatus = blobStati.NEUTRAL
				$AudioStreamPlayer2D.abspielen("Schrumpfen")
				erstelle_Kollisionsbox("Blob_3_gerade")
			elif blobstatus < blobStati.NEUTRAL:
				blobstatus = blobStati.NEUTRAL
				$AudioStreamPlayer2D.abspielen("Wachsen")
				erstelle_Kollisionsbox("Blob_3_gerade")
			
			if seitlich:
				$AnimatedSprite.play("neutral_seitlich")
			else:
				$AnimatedSprite.play("neutral_gerade")
			
		15, 16, 17, 18, 19:
			# Prueft ob der Blobstatus sich veraendet hat. Sound + Status anpassen
			if blobstatus > blobStati.POSITIV1:
				blobstatus = blobStati.POSITIV1
				$AudioStreamPlayer2D.abspielen("Schrumpfen")
				erstelle_Kollisionsbox("Blob_4_gerade")
			elif blobstatus < blobStati.POSITIV1:
				blobstatus = blobStati.POSITIV1
				$AudioStreamPlayer2D.abspielen("Wachsen")
				erstelle_Kollisionsbox("Blob_4_gerade")
			
			if seitlich:
				$AnimatedSprite.play("positiv_1_seitlich")
			else:
				$AnimatedSprite.play("positiv_1_gerade")
		
		20, 21, 22, 23, 24:
			# Prueft ob der Blobstatus sich veraendet hat. Sound + Status anpassen
			if blobstatus < blobStati.POSITIV2:
				blobstatus = blobStati.POSITIV2
				$AudioStreamPlayer2D.abspielen("Wachsen")
				erstelle_Kollisionsbox("Blob_5_gerade")
			
			if seitlich:
				$AnimatedSprite.play("positiv_2_seitlich")
			else:
				$AnimatedSprite.play("positiv_2_gerade")
				
		25, 26, 27, 28, 29:
			emit_signal("spielGewonnen")
			$AnimatedSprite.play("neutral_gerade")


#Methode zum überprüfen ob eine neue Textur geladen werden muss, 
#oder ob die aktuelle Textur noch zur Stufe des Users passt
#Aufgeteilt in zwei Fälle: Bewegung findet statt + Bild star 
# Keine Bewegung + Bild seitlich
#
#@return true: wenn die aktuelle Textur sich von der neuen unterscheiden würde 
# sonst false
func bild_Update_Noetig():
	#keine Bewegung und noch Seitlich
	if Bewegung.x == 0 and bilder_Seitlich == true:
		bilder_Seitlich = false
		return true
	#Bewegung und noch Starr
	elif Bewegung.x != 0 and bilder_Seitlich == false:
		bilder_Seitlich = true
		return true
	else:
		return false


#Methode um eine Passende Kollisionsbox für ein Bild zu erstellen
#Damit eigene Bilder auch passende Kollisionsbox erhalten
#Über die gespeicherten Größen der Bilder wird ein gewünschtes Shape erstellt
#
#@param stufe: für welche Blobstufe (Bild) das Polygon erstellt werden soll
func erstelle_Kollisionsbox(var stufe):
	#Bild Größen Ermitteln
	var alle_Groessen = einstellungen.figurengroesse
	var bild_Groesse = alle_Groessen[stufe]
	
	#Passende Bild Maße berechnen
	var bild_breite = bild_Groesse[1].x - bild_Groesse[0].x
	var bild_hoehe = bild_Groesse[1].y - bild_Groesse[0].y
	
	#Shape erstellen
	var shape = RectangleShape2D.new()
	shape.set_extents(Vector2(bild_breite/2,bild_hoehe/2))
	
	#Verschiebung der Hitbox auf die passende Stelle berechnen
	var untere_Verschiebung = ((bild_Groesse[0].y) + (63-bild_Groesse[1].y))/2
	
	#Kollisionsbox setzen + ausrichten
	$Hitbox/areaKollisionBox.set_shape(shape)
	$AnimatedSprite.position.x = 0
	$AnimatedSprite.position.x += 32-bild_Groesse[0].x - bild_breite/2
	
	$Hitbox/areaKollisionBox.position.y = 0
	$Hitbox/areaKollisionBox.position.y += (untere_Verschiebung)
	$AnimatedSprite.position.y = 0
	if bild_Groesse[1].y != 63:
		$AnimatedSprite.position.y += (63-bild_Groesse[1].y)


#Methode um KollsisionBox und Bild jeweils übereinander zu legen nachdem sie Gespiegelt wurden
#Abhängig von der aktuellen Spieler Stufe wird die passende Bild Größe ermittelt
#Über die Bild Größe lässt sich eine passende Translation (Verschiebung) des Bildes im Spiel berechnen
#
#@param gespiegelt gibt an ob das Bild gerade gespiegelt wird oder nicht
func positioniere_Bild_Zu_Kollisionsbox(var gespiegelt):
	
	#Ermitteln der Blob Stufe
	var stufe
	match blob_Groesse:
		0, 1, 2, 3, 4:
			stufe = "Blob_1_gerade"
		5, 6, 7, 8, 9:
			stufe = "Blob_2_gerade"
		10, 11, 12, 13, 14:
			stufe = "Blob_3_gerade"
		15, 16, 17, 18, 19:
			stufe = "Blob_4_gerade"
		20, 21, 22, 23, 24:
			stufe = "Blob_5_gerade"
	
	#passende Größe zum aktuellen Bild ermitteln
	var alle_Groessen = einstellungen.figurengroesse
	var bild_Groesse = alle_Groessen[stufe]
	
	#Passende Bild Maße berechnen
	var bild_breite = bild_Groesse[1].x - bild_Groesse[0].x
	var bild_hoehe = bild_Groesse[1].y - bild_Groesse[0].y
	
	#Passende Positionierung des Bildes
	$AnimatedSprite.position.x = 0
	if gespiegelt:
		 $AnimatedSprite.position.x += 32 - (63-bild_Groesse[1].x) - bild_breite/2
	else:
		$AnimatedSprite.position.x += 32-bild_Groesse[0].x - bild_breite/2



#Methode zum einladen der einzelnen Blobbilder in den Spieler
func lade_sprites():
	bilder = SpriteFrames.new()
	setze_animationeigenschaften("negativ_1_gerade","Blob_2_gerade")
	setze_animationeigenschaften("negativ_1_seitlich","Blob_2_seitlich")
	
	setze_animationeigenschaften("negativ_2_gerade","Blob_1_gerade")
	setze_animationeigenschaften("negativ_2_seitlich","Blob_1_seitlich")
	
	setze_animationeigenschaften("neutral_gerade","Blob_3_gerade")
	setze_animationeigenschaften("neutral_seitlich","Blob_3_seitlich")
	
	setze_animationeigenschaften("positiv_1_gerade","Blob_4_gerade")
	setze_animationeigenschaften("positiv_1_seitlich","Blob_4_seitlich")
	
	setze_animationeigenschaften("positiv_2_gerade","Blob_5_gerade")
	setze_animationeigenschaften("positiv_2_seitlich","Blob_5_seitlich")
	
	$AnimatedSprite.frames = bilder

#Grundlegende Methode zum Zuweisen der Bilder
func setze_animationeigenschaften(animationsname, bildname):
	var texture = persistenz.lade_bildtextur("res://Bilder/Standardspielfiguren/Spielfiguren/" + bildname + ".png")
	bilder.add_animation(animationsname)
	bilder.add_frame(animationsname, texture)
	bilder.set_animation_loop(animationsname,true)
	bilder.set_animation_speed(animationsname, 5.0)
