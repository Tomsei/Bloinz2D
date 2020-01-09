extends Node2D

#ready startet erst wenn onready Variablen geladen sind
onready var raketenTimer = get_node("RaketenTimer")
onready var muenzTimer = get_node("MuenzTimer")
onready var randomCoinZeit = get_node("RandomCoinZeit")
onready var geschwindigkeitZeit = get_node("RC-Geschwindigkeit")
onready var raketenZeit = 6

onready var spieler = get_tree().get_root().get_node("Main").get_node("Spiel").get_node("Player")

var muenzmagnetAktiv = false


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
	var zufall = rng.randi_range(0,10)
	

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
	neu.connect("neueMuenze", self, "_on_Muenze_neueMuenze")
	
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
	
	#Zufallszahl ermitteln
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var zufall = rng.randi_range(0,3)

	match zufall:
		0: randomAktion_erstelleMuenzen()
		1: randomAktion_erstelleSchutz()
		2: randomAktion_muenzMagnet()
		3: randomAktion_spielerGeschwindigkeit()


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


var erhoehteGeschwindigkeit = false
"""
Randomaktion zum erhöhen der Geschwindigkeit des Spielers
wird nur durchgeführt wenn Spieler nicht bereits schneller
"""
func randomAktion_spielerGeschwindigkeit():
	if !erhoehteGeschwindigkeit:
		spieler.veraendereSpielerGeschwindigkeit(300)
		erhoehteGeschwindigkeit = true
		geschwindigkeitZeit.start()


#Gerade wird alle 10 Sekunden die Kanone erzeugt
func _on_Timer_timeout():
	erstelleKanone()

	

func _on_MuenzTimer_timeout():
	erstelleMuenze()

func _on_RandomCoinZeit_timeout():
	muenzmagnetAktiv = false



func _on_RCGeschwindigkeit_timeout():
	if erhoehteGeschwindigkeit:
		spieler.veraendereSpielerGeschwindigkeit(-300)
		erhoehteGeschwindigkeit = false


func _on_Spiel_draw():
	pass
	raketenZeit = einstellungen.uebernehmeRaketenzeit()
	print(raketenZeit)
	raketenTimer.set_wait_time(raketenZeit)
	#raketenTimer.start()


func _on_Spiel_hide():
	einstellungen.setzeRaketenzeit(raketenZeit)
