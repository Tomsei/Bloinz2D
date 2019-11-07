extends Node2D

var te1
var te2
var cur_tab = 0

func _ready():
	init_te()

func _process(delta):
	#print("test1")
	pass

func lade_datei(pfad):
	var datei = File.new()
	var err = datei.open(pfad, File.READ)
	if err != OK:
		printerr("Datei konnte nicht geladen werden, error code ", err)
		return ""
	var text = datei.get_as_text()
	datei.close()
	return text
	
func save_file(text, pfad):
	var datei = File.new()
	var err = datei.open(pfad, File.WRITE)
	if err != OK:
		printerr("Fehler beim Schreiben in Datei, error Code:", err)
		return
	datei.store_string(text)
	datei.close()


func _on_Button_button_up():
	match cur_tab:
		0:
			print("tab 1")
			save_te1()
		1:
			print("tab 2")
			save_te2()

func save_te1():
	save_file(te1.get_text(), "res://Skripte/textedit.gd")
	print("speichern")
	get_tree().change_scene("res://Szenen/bufferscreen.tscn")

func save_te2():
	var label = get_node("Label")
	label.set_text(te2.get_text())
	("changed label")

func _on_TabContainer_tab_changed(tab):
	cur_tab = tab

func init_te():
	te1 = get_node("TabContainer/TextEdit")
	te2 = get_node("TabContainer/TextEdit2")
	
	te1.set_text(lade_datei("res://Skripte/textedit.gd"))
	var label = get_node("Label")
	te2.set_text(label.get_text())