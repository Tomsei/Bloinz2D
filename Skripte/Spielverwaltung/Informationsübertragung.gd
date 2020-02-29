extends Node

var sprungkraft 
var sprungkraftGeaendert = false
var raketenzeit 
var raketenzeitGeaendert = false 
var geschwindigkeit 
var geschwindigkeitGeaendert = false
var soundAn = true
var randomCoinAn = true
var spielfigurgroesse
var erstesSpiel = true
var vomEditor = false
var CoinRegenAn = true
var CoinMagnetAn = true
var RegenschirmAn = true
var SpeedboostAn = true
var figurengroesse;


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true
	JavaScript.eval("resizeSpiel(640,448)")
	# Zentriert das Fenster in der Bildschirmmitte
	preload("res://Szenen/Spielverwaltung/UI.tscn").instance().bildschirm_zentrieren()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

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



















