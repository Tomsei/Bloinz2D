extends VBoxContainer

# Variablen
var codeeditor
var maleditor

# Funktion wird beim laden der Szene aufgerufen.
func _ready():
	# Weise den Variablen die passenden Buttons zu.
	codeeditor = get_node("CodeEditor")
	maleditor = get_node("MalEditor")


func _on_MenuIcon_button_up():
	# Falls die Buttons sichtbar sind, werden sie unsichtbar geschalten. So auch anders herum.
	maleditor.visible = !maleditor.visible
	codeeditor.visible = !codeeditor.visible