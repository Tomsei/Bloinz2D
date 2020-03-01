extends Node2D

#Klasse / Szene repräsentiert das Warn Signal vor einer Kanone
#Das Signal erschein für eine Sekunge an der Position
#abhängig von der spawnenden Rakete


onready var warnzeit = get_node("Warnzeit") #Zeit die das Ausrufezeichen zu sehen ist



#Aufruf beim instanzieren der Szene
#Startet den Timer
func _ready():
	warnzeit.set_wait_time(0.8)
	warnzeit.start()


#Warnung wird links positioniert 
func warnungLinks(var hoehe):
	position.x = 15
	position.y = hoehe


#Warnung wird rechts positioniert
func warnungRechts(var hoehe):
	position.x = 433
	position.y = hoehe


#nach Warnzeit soll Warnung wieder verschwinden
func _on_WarnZeit_timeout():
	queue_free()
