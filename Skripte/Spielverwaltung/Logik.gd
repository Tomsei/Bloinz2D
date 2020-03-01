extends Node2D

#ready startet erst wenn onready Variablen geladen sind
#es werden die Benötigen Timer und Spielobjekte als Variable gespeichert
onready var raketenTimer = get_node("RaketenTimer")
onready var muenzTimer = get_node("MuenzTimer")
onready var muenzMagnetZeit = get_node("MuenzMagnetTimer")
onready var geschwindigkeitZeit = get_node("RC-Geschwindigkeit")
onready var raketenZeit = 10

onready var spieler = get_tree().get_root().get_node("Main").get_node("Spiel").get_node("Player")
onready var spiel = get_tree().get_root().get_node("Main").get_node("Spiel")
onready var ende = get_tree().get_root().get_node("Main").get_node("Ende")
onready var gewonnen = get_tree().get_root().get_node("Main").get_node("Ende").get_node("EndeGewonnen")
onready var verloren = get_tree().get_root().get_node("Main").get_node("Ende").get_node("EndeVerloren")


var muenzmagnetAktiv = false #Läuft der Münzmagnet
var erhoete_Geschwindigkeit = false

#Variablen zum Prüfen welche Randomaktionen aus einstellungen aktiviert sind
var randomCoinFunktionMuenzregen
var randomCoinFunktionMagnet
var randomCoinFunktionSchutz
var randomCoinFunktionGeschwindigkeit
var raondomCoinAn = true


#Methode wird zum start der Szene aufgerufen
#Alle benötigten Timer werden jeweils gestartet
# -alle ... Sekunden eine Rakte / Coin ...
# -setzendie benötigten Zeiten zu den Random Aktionen
func _ready():
	raketenTimer.set_wait_time(raketenZeit)
	raketenTimer.start()
	muenzTimer.set_wait_time(1)
	muenzTimer.start()
	muenzMagnetZeit.set_wait_time(7)
	muenzMagnetZeit.start()
	geschwindigkeitZeit.set_wait_time(7)
	einstellungen.setzeRaketenzeit(raketenZeit)


#Methode wird bei jedem Frame aufgerufen
#stellt sicher, dass CoinMagnet übermittelt werden kann
func _process(delta):
	uebermittelt_Coin_Magnet()



#Methode zum erstellen einer Münz Instanz --> es wird eine Münze als neue Szene instanziert
#Zufällig wird eine Zahl ermittelt mit welcher dann eine zufällige Unterklasse der Münzen
#ausgewählt wird. Damit Münze Funktionstüchtig müssen die Signale gesetzt werden
func erstelle_Muenze():
	
	#passende Zufallszahl ermitteln
	var zufall
	
	#Nur Wenn Random Coin Aktiv ist soll dieser in der Auswahl berücksichtigt werden
	if raondomCoinAn:
		zufall = random_Zahl_Zwischen(0,10)
	else:
		zufall = random_Zahl_Zwischen(0,9)
	
	#Variablen zum erzeugen einer neuen Münz Instanz
	var muenze
	var istrandom = false
	
	#Zufalls auswahl von einer Münze über die Zufallszahl und einem Switch-Case
	match zufall:
		0,1,2: 
			muenze = load("res://Szenen/Muenzen/goodCoin1.tscn")
		3,4: 
			muenze = load("res://Szenen/Muenzen/goodCoin2.tscn")
		5,6, 7: 
			muenze = load("res://Szenen/Muenzen/badCoin1.tscn")
		8,9: 
			muenze = load("res://Szenen/Muenzen/badCoin2.tscn")
		10: 
			muenze = load("res://Szenen/Muenzen/randomCoin.tscn")
			istrandom = true #Die neue Münze ist ein Random Coin
	
	var neu = muenze.instance() #Instance mit der passenden Subklasse erzeugen
	 
	#die Signale müssen verknüpft werden
	neu.connect("muenze_beruehrt", spieler, "_on_Muenze_muenze_beruehrt")
	
	#Für den Randomcoin muss ein weiteres Signal verknüpft werden
	if (istrandom):
		neu.connect("randomAktion", self, "_on_randomMuenze_randomAktion")
	
	add_child(neu) #Münze wird gesamt Spiel hinzugefügt


#Methode zum erstellen einer Münze nach Münz Zeit 
func _on_MuenzTimer_timeout():
	erstelle_Muenze()




#Methode zum erstellen einer neuen Instanz der Szene / Klasse Kanone
#Kanonen Szene wird geladen, instanziert, die Signale verbunden und hinzugefügt
func erstelle_Kanone():
	var kanone = load("res://Szenen/Spielfiguren/Kanone.tscn")
	var neu = kanone.instance()
	
	#Das Signal der Kanone verbinden
	neu.connect("kanoneberuehrt", spieler, "_on_Kanone_kanoneberuehrte")
	add_child(neu)


#Methode zum erstellen einer Kanone nach Raketenzeit 
func _on_Timer_timeout():
	erstelle_Kanone()





#Methode um eine Random zahl aus einem Zahlenbereich auszuwählen
#@param von: Startzahl des Bereichs
#@param bis: Endzahl des Bereichs
#@return: eine Random Zahl aus dem Bereich
func random_Zahl_Zwischen(var von, var bis):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var zufall = rng.randi_range(von,bis)
	return zufall



#Methode zum übermitteln an den Spieler, dass ein Magnet aktiviert wurde
#Wenn Münzmagnet aktiv ist wird für den Spieler (einziges Kind mit Methode muenzMagnet)
#Magnet Methode ausgeführt
func uebermittelt_Coin_Magnet():
	if muenzmagnetAktiv:
		#aus allen Objekten im Spiel den SPieler ermitteln 
		#und Münzmagnet durchführen
		var kinder = get_children()
		for i in kinder.size():
			if kinder[i].has_method("muenzMagnet"):
				kinder[i].muenzMagnet(spieler.position.x)



