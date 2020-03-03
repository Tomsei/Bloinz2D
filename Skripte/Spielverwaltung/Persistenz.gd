extends Node2D

# Das Skript dient zum dauerhaften Speichern von Nutzereingaben. Es beinhaltet Methoden zum
# speichern und laden der Dateien.

# Gibt den Pfad zum Hauptverzeichnis des Benutzers an.
var hauptverzeichnis_benutzer = OS.get_user_data_dir() + "/"
# Gibt Ausschlusswoerter, welche nicht kopiert werden sollen, an.
var nicht_kopieren = [".git", ".gitignore", "project.godot", ".cfg"]
# Variable die entscheidet ob alle Dateien behalten bleiben sollen oder neu geschrieben werden.
var dateien_behalten = false

# Funktion wird zu Szenenstart aufgerufen.
func _ready():
	# Wenn das Nutzerverzeichnis nicht /userfs ist, befinden wir uns nicht im Web und muessen
	# keinen zusaetzlichen / hinter dem user_data_dir haben.
	if (OS.get_user_data_dir() != "/userfs"):
		hauptverzeichnis_benutzer = OS.get_user_data_dir()

# Initiiert und schreibt ggf alle Programmdateien in das Benutzerverzeichnis.
func init():
	# Checkt ob Nutzerveraenderte Daten vorhanden sind.
	var dateien_vorhanden = pruefe_ob_veranderte_dateien_existieren()
	dateien_behalten = true
	# Fuehre nur aus, wenn keine Dateien vorhanden sind.
	if pruefe_ob_dateien_im_nutzerverzeichnis_existieren() == false:
		erstelle_datei_und_ordnerstruktur("res://")
		loesche_veraenderungsdatei()
	return dateien_vorhanden

# Loescht alle Benuzterdateien und schreibt diese neu.
func zuruecksetzen():
	# Dateien sollen ueberschrieben werden-
	dateien_behalten = false
	# Alle Ordner und Dateien innerhalb des res:// Ordners werden neu gelesen und geschrieben.
	erstelle_datei_und_ordnerstruktur("res://")
	# Sollte die Pruefdatei existieren, welche ansagt, dass veraenderungen vorgenommen wurde,
	# wird diese geloescht.
	loesche_veraenderungsdatei()

# Loescht nur alle Skripte und schreibt diese neu. Bilder bleiben erhalten.
func skripte_zuruecksetzen():
	dateien_behalten = false
	# Alle Ordner und Dateien innerhalb des Skripte Ordners werden neu gelesen und geschrieben.
	erstelle_datei_und_ordnerstruktur("res://Skripte")

# Laedt ein Image aus uebergebenem Pfad. Pfad muss mit res:// anfangen.
func lade_bild(bildpfad):
	# Laedt die Bildtextur aus dem Pfad.
	var textur = lade_bildtextur(bildpfad)
	# Erzeugt ein Bild aus der Textur.
	var erzeugtesBild = textur.get_data()
	# Gibt das Bild zurueck.
	return erzeugtesBild

# Laedt eine Bildtextur aus uebergebenem Pfad.
func lade_bildtextur(bildpfad):
	# Erzeugt Dateivariable
	var datei = File.new()
	# Oeffnet die Datei zum lesen.
	datei.open(hauptverzeichnis_benutzer + bildpfad.lstrip("res:/"), File.READ)
	# Liest die Datei als Variant aus.
	# Wenn eine Variant gelesen wird, kann es ein beliebiges Dateiformat haben.
	var imgtext = datei.get_var(true)
	# Schliesst die Datei.
	datei.close()
	# Gibt die gelesene Bildtextur zurueck.
	return imgtext

