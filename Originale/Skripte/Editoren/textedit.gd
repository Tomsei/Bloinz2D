extends Node2D

# Variablen
# Texteditoren in welchen der Code angezeigt wird.
var Codeeditoren = {}
# Pfade zu den Skripten
var Skriptpfade = {}
# Icons fuer die Tabs.
var Icons = {}
var cur_tab = 0
var vorheriger_tab = -1
var funktionen = [{}]
var variablen = [{}]
var funktionen_mit_variablen = [{}]
var aktuell_angezeigte_funktion
var code_veraendert = false

# Funktion welche beim start aufgerufen wird.
func _ready():
	# Initiiere Parameter.
	init()

func init():
	OS.set_window_size(Vector2(800,600))
	init_Skripte()
	init_Icons()
	init_Codeeditoren()
	# Fuellt die Funktionsauswahl mit den Werten des ersten Skripts.
	fuelle_funktionsauswahl()
	print($Speicherdialog.get_children())
	#init_te()
	# Zeige die ausgewaehlte Funktion an.
	#setze_aktuell_angezeigte_funktion()
	#_on_Funktionsauswahl_getroffen(0)
	#weise_variablen_funktionen_zu()

# Die Funktion wird automatisch bei jedem Frameändern aufgerufen.
func _process(delta):
	pass

# Lädt eine Datei und gibt den Text der Datei zurück.
func lade_datei(pfad):
	var datei = File.new()
	var err = datei.open("user://" + pfad.lstrip("res:/"), File.READ)
	if err != OK:
		err = datei.open(pfad, File.READ)
		if err != OK:
			printerr("Datei konnte nicht geladen werden, error code ", err)
			return ""
	var text = datei.get_as_text()
	
	datei.close()
	return text

# Speichert Text in eine Datei mit angegebenem Pfad.
func save_file(text, pfad):
	var datei = File.new()
	var err = datei.open("user://" + pfad.lstrip("res:/"), File.WRITE)
	if err != OK:
		printerr("Fehler beim Schreiben in Datei, error Code:", err)
		return
	datei.store_string(text)
	datei.close()


# Wird aufgerufen, wenn der Knopf losgelassen wird.
func _on_Button_button_up():
	speicher_skript(cur_tab)

# Ruft die Speicherfunktion fuer einen uebergebenen Tab auf.
func speicher_skript(tabindex):
	var texteditor = $TabContainer.get_child(tabindex)
	save_file(texteditor.get_text(), Skriptpfade.get(texteditor.name))

# Wenn ein anderer Tab sichtbar wird, wird dieser in cur_tab gespeichert.
func _on_TabContainer_tab_changed(tab):
	if code_veraendert:
		vorheriger_tab = cur_tab
		$Speicherdialog.popup()
	cur_tab = tab
	# Damit beim ersten Aufruf der Szene nicht unnoetig die Funktinoen geadded werden.
	if !funktionen[cur_tab].empty():
		leere_funktionsauswahl()
		fuelle_funktionsauswahl()
	# Setzt den Fokus auf den aktuellen Tab.
	get_node("TabContainer").get_child(cur_tab).grab_focus()

# Schreibe die verwendeten Skriptpfade in das Array Skriptpfade.
func init_Skripte():
	Skriptpfade["Spieler"] = "res://Skripte/Aktionen/Spieler.gd"
	Skriptpfade["Münze"] = "res://Skripte/Aktionen/Muenze/Muenze.gd"
	Skriptpfade["Gute Münze 1"] = "res://Skripte/Aktionen/Muenze/goodCoin1.gd"
	Skriptpfade["Gute Münze 2"] = "res://Skripte/Aktionen/Muenze/goodCoin2.gd"
	Skriptpfade["Böse Münze 1"] = "res://Skripte/Aktionen/Muenze/badCoin1.gd"
	Skriptpfade["Böse Münze 2"] = "res://Skripte/Aktionen/Muenze/badCoin2.gd"
	Skriptpfade["Zufalls Münze"] = "res://Skripte/Aktionen/Muenze/randomCoin.gd"
	Skriptpfade["Kanone"] = "res://Skripte/Aktionen/Kanone.gd"
	Skriptpfade["Spiellogik"] = "res://Skripte/Spielverwaltung/Logik.gd"

