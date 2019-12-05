extends Node2D

# Variablen
var te1
var te2
var cur_tab = 0
var funktionen = [{}]
var variablen = [{}]
var funktionen_mit_variablen = [{}]
var aktuell_angezeigte_funktion

# Funktion welche beim start aufgerufen wird.
func _ready():
	# Initiiere Parameter.
	init()
	# Tests
	#te1.cursor_set_column(30)
	#print(funktionen_mit_variablen[0])

func init():
	OS.set_window_size(Vector2(800,600))
	get_node("Funktionsauswahl").add_item("alle")
	init_te()
	# Zeige die ausgewaehlte Funktion an.
	setze_aktuell_angezeigte_funktion()
	_on_Funktionsauswahl_getroffen(0)
	weise_variablen_funktionen_zu()
	#zeige_zeilen(funktionen[0].get(aktuell_angezeigte_funktion)[0],funktionen[0].get(aktuell_angezeigte_funktion)[1], true)

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
	OS.set_window_size(Vector2(448,640))
	get_tree().change_scene("res://Szenen/Spieloberflaeche.tscn")
	

# Verarbeite das Speichern des Inhalts von TextEdit2.
func save_te2():
	save_file(te2.get_text(), "res://Skripte/Bewegung/Muenze/badCoin1.gd")
	print("speichern")
	OS.set_window_size(Vector2(448,640))
	get_tree().change_scene("res://Szenen/Spieloberflaeche.tscn")

# Wenn ein anderer Tab sichtbar wird, wird dieser in cur_tab gespeichert.
func _on_TabContainer_tab_changed(tab):
	cur_tab = tab
	# Setzt den Fokus auf den aktuellen Tab.
	get_node("TabContainer").get_child(cur_tab).grab_focus()

# Weise den Variabeln te1 und te2 ihre Nodes zu.
# Lade den Inhalt der Textedits.
func init_te():
	var tabcontainer = get_node("TabContainer")
	# Setze das Icon fuer die Tabs.
	tabcontainer.set_tab_icon(0, load("res://Bilder/Standardspielfiguren/Player_Icon.png"));
	tabcontainer.set_tab_icon(1, load("res://Bilder/Standardspielfiguren/BadCoin1_Icon.png"));
	te1 = get_node("TabContainer/TextEdit")
	te2 = get_node("TabContainer/TextEdit2")
	
	te1.set_text(lade_datei("res://Skripte/Bewegung/Player.gd"))
	te2.set_text(lade_datei("res://Skripte/Bewegung/Muenze/badCoin1.gd"))
	
	finde_funktionen(te1)
	finde_funktionen(te2)
	# Farbe fuer Kommentare auf Gruen setzen.
	te1.add_color_region("#", ".", Color(0,1.0,0), true)
	te2.add_color_region("#", ".", Color(0,1.0,0), true)
	# Name des Tabs setzten.
	te1.name = "Spieler"
	te2.name = "Schlechte Münze"
	# Erster Tab bekommt Fokus beim initialisieren.
	te1.grab_focus()

func finde_funktionen(textedit):
	for i in (textedit.get_line_count()):
		setze_funktion(textedit, textedit.get_line(i), i)
		setze_variable(textedit, textedit.get_line(i), i)

func setze_funktion(textedit, text, zeile):
	var index = 0
	var funktion_gefunden = (text.find("func ", index) != -1)
	if funktion_gefunden:
		var texts = text.split(" ")
		for i in range (texts.size()):
			if texts[i] == "func":
				# Setze den Funktionsnamen und lösche den Doppelpunkt
				var funktions_name = texts[i + 1].rstrip(":")
				funktionen[cur_tab][funktions_name] = [gib_blockanfang(textedit, zeile + 1),gib_blockende(textedit,zeile + 1)]
				get_node("Funktionsauswahl").add_item(funktions_name)
				
				break
	return funktion_gefunden

func setze_variable(textedit, text, zeile):
	var index = 0
	var variable_gefunden = (text.find("export", 0) != -1 || text.substr(0,3) == "var")
	if variable_gefunden:
		var woerter = text.split(" ")
		for i in range(woerter.size()):
			if woerter[i] == "var":
				var variablen_name = woerter[i + 1]
				variablen[cur_tab][variablen_name] = [gib_blockanfang(textedit, zeile + 1),zeile]
				break

# Gibt die Zeile des Blocks.
func gib_blockende(textedit, zeile):
	var endzeile = zeile
	while (textedit.get_line(endzeile).substr(0,1) == "\t"):
		endzeile += 1
	return endzeile - 1

# Gibt die Zeile des Blockanfangs. Die Zeilen sind immer +1 zu sehen.
func gib_blockanfang(textedit, zeile):
	var anfangszeile = zeile - 1
	while ((anfangszeile == zeile - 1) || textedit.get_line(anfangszeile).substr(0,1) == "#"):
		anfangszeile -= 1
	return anfangszeile + 1

# Zeigt Zeilen von start_zeile bis end_zeile an.
func zeige_zeilen(start_zeile, end_zeile):
	# end_zeile + 1 weil range exklusiv ist.
	for i in range(start_zeile, end_zeile + 1):
		get_node("TabContainer").get_child(cur_tab).set_line_as_hidden(i, false)

func zeige_variablen_von_funktion(funktionsname):
	var gelesene_variablen = funktionen_mit_variablen[cur_tab][funktionsname]
	for variable in gelesene_variablen:
		zeige_zeilen(variablen[cur_tab][variable][0], variablen[cur_tab][variable][1])

func setze_aktuell_angezeigte_funktion():
	aktuell_angezeigte_funktion = get_node("Funktionsauswahl").get_item_text(get_node("Funktionsauswahl").selected)

# Wenn in der Funktionsauswahl etwas gewaehlt wurde.
# ID ist dabei die stelle an der die Auswahl steht.
func _on_Funktionsauswahl_getroffen(ID):
	setze_aktuell_angezeigte_funktion()
	if aktuell_angezeigte_funktion == "alle":
		zeige_alles()
	else:
		verstecke_alles()
		zeige_zeilen(funktionen[cur_tab].get(aktuell_angezeigte_funktion)[0],funktionen[cur_tab].get(aktuell_angezeigte_funktion)[1])
		zeige_variablen_von_funktion(aktuell_angezeigte_funktion)

func verstecke_alles():
	for i in range(te1.get_line_count()):
		te1.set_line_as_hidden(i, true)

func zeige_alles():
	te1.unhide_all_lines()

func weise_variablen_funktionen_zu():
	var gelesene_funktionen = funktionen[cur_tab].keys()
	var gelesene_variablen = variablen[cur_tab].keys()
	for i in range(gelesene_funktionen.size()):
		suche_variable_in_funktion(gelesene_funktionen[i], funktionen[cur_tab].get(gelesene_funktionen[i])[0],funktionen[cur_tab].get(gelesene_funktionen[i])[1], gelesene_variablen)

func suche_variable_in_funktion(funktions_name, funktions_anfang, funktions_ende, variablen):
	var zeile
	funktionen_mit_variablen[cur_tab][funktions_name] = []
	
	for i in range(funktions_anfang,funktions_ende + 1):
		zeile = te1.get_line(i)
		for j in range(variablen.size()):
			if zeile.find(variablen[j], 0) != -1 && !funktionen_mit_variablen[cur_tab][funktions_name].has(variablen[j]):
				funktionen_mit_variablen[cur_tab][funktions_name].append(variablen[j])