# Erstellt die Ordner und Dateistruktur des uebergebenem Pfads.
func erstelle_datei_und_ordnerstruktur(pfad):
	# Erzeugt eine Ordnervariable.
	var ober_ordner = Directory.new()
	# Oeffnet den Ordnerpfad.
	ober_ordner.open(pfad)
	# Prueft ob unterordner vorhanden sind.
	var err = ober_ordner.list_dir_begin(true, true)
	# Sind keine unterordner vorhanden, wird die Methode beendet.
	if err != OK:
		print("Ordner nicht gefunden")
		return ""
	# Liest den naechsten Ordner oder die naechste Datei in element.
	var element = ober_ordner.get_next()
	# Schleife laeuft so lange durch bis keine Elemente mehr existieren.
	while element != "":
		# Prueft ob das Element ein Ordner ist.
		if ist_ordner(element):
			# Wenn der Ordner existiert wird er uebersprungen.
			if ordner_existiert(pfad + "/" + element) == false:
				# Wenn wir im Oberverzeichnis sind, wird direkt in das Verzeichnis geschrieben.
				if pfad == "res://":
					erstelle_ordner(hauptverzeichnis_benutzer + pfad.lstrip("res:/") + element)
				# Wenn wir in einem Unterordner sind, muss nach dem Pfad noch ein / eingefuegt werden.
				else :
					erstelle_ordner(hauptverzeichnis_benutzer + pfad.lstrip("res:/") + "/" + element)
			# Wenn ein Ordner einen verbotenen Namenteil hat wird dieser ignoriert und keine weitere
			# Ordnerstruktur fuer diesen erstellt.
			if hat_verbotene_namen(element) == false:
				# Die Mehtode wird rekursiv aufgerufen um die Unterordner zu erstellen.
				erstelle_datei_und_ordnerstruktur(pfad + "/" + element)
		# Da das Element kein Ordner ist, ist es eine Datei.
		else:
			# Falls die Datei nicht existiert und keine verbotenen Namen hat wird sie erstellt.
			if (datei_existiert(pfad + "/" + element) == false) && (hat_verbotene_namen(element) == false):
				erstelle_dateien(pfad + "/" + element)
		# Das naechste Element auf der aktuellen Ordnereben wird geladen.
		element = ober_ordner.get_next()
	# Der Ordner wird geschlossen.
	ober_ordner.list_dir_end()


# Prueft ob der Dateiname ein Ordner ist. Wenn ein punkt gefunden wird ist es eine Datei.
func ist_ordner(dateiname):
	return dateiname.find(".") == -1
	

# Speichert ein Bild als Textur.
func speicher_bild_als_textur(bild, bildSpeicherpfad):
	# Eine neue Bildtextur wird erstellt.
	var textur = ImageTexture.new()
	# Das uebergebene Bild wird in eine Textur konvertiert.
	textur.create_from_image(bild)
	# Die Textur wird gespeichert.
	speicher_textur(textur, bildSpeicherpfad)

# Speichert die übergebene Textur.
func speicher_textur(textur, bildSpeicherpfad):
	# Erzeugt Dateivariable.
	var datei = File.new()
	# Oeffnet den Bildpfad zum schreiben.
	datei.open(hauptverzeichnis_benutzer + bildSpeicherpfad.lstrip("res:/"), File.WRITE)
	# Speichert die Textur als Variant.
	datei.store_var(textur, true)
	# Schliesst die Datei.
	datei.close()
	
	# Wenn eine Textur gespeichert wird, hat sich etwas veraendert.
	# Deshalb wird hier die Veraenderungsdatei erstellt.
	erstelle_veraenderungsdatei()

# Speichert ein Bild als Varianttyp. Bild muss spaeter als Variant geladen werden.
# Der Ladepfad muss ohne '.import' sein. Der speicherpfad sollte fuer den webexport
# ohne .import und anstatt dem res:// das userverzeichnis haben.
func speicher_bild_als_variant(bildLadePfad,bildSpeicherpfad):
	# Laedt eine Bildtextur aus dem bildLadePfad.
	var bildtextur = load(bildLadePfad)
	# Erzeugt eine Dateivariable.
	var datei = File.new()
	
	# Datei wird zum schreiben geoffnet. Wenn diese nicht existiert wird sie erstellt.
	datei.open(bildSpeicherpfad, File.WRITE)
	
	# Die Bildtextur wird als Variant gespeichert.
	datei.store_var(bildtextur, true)
	# Die Datei wird geschlossen.
	datei.close()
	
	# Wenn eine Textur gespeichert wird, hat sich etwas veraendert.
	# Deshalb wird hier die Veraenderungsdatei erstellt.
	erstelle_veraenderungsdatei()

