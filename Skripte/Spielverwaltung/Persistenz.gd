extends Node2D

var hauptverzeichnis_benutzer = OS.get_user_data_dir() + "/"
var nicht_kopieren = [".git", ".gitignore", "project.godot", ".cfg"]
func _ready():
	erstelle_datei_und_ordnerstruktur("res://")

# Laedt eine Bildtextur aus uebergebenem Pfad.
func lade_bildtextur(bildpfad):
	var file = File.new()
	file.open(hauptverzeichnis_benutzer + bildpfad.lstrip("res:/"), File.READ)
	var imgtext = file.get_var(true)
	file.close()
	return imgtext

# Erstellt die Ordner und Dateistruktur des uebergebenem Pfads.
func erstelle_datei_und_ordnerstruktur(pfad):
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
				erstelle_ordner(hauptverzeichnis_benutzer + pfad.lstrip("res:/") + element)
			else :
				erstelle_ordner(hauptverzeichnis_benutzer + pfad.lstrip("res:/") + "/" + element)
			if hat_verbotene_namen(element) == false:
				erstelle_datei_und_ordnerstruktur(pfad + "/" + element)
		else:
			if hat_verbotene_namen(element) == false:
				erstelle_dateien(pfad + "/" + element)
		element = ober_ordner.get_next()
	ober_ordner.list_dir_end()


# Prueft ob der Dateiname ein Ordner ist. Wenn ein punkt gefunden wird ist es eine Datei.
func ist_ordner(dateiname):
	return dateiname.find(".") == -1
	

# Speichert ein Bild als Varianttyp. Bild muss spaeter als Variant geladen werden.
# Der Ladepfad muss ohne '.import' sein. Der speicherpfad sollte fuer den webexport
# ohne .import und anstatt dem res:// das userverzeichnis haben.
func speicher_bild_als_variant(bildLadePfad,bildSpeicherpfad):
	var bildtextur = load(bildLadePfad)
	var datei = File.new()
	
	datei.open(bildSpeicherpfad, File.WRITE)
	
	datei.store_var(bildtextur, true)
	datei.close()
	

# Speichert eine wav-Datei als Varianttyp. wav muss spaeter als Variant geladen werden.
# Der Ladepfad muss ohne '.import' sein. Der speicherpfad sollte fuer den webexport
# ohne .import und anstatt dem res:// das userverzeichnis haben.
func speicher_wav_als_variant(wavLadePfad, wavSpeicherpfad):
	var datei = File.new()
	var sound = load(wavLadePfad)
	datei.open(wavSpeicherpfad, File.WRITE)
	
	datei.store_var(sound, true)
	datei.close()

# Speichert ein Skript oder eine Szene im userverzeichnis ab.
# Der Speicherpfad sollte fuer den webexport anstatt dem res:// das userverzeichnis haben.
func speicher_skript_oder_szene_als_var(skriptSzenenLadepfad,skriptSzenenSpeicherpfad):
	var datei = File.new()
	
	datei.open(skriptSzenenLadepfad, File.READ)
	var script_text = datei.get_as_text()
	datei.close()
	
	datei.open(skriptSzenenSpeicherpfad, File.WRITE)
	datei.store_string(script_text)
	datei.close()

# Prueft ob das Element verbotene namen enthaelt.
func hat_verbotene_namen(element):
	var ist_verboten = false
	for wort in nicht_kopieren:
		if element.find(wort) != -1:
			ist_verboten = true
	return ist_verboten

# Erstelle den Ordner.
func erstelle_ordner(ordnerpfad):
	var ordner = Directory.new()
	ordner.make_dir(ordnerpfad)
	pass

# Erstelle die Datei.
func erstelle_dateien(dateienpfad):
	var datei = File.new()
	# Entferne den Pfadanfang um mehrfache Slashes zu vermeiden.
	dateienpfad = "res://" + dateienpfad.lstrip("res:/")
	if datei.file_exists(dateienpfad) == true:
		var dateiname = dateienpfad.split("/")
		dateiname = dateiname[dateiname.size() -1]
		# Datei ist Bild
		if dateienpfad.find(".png") != -1:
			# Fuer den bildLadepfad muss das .import entfernt werden, damit das Bild richtig geladen wird.
			# Fuer den bilSpeicherpfad muss das res entfernt und mit dem userverzeichnis ersetzt werden.
			# Ebenfalls soll das Bild als png und nicht als import gespeichert werden.
			speicher_bild_als_variant(dateienpfad, hauptverzeichnis_benutzer + dateienpfad.lstrip("res:/").rstrip(".import"))
		elif dateienpfad.find(".wav") != -1:
			speicher_wav_als_variant(dateienpfad, hauptverzeichnis_benutzer + dateienpfad.lstrip("res:/").rstrip(".import"))
		else:
			speicher_skript_oder_szene_als_var(dateienpfad, hauptverzeichnis_benutzer + dateienpfad.lstrip("res:/"))