func init_Icons():
	Icons["Spieler"] = load("res://Bilder/Tabicons/Player_Icon.png")
	Icons["Böse Münze 1"] = load("res://Bilder/Tabicons/BadCoin1_Icon.png")
	Icons["Standard"] = load("res://Bilder/Tabicons/Standard.png")

func init_Codeeditoren():
	var tabcontainer = get_node("TabContainer")
	var Codeeditornamen = Skriptpfade.keys()
	for i in range(Skriptpfade.size()):
		# Erzeuge eine neue TextEdit Node um den Code anzuzeigen.
		tabcontainer.add_child(TextEdit.new())
		# Setze den Namen fuer dieses TextEdit.
		tabcontainer.get_child(i).name = Codeeditornamen[i]
		# Wenn ein Icon existiert setze dieses als Tab Icon. Sonst nutze das Standardicon.
		if Icons.has(Codeeditornamen[i]):
			tabcontainer.set_tab_icon(i, Icons.get(Codeeditornamen[i]))
		else:
			tabcontainer.set_tab_icon(i, Icons.get("Standard"))
		# Lade die Skripte in die TextEditoren.
		tabcontainer.get_child(i).text = lade_datei(Skriptpfade.get(Codeeditornamen[i]))
		# Soll Kommentarfarbe hinzufuegen.
		tabcontainer.get_child(i).add_color_region("#", ".", Color(0,1.0,0), true)
		# Zeilen duerfen versteckt werden.
		tabcontainer.get_child(i).hiding_enabled = true
		# Farbliche Hervorhebung aktivieren.
		tabcontainer.get_child(i).syntax_highlighting = true
		# Zeigt Zeilennummern an.
		tabcontainer.get_child(i).show_line_numbers = true
		tabcontainer.get_child(i).connect("text_changed", self, "_text_wurde_veraendert")
		# Suche nach Funktionen in dem Codeeditor.
		finde_funktionen(tabcontainer.get_child(i) , i)
	# Der erste Codeeditor bekommt den Fokus.
	tabcontainer.get_child(0).grab_focus()

func leere_funktionsauswahl():
	get_node("Funktionsauswahl").clear()

func fuelle_funktionsauswahl():
	get_node("Funktionsauswahl").add_item("alle")
	for i in range(funktionen[cur_tab].size()):
		get_node("Funktionsauswahl").add_item(funktionen[cur_tab].keys()[i])

# Findet Funktionen und Variablen in einem Codeeditor und speichert diese in Variablen.
# Ebenfalls werden die in den Funktionen genutzten Variablen diesen zugewiesen.
func finde_funktionen(textedit, skriptindex):
	for i in (textedit.get_line_count()):
		setze_funktion(textedit, textedit.get_line(i), i, skriptindex)
		setze_variable(textedit, textedit.get_line(i), i, skriptindex)
	weise_variablen_funktionen_zu(skriptindex)

# Falls eine Funktion in der uebergebenen Zeile gefunden wird, wird sie in eine Variable geschrieben.
func setze_funktion(textedit, text, zeile, skriptindex):
	var index = 0
	var funktion_gefunden = (text.find("func ", index) != -1)
	if funktion_gefunden:
		var texts = text.split(" ")
		for i in range (texts.size()):
			if texts[i] == "func":
				# Setze den Funktionsnamen und lösche den Doppelpunkt
				var funktions_name = texts[i + 1].rstrip(":")
				# Bei mehr als einem Skript muss ein neues Dictionary hinzugefuegt werden.
				if skriptindex > 0:
					funktionen.append({})
				funktionen[skriptindex][funktions_name] = [gib_blockanfang(textedit, zeile + 1),gib_blockende(textedit,zeile + 1)]
				
				break
	return funktion_gefunden