# Speichert eine wav-Datei als Varianttyp. wav muss spaeter als Variant geladen werden.
# Der Ladepfad muss ohne '.import' sein. Der speicherpfad sollte fuer den webexport
# ohne .import und anstatt dem res:// das userverzeichnis haben.
func speicher_wav_als_variant(wavLadePfad, wavSpeicherpfad):
	# Erzeuge Dateivariable.
	var datei = File.new()
	# Laedt eine Sounddatei ein.
	var sound = load(wavLadePfad)
	# Oeffnet die datei zum schreiben. Wenn diese nicht existiert wird sie erstellt.
	datei.open(wavSpeicherpfad, File.WRITE)
	
	# Speichert den Sound als Variant.
	datei.store_var(sound, true)
	# Die Datei wird geschlossen.
	datei.close()
	
	# Wenn ein Sound gespeichert wird, hat sich etwas veraendert.
	# Deshalb wird hier die Veraenderungsdatei erstellt.
	erstelle_veraenderungsdatei()

# Speichert ein Skript oder eine Szene im userverzeichnis ab.
# Der Speicherpfad sollte fuer den webexport anstatt dem res:// das userverzeichnis haben.
func speicher_skript_oder_szene_als_var(skriptSzenenLadepfad,skriptSzenenSpeicherpfad):
	# Erzeugt Dateivariable
	var datei = File.new()
	
	# Datei wird zum lesen geoeffnet.
	datei.open(skriptSzenenLadepfad, File.READ)
	# Liest das Skript oder die Szene als Text aus.
	var script_text = datei.get_as_text()
	# Datei wird geschlossen.
	datei.close()
	
	# Das Skript oder die Szene wird gespeichert.
	speicher_text(script_text, skriptSzenenSpeicherpfad)

# Speichert textbasierte Dateien.
func speicher_text(text, speicherpfad):
	# Erzeugt Dateivariable
	var datei = File.new()
	
	# Oeffnet die datei zum schreiben. Wenn diese nicht existiert wird sie erstellt.
	datei.open(speicherpfad, File.WRITE)
	# Speichert den Text in Klartext.
	datei.store_string(text)
	# Datei wird geschlossen.
	datei.close()
	
	# Wenn ein Sound gespeichert wird, hat sich etwas veraendert.
	# Deshalb wird hier die Veraenderungsdatei erstellt.
	erstelle_veraenderungsdatei()

# Prueft ob das Element verbotene namen enthaelt.
func hat_verbotene_namen(element):
	var ist_verboten = false
	# Eine Schleife die jedes Wort der verbotenen Liste durchlaeuft.
	for wort in nicht_kopieren:
		# Wird in einem Teil des Elements das verbotene Wort gefunden, gibt die Methode true zurueck.
		if element.find(wort) != -1:
			ist_verboten = true
	# Gibt zurueck ob das Element eins der verbotenen Woerter beinhaltet oder nicht.
	return ist_verboten

# Erstelle den Ordner.
func erstelle_ordner(ordnerpfad):
	# Erzeugt Ordnervariable.
	var ordner = Directory.new()
	# Der Order wird erstellt.
	ordner.make_dir(ordnerpfad)

