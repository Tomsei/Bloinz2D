extends Node2D

var persistenz = preload("res://Szenen/Spielverwaltung/Persistenz.tscn").instance()

func _ready():
	pass


func _on_Importieren():
	persistenz.importiere_eigene_dateien($Nutzerdaten.text)


func _on_Exportieren():
	var text = persistenz.exportiere_eigene_dateien()
	$Nutzerdaten.text = str(text)
	$Nutzerdaten.copy()
	print("export")


func _on_Zurueck():
	OS.set_window_size(Vector2(448,640))
	get_tree().change_scene("res://Szenen/Oberflaeche/Main.tscn")
