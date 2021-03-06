extends Node2D

onready var spieler = get_tree().get_root().get_node("Main").get_node("Spiel").get_node("Player")
onready var gewonnen = get_tree().get_root().get_node("Main").get_node("Ende").get_node("EndeGewonnen")
onready var verloren = get_tree().get_root().get_node("Main").get_node("Ende").get_node("EndeVerloren")
onready var spiel = get_tree().get_root().get_node("Main").get_node("Spiel")
onready var ende = get_tree().get_root().get_node("Main").get_node("Ende")
onready var anleitung = get_tree().get_root().get_node("Main").get_node("Anleitung")


func _process(delta):
	# Noch in die Logik verschieben!
	if spieler != null:
		$PunkteAnzeige.value = spieler.blob_Groesse 
		$PunkteAnzeige/PunkteAnzeigePunkt.value = spieler.blob_Groesse


func _on_Pause_toggled(button_pressed):
	print(button_pressed);
	if button_pressed:
		get_tree().paused = true
	else:
		get_tree().paused = false
		if anleitung.visible == true:
			anleitung.visible = false
			get_node("AnleitungOeffnen").visible = true


func _on_AnleitungOeffnen_button_up():
	get_node("Pause").pressed = true
	_on_Pause_toggled(true)
	get_node("AnleitungOeffnen").visible = false
	anleitung.visible = true

# Zentriert das Fenster in der Bildschirmmitte
func bildschirm_zentrieren():
	# Aktuelle Bildschirmgroesse
	var screen_size = OS.get_screen_size()
	# Aktuelle Fenstergroesse
	var window_size = OS.get_window_size()
	
	# Setzt das Fenster in die Mitte des Bildschirms
	OS.set_window_position(screen_size*0.5 - window_size*0.5)