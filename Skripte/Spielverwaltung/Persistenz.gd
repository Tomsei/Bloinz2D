extends Node2D

var hauptverzeichnis_benutzer = OS.get_user_data_dir() + "/"
var nicht_kopieren = [".git", ".gitignore", "project.godot", ".cfg"]
var dateien_behalten = false

func _ready():
	if (OS.get_user_data_dir() != "/userfs"):
		hauptverzeichnis_benutzer = OS.get_user_data_dir()

func init():
	var dateien_vorhanden = pruefe_ob_dateien_existieren()
	dateien_behalten = true
	erstelle_datei_und_ordnerstruktur("res://")
	loesche_veraenderungsdatei()
	return dateien_vorhanden

func zuruecksetzen():
	dateien_behalten = false
	erstelle_datei_und_ordnerstruktur("res://")
	loesche_veraenderungsdatei()

func skripte_zuruecksetzen():
	dateien_behalten = false
	erstelle_datei_und_ordnerstruktur("res://Skripte")

# Laedt ein Image aus uebergebenem Pfad. Pfad muss mit res:// anfangen.
func lade_bild(bildpfad):
	var textur = lade_bildtextur(bildpfad)
	var erzeugtesBild = textur.get_data()
	return erzeugtesBild

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
			if ordner_existiert(pfad + "/" + element) == false:
				if pfad == "res://":
					erstelle_ordner(hauptverzeichnis_benutzer + pfad.lstrip("res:/") + element)
				else :
					erstelle_ordner(hauptverzeichnis_benutzer + pfad.lstrip("res:/") + "/" + element)
			if hat_verbotene_namen(element) == false:
				erstelle_datei_und_ordnerstruktur(pfad + "/" + element)
		else:
			if (datei_existiert(pfad + "/" + element) == false) && (hat_verbotene_namen(element) == false):
				erstelle_dateien(pfad + "/" + element)
		element = ober_ordner.get_next()
	ober_ordner.list_dir_end()


# Prueft ob der Dateiname ein Ordner ist. Wenn ein punkt gefunden wird ist es eine Datei.
func ist_ordner(dateiname):
	return dateiname.find(".") == -1
	

# Speichert ein Bild als Textur.
func speicher_bild_als_textur(bild, bildSpeicherpfad):
	var textur = ImageTexture.new()
	textur.create_from_image(bild)
	speicher_textur(textur, bildSpeicherpfad)

func speicher_textur(textur, bildSpeicherpfad):
	var datei = File.new()
	datei.open(hauptverzeichnis_benutzer + bildSpeicherpfad.lstrip("res:/"), File.WRITE)
	datei.store_var(textur, true)
	datei.close()
	
	erstelle_veraenderungsdatei()

# Speichert ein Bild als Varianttyp. Bild muss spaeter als Variant geladen werden.
# Der Ladepfad muss ohne '.import' sein. Der speicherpfad sollte fuer den webexport
# ohne .import und anstatt dem res:// das userverzeichnis haben.
func speicher_bild_als_variant(bildLadePfad,bildSpeicherpfad):
	var bildtextur = load(bildLadePfad)
	var datei = File.new()
	
	datei.open(bildSpeicherpfad, File.WRITE)
	
	datei.store_var(bildtextur, true)
	datei.close()
	
	erstelle_veraenderungsdatei()

# Speichert eine wav-Datei als Varianttyp. wav muss spaeter als Variant geladen werden.
# Der Ladepfad muss ohne '.import' sein. Der speicherpfad sollte fuer den webexport
# ohne .import und anstatt dem res:// das userverzeichnis haben.
func speicher_wav_als_variant(wavLadePfad, wavSpeicherpfad):
	var datei = File.new()
	var sound = load(wavLadePfad)
	datei.open(wavSpeicherpfad, File.WRITE)
	
	datei.store_var(sound, true)
	datei.close()
	
	erstelle_veraenderungsdatei()

# Speichert ein Skript oder eine Szene im userverzeichnis ab.
# Der Speicherpfad sollte fuer den webexport anstatt dem res:// das userverzeichnis haben.
func speicher_skript_oder_szene_als_var(skriptSzenenLadepfad,skriptSzenenSpeicherpfad):
	var datei = File.new()
	
	datei.open(skriptSzenenLadepfad, File.READ)
	var script_text = datei.get_as_text()
	datei.close()
	
	speicher_text(script_text, skriptSzenenSpeicherpfad)

