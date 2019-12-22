extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var seite1 = get_tree().get_root().get_node("Main").get_node("AlleOptionen").get_node("Seite1-Slider")
onready var seite2 = get_tree().get_root().get_node("Main").get_node("AlleOptionen").get_node("Seite2-Editoren")
onready var seite3 = get_tree().get_root().get_node("Main").get_node("AlleOptionen").get_node("Seite3-RandomCoin")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


# Führt das Spiel weiter, nachdem man in den Optionen war
func _on_Spielen_button_up():
	get_tree().paused = false
	print("Spielen")

# Wechselt auf die zweite Optionen-Seite
func _on_Seite2_button_up():
	seite1.visible = false
	seite2.visible = true
	seite3.visible = false

# Wechselt auf die erste Optionen-Seite
func _on_Seite1_button_up():
	seite1.visible = true
	seite2.visible = false
	seite3.visible = false

# Wechselt auf die dritte Optionen-Seite
func _on_Seite3_button_up():
	seite1.visible = false
	seite2.visible = false
	seite3.visible = true
