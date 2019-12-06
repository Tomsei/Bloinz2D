extends AudioStreamPlayer2D

# Variable fuer Sounds.
var sounds = {}

# Wird ausgefuehrt wenn das Skript geladen wird.
func _ready():
	# Lade die Sounddateien in die Variable.
	sounds["Schrumpfen"] = load("res://Sounds/Schrumpfen.wav")
	sounds["Wachsen"] = load("res://Sounds/Wachsen.wav")

func abspielen(sound):
	# Spielt nur ab wenn der Sound vorhanden ist.
	if sounds.has(sound):
		# Setze die zu spielende Sounddatei.
		set_stream(sounds[sound])
		# Spiele die vohrer gesetzte Sounddatei ab.
		play()