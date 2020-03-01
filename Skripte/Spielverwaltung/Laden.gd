extends Node2D

# Funktion wird beim Aufruf der Sezene ausgefuehrt.
func _ready():
	var dateien_vorher_vorhanden
	# Schreibt die Daten in den Nutzerordner wenn noch nicht vorhanden.
	dateien_vorher_vorhanden = preload("res://Szenen/Spielverwaltung/Persistenz.tscn").instance().init()
	
	# Wenn beim initiieren festgestellt wurde, dass Daten vorhanden sind, wird der Nutzer gefragt,
	# ob diese behalten oder geloescht werden sollen.
	if dateien_vorher_vorhanden == true:
		# Loeschdialog anzeigen.
		$Loeschfrage.show()
	# Sind keine Daten vorhanden wird die Startseite des Spieles angezeigt.
	else:
		# Wechsle die Szene zur Startseite des Spiles.
		get_tree().change_scene("res://Szenen/Oberflaeche/Main.tscn")


# Wenn alle Dateien gelöscht und neu geschrieben werden sollen.
func _on_Loeschen_button_up():
	# Ruft aus der Szene Persistenz die zuruecksetzen-funktion auf, welche alle Daten neu schreibt.
	preload("res://Szenen/Spielverwaltung/Persistenz.tscn").instance().zuruecksetzen()
	# Die Startseite des Spieles wird aufgerufen.
	get_tree().change_scene("res://Szenen/Oberflaeche/Main.tscn")

# Wenn die Daten behalten bleiben sollen.
func _on_Behalten_button_up():
	# Die Startseite des Spieles wird aufgerufen.
	get_tree().change_scene("res://Szenen/Oberflaeche/Main.tscn")

# Wenn nur die Skripte gelöscht werden sollen.
func _on_Skripteloeschen():
	# Ruft aus der Szene Persistenz die skripte zuruecksetzen-funktion auf, welche alle Skripte
	# loescht und neuschreibt. Dabei bleiben die Bilder erhalten.
	preload("res://Szenen/Spielverwaltung/Persistenz.tscn").instance().skripte_zuruecksetzen()
	get_tree().change_scene("res://Szenen/Oberflaeche/Main.tscn")