#Methode die eine Random Aktion auswählt, sobald ein Random Coin berührt wurde
#Die aktivierten RandomCoin Aktionen werden in einer Liste gespeichert um daraus auszuwählen
#Über eine Randomzahl wird mittels Switch-Case eine zufällige Methode ausgeführt
#
func _on_randomMuenze_randomAktion():
	
	#am Anfang werden die Aktionen in die Liste Geschrieben, welche überhaubt aktiviert sind
	#hierbei werden die ausgeschalteten Aktionen rausgeworfen.
	var randomCoinAktionen = []
	
	if randomCoinFunktionMuenzregen:
		randomCoinAktionen.append("Muenze")
	
	if randomCoinFunktionSchutz:
		randomCoinAktionen.append("Schutz")
	
	if randomCoinFunktionMagnet:
		randomCoinAktionen.append("Magnet")
	
	if randomCoinFunktionGeschwindigkeit:
		randomCoinAktionen.append("Geschwindigkeit")
	
	#Nur wenn es eine RandomAktion gab wird der Auswahl Prozess gestartet
	if randomCoinAktionen.size() != 0:
		
		#Zufällige es Element aus dem Array von Aktionen wählen
		var zufall = random_Zahl_Zwischen(0,randomCoinAktionen.size()-1)
		var aktion = randomCoinAktionen[zufall]
		
		#Passende Aktion ausführen
		match aktion:
			"Muenze": randomAktion_erstelle_Muenzen()
			"Schutz": randomAktion_erstelleSchutz()
			"Magnet": randomAktion_muenzMagnet()
			"Geschwindigkeit": randomAktion_spielerGeschwindigkeit()
	#ansonsten Wird der Randomcoin deaktiviert, da er keine Aktionen ausführt
	else:
		raondomCoinAn = false



#Methode für Randomaktion zum erstellen von 5 weiteren Münzen
func randomAktion_erstelle_Muenzen():
	for i in 5:
		erstelle_Muenze()


#Methode für Randomatkionen die den Schutz anschaltet
func randomAktion_erstelleSchutz():
	spieler.get_node("Schutz").show()


#Methode für Randomaktion die den Münzmagnet anschaltet
func randomAktion_muenzMagnet():
	muenzmagnetAktiv = true
	muenzMagnetZeit.start()
	spieler.get_node("Magnet").show()


#Methode für Randomaktion zum erhöhen der Geschwindigkeit des Spielers
#wird nur durchgeführt wenn Spieler nicht bereits schneller
func randomAktion_spielerGeschwindigkeit():
	if !erhoete_Geschwindigkeit:
		spieler.veraendere_Spieler_Geschwindigkeit(300)
		erhoete_Geschwindigkeit = true
		geschwindigkeitZeit.start()



#Methode zum deaktivieren des Magnetens nach der Magnet Zeit
func _on_RandomCoinZeit_timeout():
	muenzmagnetAktiv = false
	spieler.get_node("Magnet").hide()

#Methode zum verringern der Geschwindigkeit nach der Zeit
func _on_RCGeschwindigkeit_timeout():
	if erhoete_Geschwindigkeit:
		spieler.veraendere_Spieler_Geschwindigkeit(-300)
		erhoete_Geschwindigkeit = false









#Methode zur Einstellungs Synchronisation zu Beginn
#Einstellungen der Random Coins + Raketenzeit wird aus den Optionen übermittelt
func _on_Spiel_draw():
	if einstellungen.raketenzeitGeaendert:
		raketenZeit = einstellungen.uebernehmeRaketenzeit()
		raketenTimer.set_wait_time(raketenZeit)
		einstellungen.raketenzeitGeaendert = false
	raondomCoinAn = einstellungen.randomCoinAn
	#Variablen zum Prüfen welche Randomaktionen aktiviert sind
	randomCoinFunktionMuenzregen = einstellungen.CoinRegenAn;
	randomCoinFunktionMagnet = einstellungen.CoinMagnetAn;
	randomCoinFunktionSchutz = einstellungen.RegenschirmAn;
	randomCoinFunktionGeschwindigkeit = einstellungen.SpeedboostAn;
	

#Methode zur Sychronisation der Raktenzeit beim Szenen Wechsel
func _on_Spiel_hide():
	einstellungen.setzeRaketenzeit(raketenZeit)


#Methode bei einem gewonnenen Spiel
#Passende Szene wird gezeigt + vorliegende Elemetnte werden entfernt
func _on_Player_spielGewonnen():
	spiel.visible = false
	ende.visible = true
	gewonnen.visible= true
	verloren.visible = false
	get_tree().paused = true
	entferne_Spielobjekte()



#Methode bei verlorenem Spiel
#Passende Szene wird gezeigt + vorliegende Elemetnte werden entfernt
func _on_Player_spielVerloren():
	spiel.visible = false
	ende.visible = true
	verloren.visible = true
	gewonnen.visible = false
	get_tree().paused = true
	entferne_Spielobjekte()


#Methode um alle Münzen und Raketen beim Ende eines Spiels zu entfernen
#Zusätlich werden alle Random Aktionen gestoppt
func entferne_Spielobjekte():
	
	#Alle Objekte nach dem ab dem 5 Kind entfernen
	var i = 5 
	while is_instance_valid(get_child(i)):
		get_child(i).queue_free()
		i = i+1
	
	#Random Aktionen stoppen
	_on_MuenzTimer_timeout()
	_on_RandomCoinZeit_timeout()
	_on_RCGeschwindigkeit_timeout()
 