extends Node2D

func _ready():
	preload("res://Szenen/Spielverwaltung/Persistenz.tscn").instance().init()
	get_tree().change_scene("res://Szenen/Oberflaeche/Main.tscn")
