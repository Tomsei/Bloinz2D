extends Area2D

#Skript des Schutz Schilds. 
#Sobald Schutz aktiv ist werden die negativen Münzen abgeblock

onready var schutzTimer = get_node("Schutz_Dauer")



#Konstruktor | Wird aufgerufen beim ersten Frame nach der instanzierung
#Setzt die existenzzeit des Schutzes auf 5 Sekunden
func _ready():
	schutzTimer.set_wait_time(7) # Länge des Schutzes
	
	
	

#Methode wird jeden Frame aufgerufen. Es werden Badcoins blockiert
func _process(delta):
	blockiere_negative_muenzen() 



#Methode um alle Badcoins die erkannt werden zu blocken
func blockiere_negative_muenzen():
	for body in self.get_overlapping_bodies():
	#Für alle Kollisionen prüfen ob Kollision ein Badcoin ist
	#Blockieren einleiten 
		if body.has_method("blockiereMuenze"):
			body.blockiereMuenze()




#Methode zum entfernen des Schutzes
#nach Ablauf der Schutzzeit -> Schutz verschwinden lassen 
# -Schutzt verstecken | Zeit stoppen
# -Collision Layer setzen, dass keine Coins mehr erkannt werde
func _on_Schutz_Dauer_timeout():
	self.hide()
	self.set_collision_layer_bit(0, false)
	schutzTimer.stop()



#Wenn der Schutzt neu geladen wurde soll der Timer gestartet werden
#und das Collision Layer wieder die Münzen erkennen
func _on_Schutz_draw():
	self.set_collision_layer_bit(0,true)
	schutzTimer.start()

