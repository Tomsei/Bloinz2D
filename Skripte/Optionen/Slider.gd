extends HSlider

onready var spieler = get_tree().get_root().get_node("Main").get_node("Spiel").get_node("Player")
onready var rakete = get_tree().get_root().get_node("Main").get_node("Spiel").get_node("Logik").get_node("RaketenTimer")

onready var optionen = get_tree().get_root().get_node("Main").get_node("AlleOptionen")
onready var sliderOptionen = optionen.get_node("Seite1-Slider")

onready var sprungkraftSlider = sliderOptionen.get_node("Sprungkraft").get_node("SprungkraftSlider")
onready var blobSlider = sliderOptionen.get_node("tempoBlob").get_node("BlobSlider")
onready var raketenSlider = sliderOptionen.get_node("raketenAbstand").get_node("RaketenSlider")

var persistenz = preload("res://Szenen/Spielverwaltung/Persistenz.tscn").instance()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SchwierigkeitSlider_value_changed(value):
	$SchwierigkeitAktuell.text = str(value)
	var schwierigkeit = int(value)
	match schwierigkeit:
		1:
			blobSlider.value = 350
			sprungkraftSlider.value = 600
			raketenSlider.value = 20
		2:
			blobSlider.value = 420
			sprungkraftSlider.value = 800
			raketenSlider.value = 15
		3:
			blobSlider.value = 500
			sprungkraftSlider.value = 500
			raketenSlider.value = 10
		4:
			blobSlider.value = 800
			sprungkraftSlider.value = 420
			raketenSlider.value = 5
		5:
			blobSlider.value = 200
			sprungkraftSlider.value = 350
			raketenSlider.value = 3


func _on_SprungkraftSlider_value_changed(value):
	$SprungkraftAktuell.text = str(value)
	einstellungen.sprungkraftGeaendert = true
	
	persistenz.schreibe_variable_in_datei("Sprungkraft", value, "res://Skripte/Aktionen/Spieler.gd")


func _on_BlobSlider_value_changed(value):
	$BlobAktuell.text = str(value)
	einstellungen.geschwindigkeitGeaendert = true
	
	persistenz.schreibe_variable_in_datei("speed", value, "res://Skripte/Aktionen/Spieler.gd")

func _on_RaketenSlider_value_changed(value):
	$RaketeAktuell.text = str(value)
	einstellungen.raketenzeitGeaendert = true
	
	persistenz.schreibe_variable_in_datei("raketenZeit", value, "res://Skripte/Spielverwaltung/Logik.gd")



#func _on_AlleOptionen_hide():
	einstellungen.setzeSpielerEinstellungen(sprungkraftSlider.value, blobSlider.value)


func _on_Optionen_Slider_draw():
	blobSlider.value = einstellungen.uebernehmeGeschwindigkeit()
	sprungkraftSlider.value = einstellungen.uebernehmeSprungkraft()
	raketenSlider.value = einstellungen.uebernehmeRaketenzeit()

func _on_Optionen_Slider_hide():
	einstellungen.setzeSpielerEinstellungen(sprungkraftSlider.value, blobSlider.value)
	einstellungen.setzeRaketenzeit(raketenSlider.value)
