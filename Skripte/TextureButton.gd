extends TextureButton

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Start_button_up():
	print("Spiel starten")
	get_tree().change_scene("res://Szenen/Player.tscn")
	
func _on_Nochmal_button_up():
	print("Erneut spielen")
	get_tree().change_scene("res://Szenen/Player.tscn")
	
func _on_Optionen_button_up():
	print("Einstellungen")
	get_tree().change_scene("res://Szenen/Optionen.tscn")

func _on_CodeEditor_button_up():
	print("gehe zum Editor")
	get_tree().change_scene("res://Szenen/textedit.tscn")

func _on_MalenEditor_button_up():
	print("Wechsle zum malen")
	get_tree().change_scene("res://Szenen/Malen.tscn")


func _on_SpielStarten_button_up():
	print("Spiel starten")
	get_tree().change_scene("res://Szenen/Player.tscn")
