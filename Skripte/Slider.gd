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
	#spieler.sprungkraft = value
	#print (value)
	print(get_tree().get_root().get_child(0).get_child(0).get_node("Player"))

