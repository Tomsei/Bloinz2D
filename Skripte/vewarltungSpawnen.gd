extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass# Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


#Methode die eine neue Instanz einer Münze erstellt | Bisher wird Münze als neue Szene instanziert
func erstelleMuenze():
	var muenze = load("res://Szenen/Muenze.tscn")
	var neu = muenze.instance()
	
	#die Signale müssen verknüpft werden
	neu.connect("m1_beruerht", $Player, "_on_Muenze_m1_beruerht")
	neu.connect("neueMuenze", self, "_on_Muenze_neueMuenze")
	
	add_child(neu)


#Signal zum erstellen einer neuen Münze
func _on_Muenze_neueMuenze():
	erstelleMuenze() 
