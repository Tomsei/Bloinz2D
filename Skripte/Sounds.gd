extends AudioStreamPlayer2D

var sounds = {}

func _ready():
	sounds["Schrumpfen"] = load("res://Sounds/Schrumpfen.wav")
	sounds["Wachsen"] = load("res://Sounds/Wachsen.wav")