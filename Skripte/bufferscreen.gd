extends Node2D

# Schmeißt einen zurück zur Hauptszene.
func _on_Button_button_up():
	get_tree().change_scene("res://Szenen/textedit.tscn")