# Erstelle die Datei im Benutzerverzeichnis.
func erstelle_dateien(dateienpfad):
	# Erzeugt Dateivariable.
	var datei = File.new()
	# Entferne den Pfadanfang um mehrfache Slashes zu vermeiden.
	dateienpfad = "res://" + dateienpfad.lstrip("res:/")
	# Wenn die Datei im Resourceverzeichnis existiert wird weiter gemacht.
	if datei.file_exists(dateienpfad) == true:
		# Der Dateipfad wird in seine Ordner und den Dateinamen durch das aufspalten bei den / aufgeteilt.
		var dateiname = dateienpfad.split("/")
		# Der Dateiname ist immer das letzte Element im Dateipfad.
		dateiname = dateiname[dateiname.size() -1]
		# Datei ist Bild wenn sie .png im Dateienpfad hat.
		if dateienpfad.find(".png") != -1:
			# Fuer den bildLadepfad muss das .import entfernt werden, damit das Bild richtig geladen wird.
			# Fuer den bilSpeicherpfad muss das res entfernt und mit dem userverzeichnis ersetzt werden.
			# Ebenfalls soll das Bild als png und nicht als import gespeichert werden.
			speicher_bild_als_variant(dateienpfad.rstrip(".import"), hauptverzeichnis_benutzer + dateienpfad.lstrip("res:/").rstrip(".import"))
		# Datei ist ein Sound wenn sie .wav im Dateienpfad hat.
		elif dateienpfad.find(".wav") != -1:
			# Es werden die gleichen veraenderungen wie beim Bild vorgenommen.
			speicher_wav_als_variant(dateienpfad.rstrip(".import"), hauptverzeichnis_benutzer + dateienpfad.lstrip("res:/").rstrip(".import"))
		# Datei ist ein Skript oder eine Szene wenn entweder .gd oder .tscn im Dateienpfad enthalten sind.
		# Skripte und Szenen werden gleich geladen und gespeichert, da sie in Klartext vorliegen.
		elif dateienpfad.find(".gd") != -1 || dateienpfad.find(".tscn") != -1:
			# Es werden fast die gleichen veraenderungen wie beim Bild vorgenommen. Bei Textdateien gibt es kein .import,
			# welches entfernt werden muss.
			speicher_skript_oder_szene_als_var(dateienpfad, hauptverzeichnis_benutzer + dateienpfad.lstrip("res:/"))
			

# Prueft ob die Datei schon vorhanden ist.
func datei_existiert(dateipfad):
	# Erzeugt Dateivariable
	var datei = File.new()
	# Es wird geprueft ob die Datei behalten werden soll und die Datei bereits im Benutzerverzeichnis existiert.
	# Sind beide Bedingungen wahr wird true zurueckgegeben. Anderfalls false.
	return dateien_behalten && datei.file_exists(hauptverzeichnis_benutzer + dateipfad.lstrip("res:/").rstrip(".import"))

# Prueft ob ein Ordner bereits existiert.
func ordner_existiert(ordnerpfad):
	# Erzeugt Ordnervariable.
	var ordner = Directory.new()
	# Es wird geprueft ob der Ordner behaltn werden soll und der Ordner bereits im Benutzerverzeichnis existiert.
	# Sind beide Bedingungen wahr wird true zurueckgegeben. Anderfalls false.
	return dateien_behalten && ordner.dir_exists(hauptverzeichnis_benutzer + ordnerpfad.lstrip("res:/"))

# Prueft nur ob eine Datei existiert. Dabei ist unwichtig ob die Datei behalten werden soll oder nicht.
func pruefe_ob_dateien_existieren(dateiname):
	# Erzeugt Dateivariable.
	var datei = File.new()
	# Wenn die Datei im Benutzerverzeichnis existiert wird true zurueckgegeben. Anderfalls false.
	return datei.file_exists(hauptverzeichnis_benutzer + dateiname)

# Prueft ob die bereits Veraenderungen gemacht worden sind.
# Dafuer wird kontrolliert ob die Datei 'veraendert' im Obreordner des Benutzerverzeichnises existiert.
func pruefe_ob_veranderte_dateien_existieren():
	# Wenn die Datei 'veraendert' im Benutzerverzeichnis existiert wird true zurueckgegeben. Anderfalls false.
	return pruefe_ob_dateien_existieren("veraendert")

# Prueft ob ueberhaupt Dateien im Benutzerverzeichnis existieren.
# Dafuer wird kontrolliert ob die Datei 'icon.png' im Oberordner des Benutzerverzeichnises existiert.
# Diese Datei wird beim initialen erstellen des Verzeichnises erstellt.
func pruefe_ob_dateien_im_nutzerverzeichnis_existieren():
	return pruefe_ob_dateien_existieren("icon.png")

