extends Node2D

onready var spieler = get_tree().get_root().get_child(0).get_node("Player")

func _ready():
	pass

func _process(delta):
	$Punkte.text = str(spieler.blobGroesse)

func _on_Optionen_gedrueckt():
	get_tree().change_scene("res://Szenen/Optionen.tscn")
