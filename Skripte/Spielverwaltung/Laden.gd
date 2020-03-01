extends Node2D

func _ready():
	var dateien_vorher_vorhanden
	dateien_vorher_vorhanden = preload("res://Szenen/Spielverwaltung/Persistenz.tscn").instance().init()
	
	if dateien_vorher_vorhanden == true:
		$Loeschfrage.show()
	else:
		get_tree().change_scene("res://Szenen/Oberflaeche/Main.tscn")


func _on_Loeschen_button_up():
	preload("res://Szenen/Spielverwaltung/Persistenz.tscn").instance().zuruecksetzen()
	get_tree().change_scene("res://Szenen/Oberflaeche/Main.tscn")


func _on_Behalten_button_up():
	get_tree().change_scene("res://Szenen/Oberflaeche/Main.tscn")


func _on_Skripteloeschen():
	preload("res://Szenen/Spielverwaltung/Persistenz.tscn").instance().skripte_zuruecksetzen()
	get_tree().change_scene("res://Szenen/Oberflaeche/Main.tscn")