# Exportiert die Bilder die im Programm aktuell genutzt werden.
# Dazu werden die aktuell verwendeten Bilder der Elemente in einen
# Base64-String konvertiert und zurueckgegeben.
func exportiere_eigene_dateien():
	# Erstellt einen String um das Bilderarray in Text zu speichern.
	var exportstring = ""
	# Erstellt ein Array um die geladenen Bilder zu speichern.
	var bilder = []
	# Konvertiert die Bilder zu einem Base64-String und speichert diesen in das Array Bilder.
	bilder = konvertiere_bilder_zu_base64()
	# Speicher die Textdarstellung des Bilderarrays in exportstring.
	exportstring = str(bilder[0])
	# Gibt die Textdarstellung der Bilder als Base64-String zurueck.
	return bilder

# Konvertiert die aktuell verwendeten Bilder der Elemente in einen Base64-
# String und gibt diesen zurueck.
func konvertiere_bilder_zu_base64():
	# Erstellt ein Array fuer die geladenen Bilder.
	var bilder = []
	# Der Hauptpfad fuer die Bilder.
	var bilderpfad = "res://Bilder/Standardspielfiguren/"
	# Der Hauptpfad fuer die Coins.
	var coinpfad = bilderpfad + "Coins/"
	# Der Hauptpfad fuer die Figuren.
	var figurenpfad = bilderpfad + "Spielfiguren/"
	# Der Hauptpfad fuer den Hintergrund.
	var hintergrundpfad = bilderpfad + "Hintergrund/"
	
	# Laedt ein Bild einer Figur und fuegt es dem Bilderarray hinzu.
	bilder.append(lade_bildtextur(figurenpfad + "Blob_1_gerade.png"))
	bilder.append(lade_bildtextur(figurenpfad + "Blob_2_gerade.png"))
	bilder.append(lade_bildtextur(figurenpfad + "Blob_3_gerade.png"))
	bilder.append(lade_bildtextur(figurenpfad + "Blob_4_gerade.png"))
	bilder.append(lade_bildtextur(figurenpfad + "Blob_5_gerade.png"))
	
	# Laedt das Bild der Kanonenkugel und fuegt es dem Bilderarray hinzu.
	bilder.append(lade_bildtextur(figurenpfad + "Kanonenkugel.png"))
	
	# Laedt ein Bild einer Muenze und fuegt es dem Bilderarray hinzu.
	bilder.append(lade_bildtextur(coinpfad + "BadCoin1.png"))
	bilder.append(lade_bildtextur(coinpfad + "BadCoin2.png"))
	bilder.append(lade_bildtextur(coinpfad + "GoodCoin1.png"))
	bilder.append(lade_bildtextur(coinpfad + "GoodCoin2.png"))
	bilder.append(lade_bildtextur(coinpfad + "RandomCoin.png"))
	
	# Laedt das Bild des Hintergrunds und fuegt es dem Bilderarray hinzu.
	bilder.append(lade_bildtextur(hintergrundpfad + "Hintergrund.png"))
	
	# Gibt die Base64 repraesentation des Bilderarrays zurueck.
	return Marshalls.variant_to_base64(bilder ,true)

# Importiert einen Base64-String eines Bilderarrays.
func importiere_eigene_dateien(importstring):
	# Erzeugt das Bilderarray aus dem Base64-String.
	var arr = Marshalls.base64_to_variant(importstring, true)
	# Speichert das erzeugte Bilderarray um die Bilder direkt zu verwenden.
	speicher_bilderarray(arr)

