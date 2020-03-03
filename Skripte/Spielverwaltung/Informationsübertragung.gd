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
var figurengroesse





# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true
	JavaScript.eval("resizeSpiel(640,448)")
	# Zentriert das Fenster in der Bildschirmmitte
	preload("res://Szenen/Spielverwaltung/UI.tscn").instance().bildschirm_zentrieren()
	
	if figurengroesse == null:
		figurengroesse = {}
		figurengroesse["BadCoin1"] = [Vector2(10,10), Vector2(53,53)]
		figurengroesse["BadCoin2"] = [Vector2(10,10), Vector2(53,53)]
		figurengroesse["Blob_1_gerade"] = [Vector2(17,32), Vector2(46,63)]
		figurengroesse["Blob_2_gerade"] = [Vector2(14,24), Vector2(49, 63)]
		figurengroesse["Blob_3_gerade"] = [Vector2(10,16), Vector2(53,63)]
		figurengroesse["Blob_4_gerade"] = [Vector2(6,8), Vector2(57,63)]
		figurengroesse["Blob_5_gerade"] = [Vector2(2,0), Vector2(61, 63)]
		figurengroesse["GoodCoin1"] = [Vector2(12,12), Vector2(51,51)]
		figurengroesse["GoodCoin2"] = [Vector2(12,12), Vector2(51,51)]
		figurengroesse["Kanonenkugel"] = [Vector2(1,8), Vector2(62,55)]
		figurengroesse["RandomCoin"] = [Vector2(12,12), Vector2(51,51)]



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



















