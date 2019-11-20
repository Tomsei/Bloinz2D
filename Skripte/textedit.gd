extends Node2D

# Variablen
var te1
var te2
var cur_tab = 0

# Funktion welche beim start aufgerufen wird.
func _ready():
	# Rufe die Funktion init_te auf.
	init_te()
	OS.set_window_size(Vector2(800,600))
# Die Funktion wird automatisch bei jedem Frameändern aufgerufen.
func _process(delta):
	#print("juhu")
	pass

# Lädt eine Datei und gibt den Text der Datei zurück.
func lade_datei(pfad):
	var datei = File.new()
	var err = datei.open(pfad, File.READ)
	if err != OK:
		printerr("Datei konnte nicht geladen werden, error code ", err)
		return ""
	var text = datei.get_as_text()
	datei.close()
	return text

# Speichert Text in eine Datei mit angegebenem Pfad.
func save_file(text, pfad):
	var datei = File.new()
	var err = datei.open(pfad, File.WRITE)
	if err != OK:
		printerr("Fehler beim Schreiben in Datei, error Code:", err)
		return
	datei.store_string(text)
	datei.close()


# Wird aufgerufen, wenn der Knopf losgelassen wird.
func _on_Button_button_up():
	# Godot version von switch.
	# cur_tab ist der aktuell sichtbare Tab.
	match cur_tab:
		0:
			print("tab 1")
			save_te1()
		1:
			print("tab 2")
			save_te2()

# Verarbeite das Speichern des Inhalts von TextEdit.
func save_te1():
	save_file(te1.get_text(), "res://Skripte/Bewegung/Player.gd")
	print("speichern")
	get_tree().change_scene("res://Szenen/Player.tscn")
	OS.set_window_size(Vector2(440,700))

# Verarbeite das Speichern des Inhalts von TextEdit2.
func save_te2():
	var label = get_node("Label")
	label.set_text(te2.get_text())
	print("changed label")

# Wenn ein anderer Tab sichtbar wird, wird dieser in cur_tab gespeichert.
func _on_TabContainer_tab_changed(tab):
	cur_tab = tab

# Weise den Variabeln te1 und te2 ihre Nodes zu.
# Lade den Inhalt der Textedits.
func init_te():
	te1 = get_node("TabContainer/TextEdit")
	te2 = get_node("TabContainer/TextEdit2")
	
	te1.set_text(lade_datei("res://Skripte/Bewegung/Player.gd"))
	var label = get_node("Label")
	te2.set_text(label.get_text())