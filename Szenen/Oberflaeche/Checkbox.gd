extends CheckBox

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Speedboost_toggled(button_pressed):
	if einstellungen.SpeedboostAn == true: 
		einstellungen.SpeedboostAn = false
	else:
		einstellungen.SpeedboostAn = true
