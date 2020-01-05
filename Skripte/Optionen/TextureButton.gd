extends TextureButton

onready var optionen = get_tree().get_root().get_node("Main").get_node("AlleOptionen")
onready var start = get_tree().get_root().get_node("Main").get_node("Start")
onready var ende = get_tree().get_root().get_node("Main").get_node("Ende")
onready var spiel = get_tree().get_root().get_node("Main").get_node("Spiel")
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
	seite1.visible = true
	seite2.visible = false
	seite3.visible = false


"""
# Ruft den Spielstart auf
func _on_Start_button_up():
	print("Spiel starten")
	spiel_starten()
	#get_tree().change_scene("res://Szenen/Oberflaeche/Spieloberflaeche.tscn")
	#get_tree().paused = false

# Ruft das Spiel nochmal auf, nachdem man gewonnen/verloren hat
func _on_Nochmal_button_up():
	print("Erneut spielen")
	spiel_starten()

# Öffnet die Optionen vom Startbildschirm aus
func _on_Optionen_button_up():
	print("Einstellungen")
	optionen.visible = true
	get_tree().paused = true
	#get_tree().change_scene("res://Szenen/Oberflaeche/Spieloberflaeche.tscn")


# Öffnet den Malen-Editor aus den Optionen
func _on_MalenEditor_button_up():
	print("Wechsle zum malen")
	get_tree().change_scene("res://Szenen/Editoren/Malen.tscn")

func _on_NochmalSpielen_button_up():
	print("Erneut spielen")
	get_tree().change_scene("res://Szenen/Oberflaeche/Spieloberflaeche.tscn")

# Geht von den normalen Einstellungen zu den weiteren Optionen
func _on_mehr_pressed():
	print("Weitere Einstellungen")
	#mehrOptionen.visible = true;

# Geht von den Weiteren Optionen zurück zu den normalen Einstellungen
func _on_zurueck_button_up():
	print("Zurück zu Einstellungen")
	#mehrOptionen.visible = false

# Geht von den (weiteren) Optionen zurück zum Spiel
func _on_zumSpiel_button_up():
	print("Spielen")
	#mehrOptionen.visible = false
	optionen.visible = false
	get_tree().paused = false

func _on_CodeAnpassen_button_up():
	print("gehe zum Editor")
	get_tree().change_scene("res://Szenen/Editoren/textedit.tscn")


func _on_DemoEinstellen_button_up():
	print("Demo Einstellungen")
	get_tree().change_scene("res://Szenen/Oberflaeche/DemoEinstellungen.tscn")

func spiel_starten():
	get_tree().paused = false
	
	start.visible = false
	optionen.visible = false
	ende.visible = false
	spiel.visible = true

func _on_Spielen_button_up():
	pass # Replace with function body.
"""


