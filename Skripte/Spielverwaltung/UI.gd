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
	if get_tree().paused == true:
		get_tree().paused = false
		anleitung.visible = false
		get_node("AnleitungOeffnen").visible = false
	else:
		get_tree().paused = true
		get_node("AnleitungOeffnen").visible = true


func _on_AnleitungOeffnen_button_up():
	print("test")
	get_node("AnleitungOeffnen").visible = false
	anleitung.visible = true