# Speichert die Bilder aus dem Bilderarray an der passenden Stelle
# so dass die Bilder direkt im Programm verwendert werden koennen.
func speicher_bilderarray(bilderarray):
	# Der Hauptpfad fuer die Bilder.
	var bilderpfad = "res://Bilder/Standardspielfiguren/"
	# Der Hauptpfad fuer die Muenzen.
	var coinpfad = bilderpfad + "Coins/"
	# Der Hauptpfad fuer die Spielfiguren.
	var figurenpfad = bilderpfad + "Spielfiguren/"
	# Der Hauptpfad fuer den Hintergrund.
	var hintergrundpfad = bilderpfad + "Hintergrund/"
	
	# Speichert die Bildtextur der Figruen an der passenden Stelle.
	speicher_textur(bilderarray[0], figurenpfad + "Blob_1_gerade.png")
	speicher_textur(bilderarray[1], figurenpfad + "Blob_2_gerade.png")
	speicher_textur(bilderarray[2], figurenpfad + "Blob_3_gerade.png")
	speicher_textur(bilderarray[3], figurenpfad + "Blob_4_gerade.png")
	speicher_textur(bilderarray[4], figurenpfad + "Blob_5_gerade.png")
	speicher_textur(bilderarray[5], figurenpfad + "Kanonenkugel.png")
	
	# Speichert die Bildtextur der Muenzen an der passenden Stelle.
	speicher_textur(bilderarray[6], coinpfad + "BadCoin1.png")
	speicher_textur(bilderarray[7], coinpfad + "BadCoin2.png")
	speicher_textur(bilderarray[8], coinpfad + "GoodCoin1.png")
	speicher_textur(bilderarray[9], coinpfad + "GoodCoin2.png")
	speicher_textur(bilderarray[10], coinpfad + "RandomCoin.png")
	
	# Speichert die Bildtextur des Hintergrundes an der passenden Stelle.
	speicher_textur(bilderarray[11], hintergrundpfad + "Hintergrund.png")

# Erstellt die Veraenderungsdatei.
# Diese Datei gibt an ob der Benutzer veraenderungen an dem Code oder
# den Bildern gemacht hat.
func erstelle_veraenderungsdatei():
	# Erzeugt Dateivariable.
	var veraenderungsdatei = File.new()
	# Oeffnet die Datei zum schreiben. Existiert diese nicht, wird sie erstellt.
	veraenderungsdatei.open(hauptverzeichnis_benutzer + "veraendert", File.WRITE)
	# Schliesst die Datei.
	veraenderungsdatei.close()

# Loescht die Veraenderungsdatei
func loesche_veraenderungsdatei():
	# Erzeugt eine Ordnervariable.
	var vaeraenderungsdatei = Directory.new()
	# Entfernt die Veraenderungsdatei aus dem Benutzerverzeichnis.
	vaeraenderungsdatei.remove(hauptverzeichnis_benutzer + "veraendert")

# Liest Skript aus und veraendert den Wert der uebergebenen Variable.
func schreibe_variable_in_datei(variablenname, neuer_wert, dateipfad):
	var kompletter_code = ""
	var datei = File.new()
	var err = datei.open(hauptverzeichnis_benutzer + dateipfad.lstrip("res:/"), File.READ)
	if err != OK:
		err = datei.open(dateipfad, File.READ)
		if err != OK:
			printerr("Datei konnte nicht geladen werden, error code ", err)
			return ""
	while(!datei.eof_reached()):
		var codezeile = datei.get_line()
		if (codezeile.find("var " + variablenname) != -1):
			var variable = codezeile.split("=")[0]
			if typeof(neuer_wert) == TYPE_DICTIONARY:
				codezeile = variable + "= " + erstelle_dictionary_werte(neuer_wert)
			else:
				codezeile = variable + "= " + str(neuer_wert)
			
		kompletter_code += codezeile + "\n"
	speicher_text(kompletter_code, hauptverzeichnis_benutzer + dateipfad.lstrip("res:/"))

# Erzeugt die Stringrepraesentation eines Dictionarys mit String als Schluessel und einem Array mit zwei Vector2 als Wert.
func erstelle_dictionary_werte(dictionary):
	var dictionarywerte = "{"
	var schluessel = dictionary.keys()
	for ein_schluessel in schluessel:
		dictionarywerte += "\"" + str(ein_schluessel) + "\" : [Vector2"+ str(dictionary[ein_schluessel][0]) + ", Vector2" + str(dictionary[ein_schluessel][1]) + "] , "
	dictionarywerte = dictionarywerte.rstrip(" , ") + "}"
	return dictionarywerte