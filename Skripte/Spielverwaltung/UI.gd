extends Node2D

onready var spieler = get_tree().get_root().get_child(0).get_node("Player")

func _ready():
	pass

func _process(delta):
	$Punkte.text = str(spieler.blobGroesse)
	$PunkteAnzeige.value = spieler.blobGroesse
	if spieler.blobGroesse < 0:
		get_tree().change_scene("res://Szenen/Oberflaeche/Endbildschirm_Verloren.tscn")
	if spieler.blobGroesse >= 25:
		get_tree().change_scene("res://Szenen/Oberflaeche/Endbildschirm_Gewonnen.tscn")

func _on_Optionen_button_up():
	print("gehe zu Einstellungen")
	get_tree().change_scene("res://Szenen/Oberflaeche/Optionen.tscn")

