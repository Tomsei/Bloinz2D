extends TextureButton

onready var optionen = get_tree().get_root().get_child(1).get_node("Optionen")
onready var mehrOptionen = get_tree().get_root().get_child(1).get_node("Optionen").get_node("WeitereOptionen")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# Ruft den Spielstart auf
func _on_Start_button_up():
	print("Spiel starten")
	get_tree().change_scene("res://Szenen/Oberflaeche/Spieloberflaeche.tscn")
	get_tree().paused = false

# Ruft das Spiel nochmal auf, nachdem man gewonnen/verloren hat
func _on_Nochmal_button_up():
	print("Erneut spielen")
	get_tree().change_scene("res://Szenen/Oberflaeche/Spieloberflaeche.tscn")

# Öffnet die Optionen vom Startbildschirm aus
func _on_Optionen_button_up():
	print("Einstellungen")
	optionen.visible = true
	get_tree().paused = false
	get_tree().change_scene("res://Szenen/Oberflaeche/Spieloberflaeche.tscn")


# Öffnet den Malen-Editor aus den Optionen
func _on_MalenEditor_button_up():
	print("Wechsle zum malen")
	get_tree().change_scene("res://Szenen/Editoren/Malen.tscn")

# Startet das Spiel vom Startbildschirm
func _on_SpielStarten_button_up():
	print("Spiel starten")
	get_tree().change_scene("res://Szenen/Oberflaeche/Spieloberflaeche.tscn")


func _on_NochmalSpielen_button_up():
	print("Erneut spielen")
	get_tree().change_scene("res://Szenen/Oberflaeche/Spieloberflaeche.tscn")

# Geht von den normalen Einstellungen zu den weiteren Optionen
func _on_mehr_pressed():
	print("Weitere Einstellungen")
	mehrOptionen.visible = true;

# Geht von den Weiteren Optionen zurück zu den normalen Einstellungen
func _on_zurueck_button_up():
	print("Zurück zu Einstellungen")
	mehrOptionen.visible = false

# Geht von den (weiteren) Optionen zurück zum Spiel
func _on_zumSpiel_button_up():
	print("Spielen")
	mehrOptionen.visible = false
	optionen.visible = false
	get_tree().paused = false

func _on_CodeAnpassen_button_up():
	print("gehe zum Editor")
	get_tree().change_scene("res://Szenen/Editoren/textedit.tscn")


func _on_DemoEinstellen_button_up():
	print("Demo Einstellungen")
	get_tree().change_scene("res://Szenen/Oberflaeche/DemoEinstellungen.tscn")
