extends Node2D


#ready startet erst wenn onready Variablen geladen sind
onready var raktetenTimer = get_node("RaketenTimer")
onready var muenzTimer = get_node("MuenzTimer")

onready var spieler = get_tree().get_root().get_child(0).get_child(2)


func _ready():
	raktetenTimer.set_wait_time(10)
	raktetenTimer.start()
	muenzTimer.set_wait_time(1)
	muenzTimer.start()
	erstelleMuenze()

#Methode die eine neue Instanz einer Münze erstellt | Bisher wird Münze als neue Szene instanziert
func erstelleMuenze():
	
	
	#Zufalls auswahl von einer Münze
	var zufall = randi() % 4
	
	var muenze
	
	#Switch über zufällige Zahl, damit eine zufallsmünze erstellt wird
	match zufall:
		0: muenze = load("res://Szenen/Muenzen/goodCoin1.tscn")
		1: muenze = load("res://Szenen/Muenzen/goodCoin2.tscn")
		2: muenze = load("res://Szenen/Muenzen/badCoin1.tscn")
		3: muenze = load("res://Szenen/Muenzen/badCoin2.tscn")
	
	var neu = muenze.instance()
	
	#var node = load("res://Szenen/Spieler.tscn").instance()
	#die Signale müssen verknüpft werden
	#print(spieler.get_script())
	#spieler.verbinde_meunze(neu)
	# node -> 
	#print(get_tree().get_root().get_child(0).get_child(2))
	neu.connect("muenze_beruehrt", spieler, "_on_Muenze_muenze_beruehrt")
	neu.connect("neueMuenze", self, "_on_Muenze_neueMuenze")
	
	add_child(neu)

#Signal zum erstellen einer neuen Münze
func _on_Muenze_neueMuenze():
	pass #erstelleMuenze() 
	
	
#Methode zum erstellen einer neuen Instanz der Szene / Klasse Kanone
func erstelleKanone():
	var kanone = load("res://Szenen/Kanone.tscn")
	
	var neu = kanone.instance()
	
	#Das Signal der Kanone verbinden
	neu.connect("kanoneberuehrt", spieler, "_on_Kanone_kanoneberuehrte")
	add_child(neu)

#Gerade wird alle 10 Sekunden die Kanone erzeugt
func _on_Timer_timeout():
	erstelleKanone()
	

func _on_MuenzTimer_timeout():
	erstelleMuenze()
