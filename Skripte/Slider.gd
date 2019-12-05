extends HSlider

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#onready var spieler = get_tree().get_root().get_child(0).get_node("Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SprungkraftSlider_value_changed(value):
	$SprungkraftAktuell.text = str(value)


func _on_BlobSlider_value_changed(value):
	$BlobAktuell.text = str(value)

func _on_CoinSlider_value_changed(value):
	$CoinAktuell.text = str(value)
