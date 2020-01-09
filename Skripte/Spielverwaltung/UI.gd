extends Node2D

onready var spieler = get_tree().get_root().get_node("Main").get_node("Spiel").get_node("Player")
onready var gewonnen = get_tree().get_root().get_node("Main").get_node("Ende").get_node("EndeGewonnen")
onready var verloren = get_tree().get_root().get_node("Main").get_node("Ende").get_node("EndeVerloren")
onready var spiel = get_tree().get_root().get_node("Main").get_node("Spiel")
onready var ende = get_tree().get_root().get_node("Main").get_node("Ende")

func _ready():
	pass

func _process(delta):
	# Noch in die Logik verschieben!
	if spieler != null:
		$PunkteAnzeige.value = spieler.blobGroesse 
		$PunkteAnzeige/PunkteAnzeigePunkt.value = spieler.blobGroesse

func _on_Pause_button_up():
	if get_tree().paused == true:
		get_tree().paused = false
	else:
		get_tree().paused = true
