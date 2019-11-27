extends Node


#ready startet erst wenn onready Variablen geladen sind
onready var timer = get_node("Timer")

# Called when the node enters the scene tree for the first time.
func _ready():
	erstelleMuenze()
	timer.set_wait_time(10)
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$RichTextLabel.text = str($Player.blobGroesse)
	



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
	
	#die Signale müssen verknüpft werden
	neu.connect("muenze_beruehrt", $Player, "_on_Muenze_muenze_beruehrt")
	neu.connect("neueMuenze", self, "_on_Muenze_neueMuenze")
	
	add_child(neu)


#Methode zum erstellen einer neuen Instanz der Szene / Klasse Kanone
func erstelleKanone():
	var kanone = load("res://Szenen/Kanone.tscn")
	
	var neu = kanone.instance()
	
	#Das Signal der Kanone verbinden
	neu.connect("kanoneberuehrt", $Player, "_on_Kanone_kanoneberuehrte")
	add_child(neu)


#Signal zum erstellen einer neuen Münze
func _on_Muenze_neueMuenze():
	erstelleMuenze() 



#Gerade wird alle 10 Sekunden die Kanone erzeugt
func _on_Timer_timeout():
	erstelleKanone()
