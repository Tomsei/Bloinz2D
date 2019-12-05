extends Node2D


#ready startet erst wenn onready Variablen geladen sind
onready var raktetenTimer = get_node("RaketenTimer")
onready var muenzTimer = get_node("MuenzTimer")

onready var spieler = get_tree().get_root().get_child(0).get_child(2)


func _ready():
	raktetenTimer.set_wait_time(2)
	raktetenTimer.start()
	muenzTimer.set_wait_time(1)
	muenzTimer.start()
	erstelleMuenze()



var test1 = 0
var test2 = 0
var test3 = 0
var test4 = 0
var test5 = 0


#Methode die eine neue Instanz einer Münze erstellt | Bisher wird Münze als neue Szene instanziert
func erstelleMuenze():
	
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var zufall = rng.randi_range(0,9)
	#Zufalls auswahl von einer Münze

	
	var muenze
	var istrandom = false
	#Switch über zufällige Zahl, damit eine zufallsmünze erstellt wird
	match zufall:
		0,1,2: 
			muenze = load("res://Szenen/Muenzen/randomCoin.tscn")
			test1 = test1+1
			istrandom = true
		2,3,4: 
			muenze = load("res://Szenen/Muenzen/goodCoin2.tscn")
			test2 = test2+1
		5,6: 
			muenze = load("res://Szenen/Muenzen/badCoin1.tscn")
			test3 = test3+1
		7,8: 
			muenze = load("res://Szenen/Muenzen/badCoin2.tscn")
			test4 = test4+1
		9: 
			muenze = load("res://Szenen/Muenzen/randomCoin.tscn")
			test5 = test5+1
			istrandom = true
	
	var neu = muenze.instance()
	
	#print (str(test1) + "  " + str(test2) + "  " + str(test3) + "  " + str(test4) + "  " + str(test5))
	 
	#die Signale müssen verknüpft werden
	neu.connect("muenze_beruehrt", spieler, "_on_Muenze_muenze_beruehrt")
	neu.connect("neueMuenze", self, "_on_Muenze_neueMuenze")
	
	if (istrandom):
		neu.connect("randomAktion", self, "_on_randomMuenze_randomAktion")
	
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


func _on_randomMuenze_randomAktion():
	for i in  5:
		erstelleMuenze()




#Gerade wird alle 10 Sekunden die Kanone erzeugt
func _on_Timer_timeout():
	erstelleKanone()

	

func _on_MuenzTimer_timeout():
	erstelleMuenze()
