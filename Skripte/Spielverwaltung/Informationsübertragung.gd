extends Node

var sprungkraft
var schwierigkeit
var raketenzeit
var geschwindigkeit 
var coinzeit
var soundAn
var randomCoinAn
var spielfigurgroesse


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func setzeSpielerEinstellungen(var _sprungkraft, var _geschwindigkeit):
	sprungkraft = _sprungkraft
	geschwindigkeit = _geschwindigkeit

func setzeSchwierigkeit(var _schwierigkeit):
	schwierigkeit = _schwierigkeit 
	

func setzeRaketenzeit(var _raketenzeit):
	raketenzeit = _raketenzeit

func setzeCoinzeit(var _coinzeit):
	coinzeit = _coinzeit

func setzeFigurGroesse(var _spielfigurgroesse):
	spielfigurgroesse = _spielfigurgroesse

func uebernehmeSprungkraft():
	return sprungkraft

func uebernehmeGeschwindigkeit():
	return geschwindigkeit

func uebernehmeRaketenzeit():
	return raketenzeit

func uebernehmeCoinzeit():
	return coinzeit

func uebernehmeFigurGroesse():
	return spielfigurgroesse



















