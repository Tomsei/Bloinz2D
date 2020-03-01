extends Node2D

#ready startet erst wenn onready Variablen geladen sind
onready var raketenTimer = get_node("RaketenTimer")
onready var muenzTimer = get_node("MuenzTimer")
onready var randomCoinZeit = get_node("RandomCoinZeit")
onready var geschwindigkeitZeit = get_node("RC-Geschwindigkeit")
onready var raketenZeit = 10

onready var spieler = get_tree().get_root().get_node("Main").get_node("Spiel").get_node("Player")
onready var spiel = get_tree().get_root().get_node("Main").get_node("Spiel")
onready var ende = get_tree().get_root().get_node("Main").get_node("Ende")
onready var gewonnen = get_tree().get_root().get_node("Main").get_node("Ende").get_node("EndeGewonnen")
onready var verloren = get_tree().get_root().get_node("Main").get_node("Ende").get_node("EndeVerloren")

var muenzmagnetAktiv = false
var raondomCoinAn = true

#Variablen zum Prüfen welche Randomaktionen aktiviert sind
var randomCoinFunktionMuenzregen;
var randomCoinFunktionMagnet;
var randomCoinFunktionSchutz;
var randomCoinFunktionGeschwindigkeit;


"""
Methode wird zum start der Szene aufgerufen
Alle benötigten Timer werden jeweils gestartet
	(alle ... Sekunden eine Rakte / Coin ...)
	(die benötigten Zeiten zu den Random Aktionen)
"""
func _ready():
	raketenTimer.set_wait_time(raketenZeit)
	raketenTimer.start()
	muenzTimer.set_wait_time(1)
	muenzTimer.start()
	randomCoinZeit.set_wait_time(7)
	randomCoinZeit.start()
	geschwindigkeitZeit.set_wait_time(7)
	
	einstellungen.setzeRaketenzeit(raketenZeit)

"""
Aufruf bei jedem Frame
stellt sicher, dass CoinMagnet übermittelt werden kann
"""
func _process(delta):
	uebermittelCoinMagnet()

"""
Methode zum übermitteln an den Spieler, dass ein Magnet aktiviert wurde
Wenn Münzmagnet aktiv ist wird für den Spieler (einziges Kind mit Methode muenzMagnet)
Magnet Methode ausgeführt
"""
func uebermittelCoinMagnet():
	if muenzmagnetAktiv:
		var kinder = get_children()
		for i in kinder.size():
			if kinder[i].has_method("muenzMagnet"):
				kinder[i].muenzMagnet(spieler.position.x)


"""
Methode zum erstellen einer Münz Instanz --> es wird eine Münze als neue Szene instanziert
Zufällig wird eine Zahl ermittelt mit welcher dann eine zufällige Unterklasse der Münzen
ausgewählt wird
"""
func erstelleMuenze():
	
	#ermitteln einer Random Zahl Zufall
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var zufall
	
	#Nur Wenn Random Coin Aktiv ist soll auch eine Münze erstellt werden können
	if raondomCoinAn:
		zufall = rng.randi_range(0,10)
	else:
		zufall = rng.randi_range(0,9)
	
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
	#neu.connect("neueMuenze", self, "_on_Muenze_neueMuenze")
	
	#Für den Randomcoin muss ein weiteres Signal verknüpft werden
	if (istrandom):
		neu.connect("randomAktion", self, "_on_randomMuenze_randomAktion")
	
	add_child(neu) #Münze wird gesamt Spiel hinzugefügt



"""
Methode zum erstellen einer neuen Instanz der Szene / Klasse Kanone
Kanonen Szene wird geladen, instanziert, die Signale verbunden und hinzugefügt
"""
func erstelleKanone():
	var kanone = load("res://Szenen/Spielfiguren/Kanone.tscn")
	var neu = kanone.instance()
	
	#Das Signal der Kanone verbinden
	neu.connect("kanoneberuehrt", spieler, "_on_Kanone_kanoneberuehrte")
	add_child(neu)


