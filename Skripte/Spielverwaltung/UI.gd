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
		if spieler.blobGroesse < 0:
			spielVerloren()
		if spieler.blobGroesse >= 25:
			spielGewonnen()

# Wechsel vom Spiel zum Gewonnen-Bildschirm
func spielGewonnen():
	# AnimatedSprite muss noch auf grün geändert werden
	spieler.blobGroesse = 12
	spiel.visible = false
	ende.visible = true
	gewonnen.visible= true
	verloren.visible = false
	get_tree().paused = true

# Wechsel vom Spiel zum Verloren-Bildschirm
func spielVerloren():
	# AnimatedSprite muss noch auf grün geändert werden
	spieler.blobGroesse = 12
	spiel.visible = false
	ende.visible = true
	verloren.visible = true
	gewonnen.visible = false
	get_tree().paused = true

func _on_Pause_button_up():
	if get_tree().paused == true:
		get_tree().paused = false
	else:
		get_tree().paused = true
