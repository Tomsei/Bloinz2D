extends HSlider

onready var spieler = get_tree().get_root().get_node("Main").get_node("Spiel").get_node("Player")
onready var rakete = get_tree().get_root().get_node("Main").get_node("Spiel").get_node("Logik").get_node("RaketenTimer")

onready var optionen = get_tree().get_root().get_node("Main").get_node("AlleOptionen")
onready var sliderOptionen = optionen.get_node("Seite1-Slider")

onready var sprungkraftSlider = sliderOptionen.get_node("Sprungkraft").get_node("SprungkraftSlider")
onready var blobSlider = sliderOptionen.get_node("tempoBlob").get_node("BlobSlider")
onready var raketenSlider = sliderOptionen.get_node("raketenAbstand").get_node("RaketenSlider")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SprungkraftSlider_value_changed(value):
	$SprungkraftAktuell.text = str(value)
	#spieler.Sprungkraft = value


func _on_BlobSlider_value_changed(value):
	$BlobAktuell.text = str(value)
	#spieler.speed = value

func _on_SchwierigkeitSlider_value_changed(value):
	print(spieler.blobGroesse)


func _on_RaketenSlider_value_changed(value):
	$RaketeAktuell.text = str(value)
	rakete.set_wait_time(value)


func _on_WeitereOptionen_draw():
	pass
#	blobSlider.value = einstellungen.uebernehmeGeschwindigkeit()
#	sprungkraftSlider.value = einstellungen.uebernehmeSprungkraft()


func _on_WeitereOptionen_hide():
	pass
#	einstellungen.setzeSpielerEinstellungen(sprungkraftSlider.value, blobSlider.value)