# Falls in der uebergebenen Zeile eine Variable gefunden wurde, wird diese in eine Variable geschrieben.
func setze_variable(textedit, text, zeile, skriptindex):
	var index = 0
	var variable_gefunden = (text.find("export", 0) != -1 || text.substr(0,3) == "var")
	if variable_gefunden:
		var woerter = text.split(" ")
		for i in range(woerter.size()):
			if woerter[i] == "var":
				var variablen_name = woerter[i + 1]
				# Bei mehr als einem Skript muss ein neues Dictionary hinzugefuegt werden.
				if skriptindex > 0:
					variablen.append( {} )
				variablen[skriptindex][variablen_name] = [gib_blockanfang(textedit, zeile + 1),zeile]
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

# Zeigt die Variblen die zu einer Funktion gehoeren.
func zeige_variablen_von_funktion(funktionsname):
	var gelesene_variablen = funktionen_mit_variablen[cur_tab][funktionsname]
	for variable in gelesene_variablen:
		zeige_zeilen(variablen[cur_tab][variable][0], variablen[cur_tab][variable][1])

# Setzt die Variable fuer die aktuell angezeigte Funktion.
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

# Verstecke alle Zeilen.
func verstecke_alles():
	for i in range($TabContainer.get_child(cur_tab).get_line_count()):
		$TabContainer.get_child(cur_tab).set_line_as_hidden(i, true)

# Zeige alle Zeilen.
func zeige_alles():
	$TabContainer.get_child(cur_tab).unhide_all_lines()

# Weist die Variablen welche in einer Funktion genutzt werden dieser zu.
func weise_variablen_funktionen_zu(skriptindex):
	# Hole zu letzt gefundene Funktionen
	var gelesene_funktionen = funktionen[skriptindex].keys()
	var gelesene_variablen = variablen[skriptindex].keys()
	for i in range(gelesene_funktionen.size()):
		suche_variable_in_funktion(gelesene_funktionen[i], funktionen[skriptindex].get(gelesene_funktionen[i])[0],funktionen[skriptindex].get(gelesene_funktionen[i])[1], gelesene_variablen, skriptindex)

# Sucht und speichert Variablen in Funktionen.
func suche_variable_in_funktion(funktions_name, funktions_anfang, funktions_ende, variablen, skriptindex):
	var zeile
	# Ab dem Skriptindex 1 muss ein neuer Arraywert angehaengt werden.
	if skriptindex > 0:
		funktionen_mit_variablen.append({})
	funktionen_mit_variablen[skriptindex][funktions_name] = []
	for i in range(funktions_anfang,funktions_ende + 1):
		zeile = $TabContainer.get_child(skriptindex).get_line(i)
		for j in range(variablen.size()):
			if zeile.find(variablen[j], 0) != -1 && !funktionen_mit_variablen[skriptindex][funktions_name].has(variablen[j]):
				funktionen_mit_variablen[skriptindex][funktions_name].append(variablen[j])

# Wird ausgefuehrt, wenn der Zurueckbutton gedrueckt wird.
func _on_Zurueck_button_up():
	OS.set_window_size(Vector2(448,640))
	get_tree().change_scene("res://Szenen/Oberflaeche/Spieloberflaeche.tscn")

# Wird aufgerufen wenn der Text eine Codeeditors veraendert wird.
func _text_wurde_veraendert():
	code_veraendert = true

# Wenn im Popupdialog Ja gedrueckt wird.
func _on_Speicherdialog_speichern():
	speicher_skript(vorheriger_tab)
	$Speicherdialog.hide()
	code_veraendert = false

# Wenn im Popupdialog Nein gedrueckt wird.
func _on_nicht_speichern():
	$Speicherdialog.hide()
	code_veraendert = false
