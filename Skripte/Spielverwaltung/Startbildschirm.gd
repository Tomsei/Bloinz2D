extends Node2D

var hauptpfad_originale = "res://"
var hauptpfad_user = "user://"
var nicht_kopieren = [".git", ".gitignore", "project.godot"]
var dateien_ueberschreiben = false

# Wird beim Start aufgerufen.
func _ready():
	stuktur_erstellen(hauptpfad_originale)


# Wird mit Oberordner aufgerufen. Alle Dateien die hier sind, sollen erstellt werden.
# Ordner die gefunden wurden, werden erstellt und rufen diese Funktion direkt erneut auf.
func stuktur_erstellen(pfad):
	var ober_ordner = Directory.new()
	ober_ordner.open(pfad)
	var err = ober_ordner.list_dir_begin(true, true)
	if err != OK:
		print("Ordner nicht gefunden")
		return ""
	var element = ober_ordner.get_next()
	while element != "":
		if ist_ordner(element):
			if pfad == "res://":
				erstelle_ordner(hauptpfad_user + pfad.lstrip("res:/") + element)
			else :
				erstelle_ordner(hauptpfad_user + pfad.lstrip("res:/") + "/" + element)
			if nicht_kopieren.has(element) == false:
				stuktur_erstellen(pfad + "/" + element)
		else:
			if nicht_kopieren.has(element) == false:
				erstelle_dateien(pfad + "/" + element)
		element = ober_ordner.get_next()
	ober_ordner.list_dir_end()

# Prueft ob der Dateiname ein Ordner ist. Wenn ein punkt gefunden wird ist es eine Datei.
func ist_ordner(dateiname):
	return dateiname.find(".") == -1

# Erstelle den Ordner.
func erstelle_ordner(ordnerpfad):
	print(ordnerpfad)
	var ordner = Directory.new()
	ordner.make_dir(ordnerpfad)

# Erstelle die Datei.
func erstelle_dateien(dateienpfad):
	var datei = File.new()
	var err = datei.open(dateienpfad, File.READ)
	if err != OK:
		printerr("Datei konnte nicht geladen werden, error code ", err)
		return ""
	# Datei ist Bild
	if dateienpfad.find(".png") != -1:
		var bild = Image.new()
		bild.load(dateienpfad)
		bild.save_png("user://" + dateienpfad.lstrip("res:/"))
	# Datei ist Sound
	elif dateienpfad.find(".wav") != -1 && dateienpfad.find(".import") == -1:
		var audio = AudioStreamSample.new()
		audio = load("res://" + dateienpfad.lstrip("res://"))
		
		audio.save_to_wav("user://" + dateienpfad.lstrip("res://"))
	# Datei ist text
	else:
		var text = datei.get_as_text()
		datei.close()
		var datei_existiert = datei.file_exists(hauptpfad_user + dateienpfad.lstrip("res:/"))
		if datei_existiert == false || datei_existiert == dateien_ueberschreiben:
			err = datei.open(hauptpfad_user + dateienpfad.lstrip("res:/"), File.WRITE)
			if err != OK:
				print("Datei konnte nicht erstellt werden.")
				return ""
			datei.store_string(text)
			datei.close()
	#else :
	#	print("Datei existiert bereits")