extends CheckButton

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_RandomCoin_toggled(button_pressed):
	if einstellungen.randomCoinAn:
		einstellungen.randomCoinAn = false
		get_node("Coin-Regen").disabled = true
		get_node("Speedboost").disabled = true
		get_node("CoinMagnet").disabled = true
		get_node("Regenschirm").disabled = true
		print("aus")
	else:
		einstellungen.randomCoinAn = true
		get_node("Coin-Regen").disabled = false
		get_node("Speedboost").disabled = false
		get_node("CoinMagnet").disabled = false
		get_node("Regenschirm").disabled = false
		print("an")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Sound_toggled(button_pressed):
	if einstellungen.soundAn:
		einstellungen.soundAn = false
		print("aus")
	else:
		einstellungen.soundAn = true
		print("an")