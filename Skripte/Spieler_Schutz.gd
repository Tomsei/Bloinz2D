extends Area2D

onready var schutzTimer = get_node("Schutz_Dauer")

# Called when the node enters the scene tree for the first time.
func _ready():
	schutzTimer.set_wait_time(5)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	blockiere_negative_muenzen()
	

func blockiere_negative_muenzen():
	for body in self.get_overlapping_bodies():
		if body.has_method("blockiereMuenze"):
			body.blockiereMuenze()


"""
Nachdem die Schutzzeit abgelaufen ist soll der Schutzschrim wieder verschwinden
"""
func _on_Schutz_Dauer_timeout():
	self.hide()