"""
Methode die eine Random Aktion auswählt, sobald ein Random Coin berührt wurde
Über eine Randomzahl wird mittels Switch-Case eine zufällige Methode ausgeführt
"""
func _on_randomMuenze_randomAktion():
	
	
	
	#am Anfang werden die Aktionen in die Liste Geschrieben, welche überhaubt aktiviert sind
	var randomCoinAktionen = []
	
	if randomCoinFunktionMuenzregen:
		randomCoinAktionen.append("Muenze")
	
	if randomCoinFunktionSchutz:
		randomCoinAktionen.append("Schutz")
	
	if randomCoinFunktionMagnet:
		randomCoinAktionen.append("Magnet")
	
	if randomCoinFunktionGeschwindigkeit:
		randomCoinAktionen.append("Geschwindigkeit")
	
	print (randomCoinAktionen)
	
	#Nur wenn es eine RandomAktion gab wird der Auswahl Prozess gestartet
	if randomCoinAktionen.size() != 0:
		
		#Zufällige es Element aus dem Array von Aktionen wählen
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var zufall = rng.randi_range(0,randomCoinAktionen.size()-1)
		var aktion = randomCoinAktionen[zufall]
		
		print (aktion)
		
		match aktion:
			"Muenze": randomAktion_erstelleMuenzen()
			"Schutz": randomAktion_erstelleSchutz()
			"Magnet": randomAktion_muenzMagnet()
			"Geschwindigkeit": randomAktion_spielerGeschwindigkeit()
	#ansonsten Wird der Randomcoin deaktiviert, da er keine Aktionen ausführt
	else:
		raondomCoinAn = false


"""
Randomaktion zum erstellen von 5 weiteren Münzen
"""
func randomAktion_erstelleMuenzen():
	for i in 5:
		erstelleMuenze()

"""
Randomatkionen die den Schirm anschaltet
"""
func randomAktion_erstelleSchutz():
	spieler.get_node("Schutz").show()

"""
Randomaktion die den Münzmagnet anschaltet
"""
func randomAktion_muenzMagnet():
	muenzmagnetAktiv = true
	randomCoinZeit.start()
	spieler.get_node("Magnet").show()


var erhoehteGeschwindigkeit = false
"""
Randomaktion zum erhöhen der Geschwindigkeit des Spielers
wird nur durchgeführt wenn Spieler nicht bereits schneller
"""
func randomAktion_spielerGeschwindigkeit():
	if !erhoehteGeschwindigkeit:
		spieler.veraendere_Spieler_Geschwindigkeit(300)
		erhoehteGeschwindigkeit = true
		geschwindigkeitZeit.start()


"""
Nach der Raketenzeit soll eine Kanone erstellt werden
"""
func _on_Timer_timeout():
	erstelleKanone()

	
"""
nach der Münzzeit soll eine Münze erstellt werden
"""
func _on_MuenzTimer_timeout():
	erstelleMuenze()

"""
Nach der Münzmagnet Zeit soll dieser wieder inaktiv werden
"""
func _on_RandomCoinZeit_timeout():
	muenzmagnetAktiv = false
	spieler.get_node("Magnet").hide()


"""
Nach der Zeit der Geschwindigkeit, soll Spieler wieder langsamer werden
"""
func _on_RCGeschwindigkeit_timeout():
	if erhoehteGeschwindigkeit:
		spieler.veraendere_Spieler_Geschwindigkeit(-300)
		erhoehteGeschwindigkeit = false


func _on_Spiel_draw():
	if einstellungen.raketenzeitGeaendert:
		print("slider")
		raketenZeit = einstellungen.uebernehmeRaketenzeit()
		print(raketenZeit)
		raketenTimer.set_wait_time(raketenZeit)
		einstellungen.raketenzeitGeaendert = false
	raondomCoinAn = einstellungen.randomCoinAn
	#Variablen zum Prüfen welche Randomaktionen aktiviert sind
	randomCoinFunktionMuenzregen = einstellungen.CoinRegenAn;
	randomCoinFunktionMagnet = einstellungen.CoinMagnetAn;
	randomCoinFunktionSchutz = einstellungen.RegenschirmAn;
	randomCoinFunktionGeschwindigkeit = einstellungen.SpeedboostAn;
	


func _on_Spiel_hide():
	einstellungen.setzeRaketenzeit(raketenZeit)


func _on_Player_spielGewonnen():
	spiel.visible = false
	ende.visible = true
	gewonnen.visible= true
	verloren.visible = false
	get_tree().paused = true
	entferne_Spielobjekte()

	


func _on_Player_spielVerloren():
	spiel.visible = false
	ende.visible = true
	verloren.visible = true
	gewonnen.visible = false
	get_tree().paused = true
	entferne_Spielobjekte()



func entferne_Spielobjekte():
	var i = 5
	while is_instance_valid(get_child(i)):
		get_child(i).queue_free()
		i = i+1
	_on_MuenzTimer_timeout()
	_on_RandomCoinZeit_timeout()
	_on_RCGeschwindigkeit_timeout()
 