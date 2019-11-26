extends Node2D

# Variablen
var te1
var te2
var cur_tab = 0
var block = [{}]
var aktuell_angezeigte_funktion

# Funktion welche beim start aufgerufen wird.
func _ready():
	# Rufe die Funktion init_te auf.
	init_te()
	OS.set_window_size(Vector2(800,600))
	te1.cursor_set_column(30)
	#print(block[0])
	# Zeige die ausgewaehlte Funktion an.
	setze_aktuell_angezeigte_funktion()
	zeige_funktion(block[0].get(aktuell_angezeigte_funktion)[0],block[0].get(aktuell_angezeigte_funktion)[1], true)

# Die Funktion wird automatisch bei jedem Frameändern aufgerufen.
func _process(delta):
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
	OS.set_window_size(Vector2(384,512))
	get_tree().change_scene("res://Szenen/Player.tscn")
	

# Verarbeite das Speichern des Inhalts von TextEdit2.
func save_te2():
	var label = get_node("Label")
	label.set_text(te2.get_text())
	print("changed label")

# Wenn ein anderer Tab sichtbar wird, wird dieser in cur_tab gespeichert.
func _on_TabContainer_tab_changed(tab):
	cur_tab = tab
	# Setzt den Fokus auf den aktuellen Tab.
	get_node("TabContainer").get_child(cur_tab).grab_focus()

# Weise den Variabeln te1 und te2 ihre Nodes zu.
# Lade den Inhalt der Textedits.
func init_te():
	te1 = get_node("TabContainer/TextEdit")
	te2 = get_node("TabContainer/TextEdit2")
	
	te1.set_text(lade_datei("res://Skripte/Bewegung/Player.gd"))
	
	find_functions(te1)
	# Farbe fuer Kommentare auf Gruen setzen.
	te1.add_color_region("#", ".", Color(0,1.0,0), true)
	# Name des Tabs setzten.
	te1.name = "Spieler"
	# Erster Tab bekommt Fokus beim initialisieren.
	te1.grab_focus()
	#Deaktiviere eine Zeile.
	#te1.set_line_as_hidden(3, true)
	
	# Setze Cursor auf Zeile 30.
	#te1.cursor_set_line(30, false)
	var label = get_node("Label")
	te2.set_text(label.get_text())

func find_functions(textedit):
	for i in (textedit.get_line_count()):
		# Verstecke alle Zeilen.
		te1.set_line_as_hidden(i, true)
		define_blocks(textedit, textedit.get_line(i), i)

func define_blocks(textedit, text, zeile):
	var index = 0
	var function_found = (text.find("func ", index) != -1)
	if function_found:
		var texts = text.split(" ")
		for i in range (texts.size()):
			if texts[i] == "func":
				# Setze den Funktionsnamen und lösche den Doppelpunkt
				var funktions_name = texts[i + 1].rstrip(":")
				block[cur_tab][funktions_name] = [gib_funktionsanfang(textedit, zeile + 1),gib_funktionsende(textedit,zeile + 1)]
				get_node("Funktionsauswahl").add_item(funktions_name)
				
				break

# Gibt die Zeile des Funktionsendes.
func gib_funktionsende(textedit, zeile):
	var funktionsende = zeile
	while (textedit.get_line(funktionsende).substr(0,1) == "\t"):
		funktionsende += 1
	return funktionsende - 1

# Gibt die Zeile des Funktionsanfangs. Die Zeilen sind immer +1 zu sehen.
func gib_funktionsanfang(textedit, zeile):
	var funktionsanfang = zeile - 1
	while ((funktionsanfang == zeile - 1) || textedit.get_line(funktionsanfang).substr(0,1) == "#"):
		funktionsanfang -= 1
	return funktionsanfang + 1

# Zeigt Zeilen von start_zeile bis end_zeile an.
func zeige_funktion(start_zeile, end_zeile, zeige):
	# end_zeile + 1 weil range exklusiv ist.
	for i in range(start_zeile, end_zeile + 1):
		get_node("TabContainer").get_child(cur_tab).set_line_as_hidden(i, !zeige)

func setze_aktuell_angezeigte_funktion():
	aktuell_angezeigte_funktion = get_node("Funktionsauswahl").get_item_text(get_node("Funktionsauswahl").selected)

func _on_Funktionsauswahl_getroffen(ID):
	zeige_funktion(block[0].get(aktuell_angezeigte_funktion)[0],block[0].get(aktuell_angezeigte_funktion)[1], false)
	setze_aktuell_angezeigte_funktion()
	zeige_funktion(block[0].get(aktuell_angezeigte_funktion)[0],block[0].get(aktuell_angezeigte_funktion)[1], true)
