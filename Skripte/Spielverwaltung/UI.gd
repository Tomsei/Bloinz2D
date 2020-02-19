extends Node2D

onready var spieler = get_tree().get_root().get_node("Main").get_node("Spiel").get_node("Player")
onready var gewonnen = get_tree().get_root().get_node("Main").get_node("Ende").get_node("EndeGewonnen")
onready var verloren = get_tree().get_root().get_node("Main").get_node("Ende").get_node("EndeVerloren")
onready var spiel = get_tree().get_root().get_node("Main").get_node("Spiel")
onready var ende = get_tree().get_root().get_node("Main").get_node("Ende")
onready var anleitung = get_tree().get_root().get_node("Main").get_node("Anleitung")

func _ready():
	pass

func _process(delta):
	# Noch in die Logik verschieben!
	if spieler != null:
		$PunkteAnzeige.value = spieler.blobGroesse 
		$PunkteAnzeige/PunkteAnzeigePunkt.value = spieler.blobGroesse


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