# Speichert textbasierte Dateien.
func speicher_text(text, speicherpfad):
	var datei = File.new()
	
	datei.open(speicherpfad, File.WRITE)
	datei.store_string(text)
	datei.close()
	
	erstelle_veraenderungsdatei()

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
			speicher_bild_als_variant(dateienpfad.rstrip(".import"), hauptverzeichnis_benutzer + dateienpfad.lstrip("res:/").rstrip(".import"))
		elif dateienpfad.find(".wav") != -1:
			speicher_wav_als_variant(dateienpfad.rstrip(".import"), hauptverzeichnis_benutzer + dateienpfad.lstrip("res:/").rstrip(".import"))
		elif dateienpfad.find(".gd") != -1 || dateienpfad.find(".tscn") != -1:
			speicher_skript_oder_szene_als_var(dateienpfad, hauptverzeichnis_benutzer + dateienpfad.lstrip("res:/"))
			

# Prueft ob die Datei schon vorhanden ist.
func datei_existiert(dateipfad):
	var datei = File.new()
	return dateien_behalten && datei.file_exists(hauptverzeichnis_benutzer + dateipfad.lstrip("res:/").rstrip(".import"))

func ordner_existiert(ordnerpfad):
	var ordner = Directory.new()
	return dateien_behalten && ordner.dir_exists(hauptverzeichnis_benutzer + ordnerpfad.lstrip("res:/"))

func pruefe_ob_dateien_existieren():
	var datei = File.new()
	return datei.file_exists(hauptverzeichnis_benutzer + "veraendert")

func exportiere_eigene_dateien():
	var exportstring = ""
	var bilder = []
	bilder = konvertiere_bilder_zu_base64()
	exportstring = str(bilder[0])
	return bilder

func konvertiere_bilder_zu_base64():
	var bilder = []
	var bilderpfad = "res://Bilder/Standardspielfiguren/"
	var coinpfad = bilderpfad + "Coins/"
	var figurenpfad = bilderpfad + "Spielfiguren/"
	var hintergrundpfad = bilderpfad + "Hintergrund/"
	
	bilder.append(lade_bildtextur(figurenpfad + "Blob_1_gerade.png"))
	bilder.append(lade_bildtextur(figurenpfad + "Blob_2_gerade.png"))
	bilder.append(lade_bildtextur(figurenpfad + "Blob_3_gerade.png"))
	bilder.append(lade_bildtextur(figurenpfad + "Blob_4_gerade.png"))
	bilder.append(lade_bildtextur(figurenpfad + "Blob_5_gerade.png"))
	
	bilder.append(lade_bildtextur(figurenpfad + "Kanonenkugel.png"))
	
	bilder.append(lade_bildtextur(coinpfad + "BadCoin1.png"))
	bilder.append(lade_bildtextur(coinpfad + "BadCoin2.png"))
	bilder.append(lade_bildtextur(coinpfad + "GoodCoin1.png"))
	bilder.append(lade_bildtextur(coinpfad + "GoodCoin2.png"))
	bilder.append(lade_bildtextur(coinpfad + "RandomCoin.png"))
	
	bilder.append(lade_bildtextur(hintergrundpfad + "Hintergrund.png"))
	
	return Marshalls.variant_to_base64(bilder ,true)

func importiere_eigene_dateien(importstring):
	print("Import")
	var arr = Marshalls.base64_to_variant(importstring, true)
	speicher_bilderarray(arr)

func speicher_bilderarray(bilderarray):
	var bilderpfad = "res://Bilder/Standardspielfiguren/"
	var coinpfad = bilderpfad + "Coins/"
	var figurenpfad = bilderpfad + "Spielfiguren/"
	var hintergrundpfad = bilderpfad + "Hintergrund/"
	
	speicher_textur(bilderarray[0], figurenpfad + "Blob_1_gerade.png")
	speicher_textur(bilderarray[1], figurenpfad + "Blob_2_gerade.png")
	speicher_textur(bilderarray[2], figurenpfad + "Blob_3_gerade.png")
	speicher_textur(bilderarray[3], figurenpfad + "Blob_4_gerade.png")
	speicher_textur(bilderarray[4], figurenpfad + "Blob_5_gerade.png")
	speicher_textur(bilderarray[5], figurenpfad + "Kanonenkugel.png")
	
	speicher_textur(bilderarray[6], coinpfad + "BadCoin1.png")
	speicher_textur(bilderarray[7], coinpfad + "BadCoin2.png")
	speicher_textur(bilderarray[8], coinpfad + "GoodCoin1.png")
	speicher_textur(bilderarray[9], coinpfad + "GoodCoin2.png")
	speicher_textur(bilderarray[10], coinpfad + "RandomCoin.png")
	
	speicher_textur(bilderarray[11], hintergrundpfad + "Hintergrund.png")

func erstelle_veraenderungsdatei():
	var veraenderungsdatei = File.new()
	veraenderungsdatei.open(hauptverzeichnis_benutzer + "veraendert", File.WRITE)
	veraenderungsdatei.close()

func loesche_veraenderungsdatei():
	var vaeraenderungsdatei = Directory.new()
	vaeraenderungsdatei.remove(hauptverzeichnis_benutzer + "veraendert")