extends TextureButton

onready var optionen = get_tree().get_root().get_node("Main").get_node("AlleOptionen")
onready var start = get_tree().get_root().get_node("Main").get_node("Start")
onready var ende = get_tree().get_root().get_node("Main").get_node("Ende")
onready var spiel = get_tree().get_root().get_node("Main").get_node("Spiel")
onready var pauseButton = spiel.get_node("UI").get_node("Pause")
onready var anleitung = get_tree().get_root().get_node("Main").get_node("Anleitung")
onready var seite1 = optionen.get_node("Seite1-Slider")
onready var seite2 = optionen.get_node("Seite2-Editoren")
onready var seite3 = optionen.get_node("Seite3-RandomCoin")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# Startet das Spiel
func starteSpiel():
	start.visible = false
	optionen.visible = false
	ende.visible = false
	spiel.visible = true
	JavaScript.eval("resizeSpiel(640,448)")
	#print(einstellungen.erstesSpiel)
	if einstellungen.erstesSpiel:
		anleitung.visible = true
		einstellungen.erstesSpiel = false
	else:
		anleitung.visible = false
		get_tree().paused = false


# Startet das Spiel vom Startbildschirm
func _on_SpielStarten_button_up():
	print("Spiel starten")
	starteSpiel()

# Startet das Spiel erneut, nachdem gewonnen/verloren wurde
func _on_NochmalSpielen_button_up():
	print ("nochmal Spielen")
	# Spiel soll eigentlich richtig von vorne gespielt werden, nicht das alte mit neuer Blobgröße weitergespielt
	#spiel.get_node("Player").blobGroesse = 12
	starteSpiel()

# ruft die Optionen auf
func _on_Optionen_button_up():
	get_tree().paused = true
	
	start.visible = false
	optionen.visible = true
	ende.visible = false
	spiel.visible = false
	pauseButton.pressed = false 
	seite1.visible = true
	seite2.visible = false
	seite3.visible = false

# Wechselt zum Malen-Editor
func _on_MalenEditor_button_up():
	print("Wechsle zum malen")
	get_tree().paused = false
	JavaScript.eval("resizeSpiel(1000,1000)")
	get_tree().change_scene("res://Szenen/Editoren/Malen.tscn")

# Wechselt zum Code-Editor
func _on_CodeEditor_button_up():
	print("gehe zum Editor")
	get_tree().paused = false
	get_tree().change_scene("res://Szenen/Editoren/textedit.tscn")

#Öffnet das Popup, ob alle Änderungen zurückgesetzt werden sollen
func _on_AllesZuruecksetzen_button_up():
	get_node("../Popup").show()

