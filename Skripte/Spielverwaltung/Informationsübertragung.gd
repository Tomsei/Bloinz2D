extends Node

var sprungkraft 
var raketenzeit 
var geschwindigkeit 
var soundAn = true
var randomCoinAn = true
var spielfigurgroesse
var erstesSpiel = true
var vomEditor = false
var CoinRegenAn = true
var CoinMagnetAn = true
var RegenschirmAn = true
var SpeedboostAn = true


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = false
	JavaScript.eval("resizeSpiel(640,448)")
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



















