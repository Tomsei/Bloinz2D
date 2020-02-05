extends Timer


onready var muenzenTimer = get_tree().get_root().get_node("Main").get_node("Start").get_node("MuenzenTimer")
onready var spieler = get_tree().get_root().get_node("Main").get_node("Spiel").get_node("Player")
onready var start = get_tree().get_root().get_node("Main").get_node("Start")

# Called when the node enters the scene tree for the first time.
func _ready():
	muenzenTimer.set_wait_time(2)
	#muenzenTimer.start()
	#erstelleMuenze()


func erstelleMuenze():
	#ermitteln einer Random Zahl Zufall
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var zufall = rng.randi_range(0,10)
	

	#Variablen zum erzeugen einer neuen Münz Instanz
	var muenze
	
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
	
	var neu = muenze.instance() #Instance mit der passenden Subklasse erzeugen

	 
	#die Signale müssen verknüpft werden
	neu.connect("neueMuenze", self, "_on_Muenze_neueMuenze")
	
	start.add_child(neu) #Münze wird gesamt Spiel hinzugefügt

# Erstelle jedes Mal, wenn der Timer abläuft, eine Münze
func _on_MuenzenTimer_timeout():
	erstelleMuenze()

# Wenn der Startbildschirm ausgeblendet wird, wird der Timer beendet
func _on_Start_hide():
	muenzenTimer.stop()

