extends CheckButton

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var soundplayer = get_tree().get_root().get_node("Main").get_node("Spiel").get_node("Player").get_node("AudioStreamPlayer2D")
onready var soundButton = get_tree().get_root().get_node("Main").get_node("Sound")

# Called when the node enters the scene tree for the first time.
func _ready():
	soundButton.pressed = einstellungen.soundAn


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


func _on_Sound_toggled(button_pressed):
	if einstellungen.soundAn:
		einstellungen.soundAn = false
		soundplayer.set_volume_db(-500)
		print("aus")
	else:
		einstellungen.soundAn = true
		soundplayer.set_volume_db(0)
		print("an")