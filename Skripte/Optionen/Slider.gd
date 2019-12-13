extends HSlider

onready var spieler = get_tree().get_root().get_child(0).get_node("Player")
onready var rakete = get_tree().get_root().get_child(0).get_node("Logik").get_node("RaketenTimer")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SprungkraftSlider_value_changed(value):
	$SprungkraftAktuell.text = str(value)
	spieler.Sprungkraft = value


func _on_BlobSlider_value_changed(value):
	$BlobAktuell.text = str(value)
	spieler.speed = value

func _on_SchwierigkeitSlider_value_changed(value):
	#spieler.connect("aendereSprungkraft",self,"test")
	#emit_signal("aendereSprungkraft",value)
	print(spieler.blobGroesse)


func _on_RaketenSlider_value_changed(value):
	$RaketeAktuell.text = str(value)
	rakete.set_wait_time(value)
