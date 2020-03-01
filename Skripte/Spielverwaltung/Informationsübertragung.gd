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
	
	if figurengroesse == null:
		figurengroesse = {}
		
		figurengroesse["BadCoin1"] = Vector2(44,44)
		figurengroesse["BadCoin2"] = Vector2(44,44)
		figurengroesse["Blob_1_gerade"] = Vector2(30,32)
		figurengroesse["Blob_2_gerade"] = Vector2(36,40)
		figurengroesse["Blob_3_gerade"] = Vector2(44,48)
		figurengroesse["Blob_4_gerade"] = Vector2(52,56)
		figurengroesse["Blob_5_gerade"] = Vector2(60,64)
		figurengroesse["GoodCoin1"] = Vector2(40,40)
		figurengroesse["GoodCoin2"] = Vector2(40,40)
		figurengroesse["Kanonenkugel"] = Vector2(62,48)
		figurengroesse["RandomCoin"] = Vector2(40,40) 



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



















