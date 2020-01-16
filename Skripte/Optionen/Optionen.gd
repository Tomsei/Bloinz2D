extends Node2D

onready var optionen = get_tree().get_root().get_node("Main").get_node("AlleOptionen")
onready var seite1 = optionen.get_node("Seite1-Slider")
onready var seite2 = optionen.get_node("Seite2-Editoren")
onready var seite3 = optionen.get_node("Seite3-RandomCoin")
onready var spiel = get_tree().get_root().get_node("Main").get_node("Spiel")
onready var anleitung = get_tree().get_root().get_node("Main").get_node("Anleitung")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


# Führt das Spiel weiter, nachdem man in den Optionen war
func _on_Spielen_button_up():
	optionen.visible = false
	spiel.visible = true
	print("Spielen")
	
	if einstellungen.erstesSpiel:
		anleitung.visible = true
		einstellungen.erstesSpiel = false
	else:
		anleitung.visible = false
		get_tree().paused = false


# Wechselt auf die erste Optionen-Seite
func _on_Seite1_button_up():
	seite1.visible = true
	seite2.visible = false
	seite3.visible = false

# Wechselt auf die zweite Optionen-Seite
func _on_Seite2_button_up():
	seite1.visible = false
	seite2.visible = true
	seite3.visible = false

# Wechselt auf die dritte Optionen-Seite
func _on_Seite3_button_up():
	seite1.visible = false
	seite2.visible = false
	seite3.visible = true


func _on_Ja_button_up():
	preload("res://Szenen/Spielverwaltung/Persistenz.tscn").instance().zuruecksetzen()
	$"Seite2-Editoren/Popup".hide()


func _on_Abbrechen_button_up():
	$"Seite2-Editoren/Popup".hide()
