extends Node

var sprungkraft 
var raketenzeit 
var geschwindigkeit 
var soundAn = true
var randomCoinAn = true
var spielfigurgroesse
var erstesSpiel = true
var vomEditor = false


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true
	JavaScript.eval("resizeSpiel(640,448)")
	# Erstellt die Orderstruktur mit allen Dateien im Benutzerverzeichnis.
	preload("res://Szenen/Spielverwaltung/Persistenz.tscn").instance().init()

func setzeSpielerEinstellungen(var _sprungkraft, var _geschwindigkeit):
	sprungkraft = _sprungkraft
	geschwindigkeit = _geschwindigkeit

func setzeRaketenzeit(var _raketenzeit):
	raketenzeit = _raketenzeit

func setzeFigurGroesse(var _spielfigurgroesse):
	spielfigurgroesse = _spielfigurgroesse

func uebernehmeSprungkraft():
	return sprungkraft

func uebernehmeGeschwindigkeit():
	return geschwindigkeit

func uebernehmeRaketenzeit():
	return raketenzeit

func uebernehmeFigurGroesse():
	return spielfigurgroesse



















