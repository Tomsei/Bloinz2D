extends Node2D

# Das Skripte dient zum Importieren und Exportieren der vom Benutzer erstellten Bilder.

# Refferenz auf die Szene Persistenz wird geladen.
var persistenz = preload("res://Szenen/Spielverwaltung/Persistenz.tscn").instance()

func _ready():
	preload("res://Szenen/Spielverwaltung/UI.tscn").instance().bildschirm_zentrieren()

# Wenn der Knopf zum Importieren gedrueckt wird.
# Zum importieren sollte im Textfeld Nutzerdaten ein base64-String stehen, der konvertiert werden kann.
func _on_Importieren():
	# Ruft die importiere_eigene_dateien-methode mit dem Inhalt des Textfeldes Nutzerdaten auf.
	persistenz.importiere_eigene_dateien($Nutzerdaten.text)

# Wenn der Knopf zum Exportieren gedrueckt wird.
# Die vom Benutzer erstellten Bilder werden in einen base64-String konvertiert
# und in dem Textfeld Nutzerdaten angezeigt. Ebenfalls wird der String in die
# Zwischenablage kopiert.
func _on_Exportieren():
	# Ruft die exportiere_eigene_dateien-mehtode der Szene Persistenz auf, welch die aktuell
	# fuer das Spiel verwendeten Bilder in einen base64-String konvertiert.
	# Dieser String wird in die Variable text gespeichert.
	var text = persistenz.exportiere_eigene_dateien()
	# Das Textfeld Nutzerdaten wird mit dem String gefuellt.
	$Nutzerdaten.text = str(text)
	# Der String wird in die Zwischenablage kopiert.
	$Nutzerdaten.copy()

# Wenn der Zurueckknopf gedrueckt wird.
func _on_Zurueck():
	# Passt die Fensterbreite und Höhe an.
	OS.set_window_size(Vector2(448,640))
	# Ruft die Startszene des Spieles auf.
	get_tree().change_scene("res://Szenen/Oberflaeche/Main.tscn")
