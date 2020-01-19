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


func _on_CoinRegen_toggled(button_pressed):
	if einstellungen.CoinRegenAn == true: 
		einstellungen.CoinRegenAn = false
	else:
		einstellungen.CoinRegenAn = true


func _on_Regenschirm_toggled(button_pressed):
	if einstellungen.RegenschirmAn == true: 
		einstellungen.RegenschirmAn = false
	else:
		einstellungen.RegenschirmAn = true


func _on_CoinMagnet_toggled(button_pressed):
	if einstellungen.CoinMagnetAn == true: 
		einstellungen.CoinMagnetAn = false
	else:
		einstellungen.CoinMagnetAn = true
