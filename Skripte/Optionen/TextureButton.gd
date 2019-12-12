extends TextureButton

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Start_button_up():
	print("Spiel starten")
	get_tree().change_scene("res://Szenen/Oberflaeche/Spieloberflaeche.tscn")
	
func _on_Nochmal_button_up():
	print("Erneut spielen")
	get_tree().change_scene("res://Szenen/Oberflaeche/Spieloberflaeche.tscn")
	
func _on_Optionen_button_up():
	print("Einstellungen")
	get_tree().change_scene("res://Szenen/Oberflaeche/Optionen.tscn")

func _on_CodeEditor_button_up():
	print("gehe zum Editor")
	get_tree().change_scene("res://Szenen/Editoren/textedit.tscn")

func _on_MalenEditor_button_up():
	print("Wechsle zum malen")
	get_tree().change_scene("res://Szenen/Editoren/Malen.tscn")


func _on_SpielStarten_button_up():
	print("Spiel starten")
	get_tree().change_scene("res://Szenen/Oberflaeche/Spieloberflaeche.tscn")


func _on_NochmalSpielen_button_up():
	print("Erneut spielen")
	get_tree().change_scene("res://Szenen/Oberflaeche/Spieloberflaeche.tscn")


func _on_mehr_pressed():
	print("Weitere Einstellungen")
	get_tree().change_scene("res://Szenen/Oberflaeche/WeitereOptionen.tscn")


func _on_zurueck_button_up():
	print("Zurück zu Einstellungen")
	get_tree().change_scene("res://Szenen/Oberflaeche/Optionen.tscn")


func _on_zumSpiel_button_up():
	print("Spielen")
	get_tree().change_scene("res://Szenen/Oberflaeche/Spieloberflaeche.tscn")


func _on_CodeAnpassen_button_up():
	print("gehe zum Editor")
	get_tree().change_scene("res://Szenen/Editoren/textedit.tscn")


func _on_DemoEinstellen_button_up():
	print("Demo Einstellungen")
	get_tree().change_scene("res://Szenen/Oberflaeche/DemoEinstellungen.tscn")
