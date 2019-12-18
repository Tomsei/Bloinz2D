extends Area2D

onready var schutzTimer = get_node("Schutz_Dauer")


"""
Konstruktor | Wird aufgerufen beim ersten Frame nach der instanzierung
Setzt die existenzzeit des Schutzes auf 5 Sekunden
"""
func _ready():
	schutzTimer.set_wait_time(7)
	
	
	
"""
Methode wird jeden Frame aufgerufen
"""
func _process(delta):
	blockiere_negative_muenzen() 
	#Hier möglicherweise noch Performance Problem, dass immer auch wenn Schutzt versteckt ist alle Body geprüft werden



"""
Methode um alle Badcoins die erkannt werden zu blocken
"""
func blockiere_negative_muenzen():
	for body in self.get_overlapping_bodies():
		if body.has_method("blockiereMuenze"):
			body.blockiereMuenze()



"""
Nachdem die Schutzzeit abgelaufen ist soll der Schutzschrim wieder verschwinden
--> Schutzt verstecken | Collision Layer setzen, dass keine Coins mehr erkannt werde | Zeit stoppen
"""
func _on_Schutz_Dauer_timeout():
	self.hide()
	self.set_collision_layer_bit(0, false)
	schutzTimer.stop()


"""
Wenn der Schutzt neu geladen wurde soll der Timer gestartet werden
und das Collision Layer wieder die Münzen erkennen
"""
func _on_Schutz_draw():
	self.set_collision_layer_bit(0,true)
	schutzTimer.start()

