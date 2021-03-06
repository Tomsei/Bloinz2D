extends Sprite

#gibt Größe des Bildes an, auf welchem gemalt wird
var bildgroesse;
#Farbe mit welcher zur Zeit gezeichnet wird
var aktuelle_farbe;
#Werkzeug welches ausgewählt ist, z.B. Stift, Linie, Ellipse ...
var modus=null;
#wichtig für Linie,Ellipse, Rechteck
var linien_start;
var linien_ende;
#Größe des Stiftes
var stiftgroesse;
#sich auf der Zeichenfläche befindende Bild
var bild;
# Bild, bevor es eventuell verändert wurde
var original_bild;
var alterInhalt
var textur;
var array;
#merkt sich, welcher Figurknopf gedrückt ist
var aktiver_knopf;
#Modus, welcher vor einem Dialogfenster aktiv war
var alter_modus;
#merkt sich ob die Vorschau ein Blob, Coin oder Hintergrund ist 
var vorschau;
#welche Buttons gerade gedrückt sind
var aktuellerFarbbutton;
var aktuellerStiftbutton;
var aktuellerModusbutton;
#für rückgängig und wiederholen
var rueckgaengigstapel;
var wiederholenstapel;
#Größe des Bildes
var minx;
var maxx;
var miny;
var maxy;
#für eigene Farbe
var eigeneFarbe;
var eigeneFarbeaktuell;
#werden genutzt bei der Vorschau von Linie, Ellipse und Rechteck
var temporaeresBild;
var temporaereZeichenflaeche;
var coinWechsel;
var alte_vorschau;
var persistenz = preload("res://Szenen/Spielverwaltung/Persistenz.tscn").instance();
var vorlage;
#speichert die Größen aller Figuren
var groesseFigur;
var popup_offen= false;



"""
Konstruktor von Zeichenfläche,
setzen der Instanzvariablen,
Einladen von Bilder
"""
func _ready():
	

	# Setze Bildschirmgroesse.
	OS.set_window_size(Vector2(1030,680));
	JavaScript.eval("resizeSpiel(680,1030)")
	
	# Zentriert das Fenster in der Bildschirmmitte
	preload("res://Szenen/Spielverwaltung/UI.tscn").instance().bildschirm_zentrieren()
	
	#Farbe voreinstellen
	aktuellerFarbbutton= get_node("../Farbe9");
	aktuellerFarbbutton.pressed= true;
	aktuelle_farbe = Color(1,1,1,1);

	
	#Stiftgroesse voreinstellen
	#modus = "Stift";
	stiftgroesse = 1;
	aktuellerStiftbutton = get_node("../klein");
	aktuellerStiftbutton.pressed= true;
	aktuellerModusbutton = get_node("../Stift");
	aktuellerModusbutton.pressed= true;
	
	#64*64 groesses Bild was gespeichert wird
	bildgroesse = 64;
	bild = Image.new();
	bild.create(bildgroesse, bildgroesse, false, Image.FORMAT_RGBA8);
	original_bild = Image.new();
	textur = ImageTexture.new();
	aktiver_knopf=" ";

	temporaeresBild= Image.new();
	temporaeresBild.create(bildgroesse, bildgroesse, false, Image.FORMAT_RGBA8);
	temporaereZeichenflaeche=get_node("../temporaereZeichenflaeche");
	
	#Anfangsknopf auf ersten Blob setzen
	aktiver_knopf= "Blob_1_gerade";
	get_node("../Blob_1_gerade").pressed = true;
	vorschau="Blob"
	
	#Bild der Figur einladen
	einladen(aktiver_knopf);
	original_bild.copy_from(bild);
	bild.premultiply_alpha();
	#Standardbutton setzen
	setze_Standardbutton();
	#Vorlagebuttonssetzen
	setze_Vorlagen();
	#Vorschau aktualisieren
	aktualisiere_vorschau();
	
	#Größen der einzelnen Figuren 
	groesseFigur = {};
	#Spielfiguren auf Knöpfen laden und Größe ausrechnen
	lade_Knopfbilder();
	#Informationen weitergeben
	einstellungen.figurengroesse= groesseFigur;

	#initalisiere die Rückgängigstapel
	rueckgaengigstapel= [];
	Abbild_auf_Rueckgaengigstapel();
	wiederholenstapel=[];
	
	#eigene Farben einladen
	eigeneFarbe=[];
	eigeneFarbe.resize(5);
	eigene_Farben_einladen();
	
	#Colorpicker verändern
	get_node("../Farbwahl").get_children()[6].get_children()[1].hide();
	get_node("../Farbwahl").get_children()[5].hide();
	get_node("../Farbwahl").get_children()[4].get_children()[4].hide();


"""
Funktion, die ein 2D-Array erstellt
übernommen, siehe Quellen 
Eingabe width: Weite des Arrays
Eingabe height: Höhe des Arrays
Eingabe value: Wert mit dem das Array gefüllt werden soll
"""
func create_2d_array(width, height, value):
    var a = []

    for y in range(height):
        a.append([])
        a[y].resize(width)

        for x in range(width):
            a[y][x] = value

    return a


""" 
malt einen Punkt auf das 64 * 64 große Bild
dabei wird darauf geachtet, dass der Zeichenstil im Pixelformat ist 
Eingabe x: x-Wert vom Pixel unten links
Eingabe y: y-Wert vom Pixel unten links 
"""	
func punkt_malen_pixel(x,y):
	var xneu = floor(x/8);
	var yneu = floor(y/8);
	bild.lock();
	for i in range(0, stiftgroesse):
		for j in range(0, stiftgroesse):
			bild.set_pixel(xneu+i, yneu+j, aktuelle_farbe);
	bild.unlock();


"""
löscht einen Punkt auf dem 64 * 64 große Bild
dabei wird darauf geachtet, dass der Zeichenstil im Pixelformat ist 
Eingabe x: x-Wert vom Pixel unten links
Eingabe y: y-Wert vom Pixel unten links 
"""
func punkt_loeschen_pixel(x, y):
	var xneu = floor(x/8);
	var yneu = floor(y/8);
	bild.lock();
	for i in range(0, stiftgroesse):
		for j in range(0, stiftgroesse):
			bild.set_pixel(xneu+i, yneu+j, Color(0,0,0,0));
	bild.unlock();


"""
Ein Array in der selben Größe wie das Bild der Zeichenfläche
wird mit den Farbinformationen befüllt
-> wird später zum schnelleren Füllen benötigt
"""
func befuellen():
	bild.lock();
	for x in range(64):
		for y in range(64):
			array[x][y] = bild.get_pixel(x,y);
	bild.unlock();


"""
Methode, die bei jedem neuen Time_Frame aufgerufen wird
Geprüft wird, ob es eine Eingabe mit der linken Maustaste gab und in welchem Modus sich der Editor befindet
je nach dem werden verschiedene Aktionen ausgeführt
"""
func _process(delta):
		if Input.is_action_just_pressed("draw"):
			var mouseposition = get_global_mouse_position();
			if mouseposition.x >= 256 and mouseposition.y < 512 and mouseposition.x < 767 and mouseposition.y >= 0:
				if modus =="Fuellen":
					wiederholenstapel = [];
					array = create_2d_array(64,64,Color(0,0,0,0));
					befuellen();
					fuellen(aktuelle_farbe,((mouseposition.x-256)/8),(mouseposition.y/8), array[(mouseposition.x-256)/8][mouseposition.y/8]);
					bild.lock();
					for zeile in range(64):
						for spalte in range(64):
							bild.set_pixel(zeile, spalte,array[zeile][spalte]);
					bild.unlock();
					setze_Zeichenflaeche();
					aktualisiere_vorschau();
					Abbild_auf_Rueckgaengigstapel();
		elif Input.is_action_pressed("draw"):
			var mouseposition = get_global_mouse_position();
			if mouseposition.x >= 256 and mouseposition.y < 512 and mouseposition.x < 767 and mouseposition.y >= 0:
				if modus=="Stift":
					punkt_malen_pixel((mouseposition.x-256),mouseposition.y);
					aktualisiere_vorschau();
					setze_Zeichenflaeche();
				elif modus == "Radierer":
					punkt_loeschen_pixel((mouseposition.x-256),mouseposition.y);
					aktualisiere_vorschau();
					setze_Zeichenflaeche();
				elif modus == "Rechteck":
					if linien_start == null:
						linien_start = get_global_mouse_position();
						linien_start.x = linien_start.x-256;
					else:
						linien_ende = get_global_mouse_position();
						linien_ende.x = linien_ende.x-256;
						leere_temporaere_Zeichenflaeche();
						male_Rechteck(linien_start,linien_ende);
				elif modus == "Linie":
					if linien_start == null:
						linien_start = get_global_mouse_position();
						linien_start.x = linien_start.x-256;
					else:
						linien_ende = get_global_mouse_position();
						linien_ende.x = linien_ende.x-256;
						leere_temporaere_Zeichenflaeche();
						male_Linie(linien_start,linien_ende);
				elif modus == "Ellipse":
					if linien_start == null:
						linien_start = get_global_mouse_position();
						linien_start.x = linien_start.x-256;
						linien_start.x = floor(linien_start.x/8);
						linien_start.y = floor(linien_start.y/8);
					else:
						linien_ende = get_global_mouse_position();
						linien_ende.x = linien_ende.x-256;
						linien_ende.x = floor(linien_ende.x/8);
						linien_ende.y = floor(linien_ende.y/8);
						leere_temporaere_Zeichenflaeche();

						var radiusx =abs(linien_ende.x-linien_start.x);
						var radiusy= abs(linien_ende.y-linien_start.y);

						var cx;
						var cy;
						if linien_ende.x > linien_start.x:
							cx= linien_start.x+floor(0.5*radiusx);
						else:
							cx= linien_ende.x+floor(0.5*radiusx);
						if linien_ende.y > linien_start.y:
							cy= linien_start.y+floor(0.5*radiusy);
						else:
							cy= linien_ende.y+floor(0.5*radiusy);
						male_Ellipse(cx,cy,radiusx,radiusy);
		elif Input.is_action_just_released("draw"):
			var mouseposition = get_global_mouse_position();
			if (modus=="Rechteck" or modus =="Linie" or modus =="Ellipse") and linien_start != null:
				linien_start= null;
				linien_ende = null;
				wiederholenstapel = [];
				uebernehme_temporaere_Zeichenflaeche();
				# Absetzen auch außerhalb Zeichenfläche aber kein Abbild bei Klick außerhalb
				Abbild_auf_Rueckgaengigstapel();
			if mouseposition.x >= 256 and mouseposition.y < 512 and mouseposition.x < 767 and mouseposition.y >= 0:
				if modus =="Radierer" or modus=="Stift":
					wiederholenstapel = [];
					Abbild_auf_Rueckgaengigstapel();
				elif modus == "Dialog" or modus == null:
					if modus == null:
						modus="Stift";
					elif popup_offen != true:
						modus=alter_modus;
		elif Input.is_action_just_pressed("undo"):
			mache_rueckgaengig();
		elif Input.is_action_just_pressed("redo"):
			wiederhole();


"""
speichert die Zeichenfläche ab
Eingabe bildname: gib den Namen für den Speicherpfad an
Eingabe Knopf: gibt an welcher Knopf aktualisiert werden soll
"""
func speichern(bildname, knopf):
	
	
	#Bild in den Dateien speichern
	if vorschau=="Blob":
		persistenz.speicher_bild_als_textur(bild, "Bilder/Standardspielfiguren/Spielfiguren/"+bildname+".png");
		persistenz.speicher_bild_als_textur(bild, "Bilder/Standardspielfiguren/Spielfiguren/"+bildname.substr(0,7)+"seitlich.png");
	elif vorschau =="Coin":
		persistenz.speicher_bild_als_textur(bild, "Bilder/Standardspielfiguren/Coins/"+bildname+".png");	
	else:
		persistenz.speicher_bild_als_textur(bild, "Bilder/Standardspielfiguren/Hintergrund/Hintergrund"+".png");
	
	#Knopf aktualisieren
	knopf_aktualisieren(knopf, bild);
	groesseFigur[bildname] = groesse_Zeichnung(bild);
	einstellungen.figurengroesse = groesseFigur
	# Speichern der Figurengroesse.
	persistenz.schreibe_variable_in_datei("figurengroesse", groesseFigur, "res://Skripte/Spielverwaltung/Informationsübertragung.gd")


"""
aktualisiert das Icon eines Knopfes mit einem Bild
Eingabe Name: Name des Knopfes der aktualisiert werden soll
Eingabe _bild: Bild welches auf den Knopf soll
"""
func knopf_aktualisieren(name, _bild):
	#Knopf mit aktualisiertem Bild
	var Pfad = "../"+ name;
	get_node(Pfad).icon= mache_Textur(_bild);


"""
Hilfsfunktion welches eine Textur von einem Bild erstellt
Eingabe _bild: Bild aus dem eine Textur gemacht werden soll
"""
func mache_Textur(_bild):
	var buttontextur = ImageTexture.new()
	buttontextur.create_from_image(_bild);
	return buttontextur;


"""
Wenn der Stiftknopf gedrückt wird,
wird der Modus auf Stift umgestellt
"""
func _on_Stift_pressed():
	modus = "Stift";
	aktuellerModusbutton.pressed= false;
	aktuellerModusbutton = get_node("../Stift");


"""
Wenn der Linienknopf gedrückt wird,
wird der Modus auf Linie umgestellt
"""
func _on_Linie_pressed():
	aktuellerModusbutton.pressed= false;
	aktuellerModusbutton = get_node("../Linie");
	modus = "Linie";


"""
Wenn der Radiererknopf gedrückt wird,
wird der Modus auf Radierer umgestellt
"""
func _on_Radierer_pressed():
	aktuellerModusbutton.pressed= false;
	aktuellerModusbutton = get_node("../Radierer");
	modus = "Radierer";


"""
Spiegelt das Bild horizontal wenn der Knopf Spiegeln gedrückt wird
"""
func _on_Spiegeln_pressed():
	bild.lock();
	bild.flip_x();
	bild.unlock();
	setze_Zeichenflaeche();
	aktualisiere_vorschau();
	wiederholenstapel= [];
	Abbild_auf_Rueckgaengigstapel();


"""
Wenn der Farbknopf gedrückt wird, wird die vorgespeicherte Farbe als aktuelle Farbe gesetzt
"""
func _on_Farbe1_pressed():
	if aktuellerFarbbutton != get_node("../Farbe1"):
		aktuellerFarbbutton.pressed= false;
		aktuellerFarbbutton= get_node("../Farbe1");
	else:
		aktuellerFarbbutton.pressed= true;
	aktuelle_farbe = Color(0.9,0.23,0.1);
	if modus =="Radierer":
		Farbwechsel_bei_Radierer();
	get_node("../Farbauswahl").hide();


"""
Wenn der Farbknopf gedrückt wird, wird die vorgespeicherte Farbe als aktuelle Farbe gesetzt
"""
func _on_Farbe2_pressed():
	if aktuellerFarbbutton != get_node("../Farbe2"):
		aktuellerFarbbutton.pressed= false;
		aktuellerFarbbutton= get_node("../Farbe2");
	else:
		aktuellerFarbbutton.pressed= true;
	aktuelle_farbe = Color(0.9,0.72,0.1);
	if modus =="Radierer":
		Farbwechsel_bei_Radierer();
	get_node("../Farbauswahl").hide();


"""
Wenn der Farbknopf gedrückt wird, wird die vorgespeicherte Farbe als aktuelle Farbe gesetzt
"""
func _on_Farbe3_pressed():
	if aktuellerFarbbutton != get_node("../Farbe3"):
		aktuellerFarbbutton.pressed= false;
		aktuellerFarbbutton= get_node("../Farbe3");
	else:
		aktuellerFarbbutton.pressed= true;
	aktuelle_farbe = Color(0.46,0.9,0.1);
	if modus =="Radierer":
		Farbwechsel_bei_Radierer();
	get_node("../Farbauswahl").hide();


"""
Wenn der Farbknopf gedrückt wird, wird die vorgespeicherte Farbe als aktuelle Farbe gesetzt
"""
func _on_Farbe4_pressed():
	if aktuellerFarbbutton != get_node("../Farbe4"):
		aktuellerFarbbutton.pressed= false;
		aktuellerFarbbutton= get_node("../Farbe4");
	else:
		aktuellerFarbbutton.pressed= true;
	aktuelle_farbe = Color(0.1,0.9,0.81);
	if modus =="Radierer":
		Farbwechsel_bei_Radierer();
	get_node("../Farbauswahl").hide();


"""
Wenn der Farbknopf gedrückt wird, wird die vorgespeicherte Farbe als aktuelle Farbe gesetzt
"""
func _on_Farbe5_pressed():
	if aktuellerFarbbutton != get_node("../Farbe5"):
		aktuellerFarbbutton.pressed= false;
		aktuellerFarbbutton= get_node("../Farbe5");
	else:
		aktuellerFarbbutton.pressed= true;
	aktuelle_farbe = Color(0.1,0.36,0.9);
	if modus =="Radierer":
		Farbwechsel_bei_Radierer();
	get_node("../Farbauswahl").hide();


"""
Wenn der Farbknopf gedrückt wird, wird die vorgespeicherte Farbe als aktuelle Farbe gesetzt
"""
func _on_Farbe6_pressed():
	if aktuellerFarbbutton != get_node("../Farbe6"):
		aktuellerFarbbutton.pressed= false;
		aktuellerFarbbutton= get_node("../Farbe6");
	else:
		aktuellerFarbbutton.pressed= true;
	aktuelle_farbe = Color(0.63,0.1,0.9);
	if modus =="Radierer":
		Farbwechsel_bei_Radierer();
	get_node("../Farbauswahl").hide();


"""
Wenn der Farbknopf gedrückt wird, wird die vorgespeicherte Farbe als aktuelle Farbe gesetzt
"""
func _on_Farbe7_pressed():
	if aktuellerFarbbutton != get_node("../Farbe7"):
		aktuellerFarbbutton.pressed= false;
		aktuellerFarbbutton= get_node("../Farbe7");
	else:
		aktuellerFarbbutton.pressed= true;
	aktuelle_farbe = Color(0.9,0.1,0.78);
	if modus =="Radierer":
		Farbwechsel_bei_Radierer();
	get_node("../Farbauswahl").hide();


"""
Wenn der Farbknopf gedrückt wird, wird die vorgespeicherte Farbe als aktuelle Farbe gesetzt
"""
func _on_Farbe8_pressed():
	if aktuellerFarbbutton != get_node("../Farbe8"):
		aktuellerFarbbutton.pressed= false;
		aktuellerFarbbutton= get_node("../Farbe8");
	else:
		aktuellerFarbbutton.pressed= true;
	aktuelle_farbe = Color(0.95,0.78,0.59);
	if modus =="Radierer":
		Farbwechsel_bei_Radierer();
	get_node("../Farbauswahl").hide();


"""
Wenn der Farbknopf gedrückt wird, wird die vorgespeicherte Farbe als aktuelle Farbe gesetzt
"""
func _on_Farbe9_pressed():
	if aktuellerFarbbutton != get_node("../Farbe9"):
		aktuellerFarbbutton.pressed= false;
		aktuellerFarbbutton= get_node("../Farbe9");
	else:
		aktuellerFarbbutton.pressed= true;
	aktuelle_farbe = Color(1,1,1);
	if modus =="Radierer":
		Farbwechsel_bei_Radierer();
	get_node("../Farbauswahl").hide();


"""
Wenn der Farbknopf gedrückt wird, wird die vorgespeicherte Farbe als aktuelle Farbe gesetzt
"""
func _on_Farbe10_pressed():
	if aktuellerFarbbutton != get_node("../Farbe10"):
		aktuellerFarbbutton.pressed= false;
		aktuellerFarbbutton= get_node("../Farbe10");
	else:
		aktuellerFarbbutton.pressed= true;
	aktuelle_farbe = Color(0,0,0);
	if modus =="Radierer":
		Farbwechsel_bei_Radierer();
	get_node("../Farbauswahl").hide();


"""
setzt die Stiftgröße auf klein
"""
func _on_klein_pressed():
		
	aktuellerStiftbutton.pressed= false;
	aktuellerStiftbutton = get_node("../klein");
	stiftgroesse= 1;


"""
setzt die Stiftgröße auf mittel
"""
func _on_mittel_pressed():
	aktuellerStiftbutton.pressed= false;
	aktuellerStiftbutton = get_node("../mittel");
	stiftgroesse= 2;


"""
setzt die Stiftgröße auf groß
"""
func _on_gro_pressed():
	aktuellerStiftbutton.pressed= false;
	aktuellerStiftbutton = get_node("../gross");
	stiftgroesse= 3;


"""
wechselt mit dem Zurückbutton zurück in das Spiel
"""
func _on_Zurueck_button_up():
	get_tree().change_scene("res://Szenen/Oberflaeche/Main.tscn")
	OS.set_window_size(Vector2(448,640))


"""
setzt den Modus auf Füllen
"""
func _on_Fuellen_pressed():
	modus="Fuellen";
	aktuellerModusbutton.pressed= false;
	aktuellerModusbutton = get_node("../Fuellen");

"""
füllt eine Fläche die ausgewählt wurde mit dem Floodfill Algorithmus
Eingabe x:
Eingabe y:
Eingabe alteFarbe: Farbe der Fläche die eingefärbt werden soll
Eingabe neueFarbe: neue Farbe mit der die Fläche eingefärbt wird
"""
func fuellen(neueFarbe,x,y, alteFarbe):
	var Punktstapel;
	Punktstapel=[];
	Punktstapel.push_front(Vector2(x,y));
	while(!Punktstapel.empty()):
		var koordinaten = Punktstapel.pop_front();
		if(array[koordinaten.x][koordinaten.y] == alteFarbe or (array[koordinaten.x][koordinaten.y].a8 == 0 and alteFarbe.a8 == 0)):
			array[koordinaten.x][koordinaten.y]= neueFarbe;
			if( koordinaten.x+1 <64):
				Punktstapel.push_front(Vector2(koordinaten.x+1,koordinaten.y));
			if(koordinaten.x-1>=0):
				Punktstapel.push_front(Vector2(koordinaten.x-1,koordinaten.y));
			if(koordinaten.y+1 < 64 ):
				Punktstapel.push_front(Vector2(koordinaten.x,koordinaten.y+1));
			if(koordinaten.y-1 >=0):
				Punktstapel.push_front(Vector2(koordinaten.x,koordinaten.y-1));


"""
Falls man eine Änderung an der Zeichenfläche vorgenommen hat und dann die 
Eingabe _vorschau: zeigt, was der Typ der Figur ist für die Vorschau
"""
func Figur_wechseln_bei_Aenderung(_vorschau):
	get_node("../CoinWechsel").show();
	alter_modus= modus;
	modus="Dialog";
	alte_vorschau= vorschau;
	vorschau = _vorschau;
	deaktiviere_buttons();
	popup_offen = true;


"""
Wird aufgerufen, wenn der Knopf BadCoin1 gedrückt wird
falls es eine Änderung gibt, wird ein Popup aufgerufen
sonst wird direkt gewechselt zur Figur schlechter Coin 1
"""
func _on_BadCoin1_pressed():
	coinWechsel= "BadCoin1";
	if bild.get_data() != original_bild.get_data():
		Figur_wechseln_bei_Aenderung("Coin");
	else:
		vorschau = "Coin";
		Coin_Wechsel();


"""
Wird aufgerufen, wenn der Knopf GoodCoin1 gedrückt wird
falls es eine Änderung gibt, wird ein Popup aufgerufen
sonst wird direkt gewechselt zur Figur guter Coin 1
"""
func _on_GoodCoin1_pressed():
	coinWechsel= "GoodCoin1";
	if bild.get_data() != original_bild.get_data():
		Figur_wechseln_bei_Aenderung("Coin");
	else:
		vorschau = "Coin";
		Coin_Wechsel();


"""
Prozedur, die aufgerufen wird, falls ein Knopf der unteren Leiste gedrückt wird
Damit wechselt sich die Spielfigur, deren Design gerade bearbeitet wird
@param name - Name der neu zu bearbeitenden Spielfigur
"""
func Coin_Wechsel():
	
	
	# aktiven Knopf auf nicht pressed setzen
	get_node("../"+aktiver_knopf).pressed = false;
	
	#neuen Knopf aktiv setzen
	aktiver_knopf= coinWechsel;
	
	#Einladen auf die Zeichenfläche
	einladen(coinWechsel);

	
	#Standardbutton setzen
	setze_Standardbutton();
	
	#Vorlagebuttonssetzen
	setze_Vorlagen();
	
	#vorschau setzen
	aktualisiere_vorschau();
	
	#rückgängigstapel löschen
	loesche_rueckgaengig_wiederholen();
	
	
	#neues Bild auf Rückgängigstapel
	Abbild_auf_Rueckgaengigstapel();
	
	#neues Originalbild
	original_bild= bild;


"""
lädt ein Bild aus den Dateien in die Variable bild ein und aktualisiert die Zeichenfläche
Eingabe pfad: gibt den Namen an für den Pfad wo sich das Bild befindet
"""	
func einladen(pfad):
	bild = Image.new();
	if vorschau=="Blob":
		bild = persistenz.lade_bild("Bilder/Standardspielfiguren/Spielfiguren/"+pfad+".png");
	elif vorschau =="Coin":
		bild = persistenz.lade_bild("res://Bilder/Standardspielfiguren/Coins/"+pfad+".png");	
	else:
		bild = persistenz.lade_bild("res://Bilder/Standardspielfiguren/Hintergrund/"+pfad+".png");
	setze_Zeichenflaeche();


"""
setzt die Textur der Zeichenfläche als Vergrößerung von der Variable bild
"""
func setze_Zeichenflaeche():
	# Kopie und Vergrößerung
	var bildkopie = Image.new();
	bildkopie.copy_from(bild);
	bildkopie.lock();
	bildkopie.resize(512,512,1);
	bildkopie.unlock();
	
	#Zuweisen der Textur
	textur.create_from_image(bildkopie,0);
	texture = textur;


"""
setzt die Textur der temporaeren Zeichenfläche als Vergrößerung von der Variablen temporaeresBild
"""
func setze_temporaere_Zeichenflaeche():
	# Kopie und Vergrößerung
	var bildkopie = Image.new();
	bildkopie.copy_from(temporaeresBild);
	bildkopie.lock();
	bildkopie.resize(512,512,1);
	bildkopie.unlock();
	var textur1 = ImageTexture.new();
	#Zuweisen der Textur
	textur1.create_from_image(bildkopie,0);
	#temporaereZeichenflaeche.
	temporaereZeichenflaeche.texture= textur1;


"""
lädt das Standardbild als Textur in den Button ein  #setze Button
"""
func setze_Standardbutton():
	var icon = Image.new();
	if vorschau =="Blob":
		icon = persistenz.lade_bild("Bilder/Standardspielfiguren/Spielfiguren/"+aktiver_knopf+"Standard.png");
	elif vorschau =="Coin":
		icon = persistenz.lade_bild("res://Bilder/Standardspielfiguren/Coins/"+aktiver_knopf+"Standard.png");
	else:
		icon = persistenz.lade_bild("res://Bilder/Standardspielfiguren/Hintergrund/"+aktiver_knopf+"Standard.png");
	var buttontextur = ImageTexture.new();
	buttontextur.create_from_image(icon);
	get_node("../Standard").icon= buttontextur;


"""
lädt die eigenen Designs und Vorlagen für die zu bearbeitende Spielfigur
als Vorschau in die jeweiligen Buttons
"""
func setze_Vorlagen():
	for i in range(1,6):
		var icon = Image.new();
		if vorschau == "Blob":
			icon = persistenz.lade_bild("res://Bilder/Standardspielfiguren/Spielfiguren/"+aktiver_knopf+"Design"+str(i)+".png");
		elif vorschau =="Coin":
			icon = persistenz.lade_bild("res://Bilder/Standardspielfiguren/Coins/"+aktiver_knopf+"Design"+str(i)+".png");
		else:
			icon = persistenz.lade_bild("res://Bilder/Standardspielfiguren/Hintergrund/"+aktiver_knopf+"Design"+str(i)+".png");	
		var buttontextur = ImageTexture.new();
		buttontextur.create_from_image(icon);
		get_node("../Vorlage"+str(i)).icon= buttontextur;


"""
aktualisiert das Vorschaubild an der linken Seite je nachdem, 
welche Spielfigur oder der Hintergrund gerade bearbeitet wird
"""
func aktualisiere_vorschau():
	var texturklein = ImageTexture.new();
	texturklein.create_from_image(bild,0);
	if vorschau == "Blob" or vorschau == "Coin":
		get_node("../"+vorschau).texture = texturklein;
	else:
		for i in range(0,9):
			get_node("../"+vorschau+str(i)).texture = texturklein;	


"""
Wenn das Bild für die aktuelle Figur übernommen werden soll, zeigt sich ein Popup
"""
func _on_Speichern_pressed():
	get_node("../UebernehmenBestaetigen").show();
	alter_modus= modus;
	modus="Dialog";
	deaktiviere_buttons();
	popup_offen = true;


"""
setzt die Zeichenfläche mit durchsichtigen Pixeln
"""
func _on_Leeren_pressed():
	bild.fill(Color(0,0,0,0));
	setze_Zeichenflaeche();
	wiederholenstapel=[];
	Abbild_auf_Rueckgaengigstapel();
	aktualisiere_vorschau();


"""
lade Vorlage 1 auf die Zeichenfläche, wenn der Knopf gedrückt wurde
"""
func _on_Vorlage1_pressed():
	#Vorlage einladen
	einladen(aktiver_knopf+"Design1");
	aktualisiere_vorschau();


"""
lade Vorlage 2 auf die Zeichenfläche, wenn der Knopf gedrückt wurde
"""
func _on_Vorlage2_pressed():
	#Vorlage einladen
	einladen(aktiver_knopf+"Design2");
	aktualisiere_vorschau();


"""
lade Vorlage 3 auf die Zeichenfläche, wenn der Knopf gedrückt wurde
"""
func _on_Vorlage3_pressed():
	#Vorlage einladen
	einladen(aktiver_knopf+"Design3");
	aktualisiere_vorschau();
	


"""
lade Vorlage 4 auf die Zeichenfläche, wenn der Knopf gedrückt wurde
"""
func _on_Vorlage4_pressed():
	#Vorlage einladen
	einladen(aktiver_knopf+"Design4");
	aktualisiere_vorschau();


"""
lade Vorlage 5 auf die Zeichenfläche, wenn der Knopf gedrückt wurde
"""
func _on_Vorlage5_pressed():
	#Vorlage einladen
	einladen(aktiver_knopf+"Design5");
	aktualisiere_vorschau();


"""
lade das Standardbild auf die Zeichenfläche, wenn der Knopf gedrückt wurde
"""
func _on_Standard_pressed():
	#Standard einladen
	einladen(aktiver_knopf+"Standard");
	aktualisiere_vorschau();


"""
Wird aufgerufen, wenn der Knopf BadCoin2 gedrückt wird
falls es eine Änderung gibt, wird ein Popup aufgerufen
sonst wird direkt gewechselt zur Figur schlechter Coin 2
"""
func _on_BadCoin2_pressed():
	coinWechsel= "BadCoin2";
	if bild.get_data() != original_bild.get_data():
		Figur_wechseln_bei_Aenderung("Coin");
	else:
		vorschau = "Coin";
		Coin_Wechsel();


"""
Wird aufgerufen, wenn der Knopf GoodCoin2 gedrückt wird
falls es eine Änderung gibt, wird ein Popup aufgerufen
sonst wird direkt gewechselt zur Figur guter Coin 2
"""
func _on_GoodCoin2_pressed():
	coinWechsel= "GoodCoin2";
	if bild.get_data() != original_bild.get_data():
		Figur_wechseln_bei_Aenderung("Coin");
	else:
		vorschau = "Coin";
		Coin_Wechsel();


"""
Wird aufgerufen, wenn der Knopf Random gedrückt wird
falls es eine Änderung gibt, wird ein Popup aufgerufen
sonst wird direkt gewechselt zur Figur Zufallscoin
"""
func _on_RandomCoin_pressed():
	coinWechsel= "RandomCoin";
	if bild.get_data() != original_bild.get_data():
		Figur_wechseln_bei_Aenderung("Coin");
	else:
		vorschau = "Coin";
		Coin_Wechsel();


"""
Wird aufgerufen, wenn der Knopf Blob_1_gerade gedrückt wird
falls es eine Änderung gibt, wird ein Popup aufgerufen
sonst wird direkt gewechselt zur Figur Blob mini
"""
func _on_Blob_1_gerade_pressed():
	coinWechsel= "Blob_1_gerade";
	if bild.get_data() != original_bild.get_data():
		Figur_wechseln_bei_Aenderung("Blob");
	else:
		vorschau = "Blob";
		Coin_Wechsel();


"""
Wird aufgerufen, wenn der Knopf Blob_3_gerade gedrückt wird
falls es eine Änderung gibt, wird ein Popup aufgerufen
sonst wird direkt gewechselt zur Figur Blob mittel
"""
func _on_Blob_3_gerade_pressed():
	coinWechsel= "Blob_3_gerade";
	if bild.get_data() != original_bild.get_data():
		Figur_wechseln_bei_Aenderung("Blob");
	else:
		vorschau = "Blob";
		Coin_Wechsel();


"""
Wird aufgerufen, wenn der Knopf Blob_2_gerade gedrückt wird
falls es eine Änderung gibt, wird ein Popup aufgerufen
sonst wird direkt gewechselt zur Figur Blob klein
"""
func _on_Blob_2_gerade_pressed():
	coinWechsel= "Blob_2_gerade";
	if bild.get_data() != original_bild.get_data():
		Figur_wechseln_bei_Aenderung("Blob");
	else:
		vorschau = "Blob";
		Coin_Wechsel();


"""
Wird aufgerufen, wenn der Knopf Blob_4_gerade gedrückt wird
falls es eine Änderung gibt, wird ein Popup aufgerufen
sonst wird direkt gewechselt zur Figur Blob groß
"""
func _on_Blob_4_gerade_pressed():
	coinWechsel= "Blob_4_gerade";
	if bild.get_data() != original_bild.get_data():
		Figur_wechseln_bei_Aenderung("Blob");
	else:
		vorschau = "Blob";
		Coin_Wechsel();


"""
Wird aufgerufen, wenn der Knopf Blob_5_gerade gedrückt wird
falls es eine Änderung gibt, wird ein Popup aufgerufen
sonst wird direkt gewechselt zur Figur Blob maxi
"""
func _on_Blob_5_gerade_pressed():
	coinWechsel= "Blob_5_gerade";
	if bild.get_data() != original_bild.get_data():
		Figur_wechseln_bei_Aenderung("Blob");
	else:
		vorschau = "Blob";
		Coin_Wechsel();


"""
Wird aufgerufen, wenn der Knopf Hintergrund gedrückt wird
falls es eine Änderung gibt, wird ein Popup aufgerufen
sonst wird direkt gewechselt zum Hintergrund
"""
func _on_Hintergrund_pressed():
	coinWechsel= "Hintergrund";
	if bild.get_data() != original_bild.get_data():
		Figur_wechseln_bei_Aenderung("Hintergrund");
	else:
		vorschau = "Hintergrund";
		Coin_Wechsel();


"""
Wird aufgerufen, wenn der Knopf Kanonenkugek gedrückt wird
falls es eine Änderung gibt, wird ein Popup aufgerufen
sonst wird direkt gewechselt zur Kanonenkugel
"""
func _on_Kanonenkugel_pressed():
	coinWechsel= "Kanonenkugel";
	if bild.get_data() != original_bild.get_data():
		Figur_wechseln_bei_Aenderung("Blob");
	else:
		vorschau = "Blob";
		Coin_Wechsel();


"""
Wenn das PopUp bestätigt wird, wird die Zeichenfläche endgültig gespeichert
"""
func _on_UebernehmenBestaetigen_confirmed():
	speichern(aktiver_knopf, aktiver_knopf);


"""
wenn der Rückgängigknopf gedrückt wird, wird die letzte Aktion rückgängig gemacht
"""
func _on_Rueckgaengig_pressed():
	mache_rueckgaengig();


"""
Die letzte ausgeführte Aktion wird nocheinmal wiederholt
"""
func mache_rueckgaengig():
	if rueckgaengigstapel.size() > 1:
		wiederholenstapel.push_back(rueckgaengigstapel.pop_back());
		bild.copy_from(rueckgaengigstapel.back());
		setze_Zeichenflaeche();
		aktualisiere_vorschau();


"""
wenn der Wiederholenknopf gedrückt wird, wird die letzte Aktion wiederholt
"""
func _on_Wiederholen_pressed():
	wiederhole();


"""
Die letze rückgängig gemachte Aktion wird noch einmal wiederholt
"""
func wiederhole():
	if wiederholenstapel.size() > 0:
		bild.copy_from(wiederholenstapel.back());
		rueckgaengigstapel.push_back(wiederholenstapel.pop_back());
		setze_Zeichenflaeche();
		aktualisiere_vorschau();


"""
Funktion, die die Größe des Inhalts einens Bildes ausrechnet ( da, wo das Bild nicht transparent ist)
Eingabe _bild: Image, von welchem die Größe bestimmt werden soll
Rückgabe: Vektor mit der x-Größe und der Y-Größe
"""
func groesse_Zeichnung(_bild):
	_bild.lock();
	maxy= null;
	minx = null;
	maxx= null;
	miny= null;
	for x in range (64):
		for y in range (64):
			if(_bild.get_pixel(x,y).a != 0):
				if minx == null or x < minx:
					minx = x;
				if miny == null or y< miny:
					miny = y;
				if maxx == null or x > maxx:
					maxx = x;
				if maxy == null or y > maxy:
					maxy = y;
	_bild.unlock();
	return [Vector2(minx,miny),Vector2(maxx,maxy)];


"""
verschiebt die Zeichnung in Y Richtung nach unten zum Bildrand,
damit die Spielfigur nicht mehr schwebt im Spiel
"""
func setze_an_unteren_Bildrand():
	groesse_Zeichnung(bild);
	var bildkopie = Image.new();
	bildkopie.copy_from(bild);
	bild.lock();
	bildkopie.lock();
	var verschiebung = 63-maxy;
	for x in range(63):
		for y in range(verschiebung):
			bild.set_pixel(x,y, Color(0,0,0,0));
	for x in range(63):
		for y in range(maxy+1):
			bild.set_pixel(x,y+verschiebung,bildkopie.get_pixel(x, y));
	bild.unlock();
	bildkopie.unlock();
	setze_Zeichenflaeche();
	aktualisiere_vorschau();
	wiederholenstapel=[];
	Abbild_auf_Rueckgaengigstapel();


"""
verschiebt den Inhalt der Zeichenfläche an den linken Rand
"""	
func setze_an_linken_Bildrand():
	groesse_Zeichnung(bild);
	var bildkopie = Image.new();
	bildkopie.copy_from(bild);
	bild.lock();
	bildkopie.lock();
	var verschiebung = minx;
	for y in range(64):
		for x in range(64):
			bild.set_pixel(x,y, Color(0,0,0,0));
	for y in range(64):
		for x in range(maxx-minx+1):
			bild.set_pixel(x,y,bildkopie.get_pixel(x+verschiebung, y));

	bild.unlock();
	bildkopie.unlock();
	setze_Zeichenflaeche();
	aktualisiere_vorschau();
	Abbild_auf_Rueckgaengigstapel();


"""
falls der Knopf an unteren Bildrand gedrückt wird, wird die Figur nach unten verschoben
"""
func _on_Bildrand_pressed():
	setze_an_linken_Bildrand();


"""
Methode, die augerufen wird, sobald sich etwas auf der Zeichenfläche ändert
macht ein aktuelles Abbild der Zeichenfläche auf den Rückgängigstapel
"""
func Abbild_auf_Rueckgaengigstapel():
	if rueckgaengigstapel.size()< 10:
		var bildkopie = Image.new();
		bildkopie.copy_from(bild);
		rueckgaengigstapel.push_back(bildkopie);
	else:
		rueckgaengigstapel.pop_front();
		var bildkopie = Image.new();
		bildkopie.copy_from(bild);
		rueckgaengigstapel.push_back(bildkopie);


"""
Bresenham Algorithmus, welcher mit einem Start und Endpunkt eine Linie zeichnet in jedem Oktant
Eingabe start: Koordinaten des Startpunkts
Eingabe ende: Koordinaten des Endpunkts
"""
func male_Linie(start,ende):
	
	start.x = floor(start.x/8);
	start.y = floor(start.y/8);
	ende.x = floor(ende.x/8);
	ende.y = floor(ende.y/8);
	
	var y1 = ende.y;
	var y0 = start.y
	
	var x1= ende.x;
	var x0 = start.x;
	
	var schnell;
	var langsam;
	var ziel;
	var xschnell;
	var Q;
	var Q_step;
	var Q_equal;
	var stepSchnell;
	var stepLangsam;
	
	
	
	#Setzen der Koordinaten-Variablen, die jeweils den aktuellen Punkt angeben
	var y = start.y;
	var x = start.x;
	
	#Setzen der Variablen, die angeben, ob x & y hoch- oder runtergezählt werden 
	var stepy = 1;
	var stepx = 1;
	
	#Setzen der Variablen, die Delta x und Delta y angeben
	var a = y1-y0;
	var b = -(x1-x0);

	
	#Wenn die Linie nach unten geht, muss y herunterzählen 
	#Ist für den 5. - 8. Oktanten notwendig
	if a < 0:
		a = -1 * a;
		stepy = -1 * stepy;	
	
	# Wenn die Linie nach links geht, muss x herunterzählen
	# Ist für den 3. - 6. Oktanten notwendig
	if b > 0:
		b = -1 * b;
		stepx = -1 * stepx;

	# Wenn die Linie weiter nach oben/unten als nach links/rechts geht(y schnelle Richtung), müssen x & y vertauscht werden
	#Ist für den 2., 3., 6. & 7. Oktanten notwendig
	if a > -b:
		#Berechnung von Q, Q_step & Q_equal mit vertauschten Werten für a & b und Negierung dieser
		Q = -(2*b+a);
		Q_step = -(2*(a+b));
		Q_equal = -(2*b);
		
		#Setzen der Variablen, die angeben, welche Koordinate konsant hochgeht und welche langsamer steigt
		schnell = y;
		langsam = x;
		
		#Angabe der Variablen, bis zu der hochgezählt werden muss
		ziel = y1;
		
		#Setzen der schnelleren und langsameren Schrittweite
		stepSchnell = stepy;
		stepLangsam = stepx;
		
		#Setzen der Variable, die angibt, ob x die schneller ansteigende Koordinate ist
		xschnell = false;
	
	else:
		#Berechnung von Q, Q_step & Q_equal 
		Q = 2*a+b;
		Q_step = 2*(a+b);
		Q_equal = 2*a;
		
		#Setzen der Variablen, die angeben, welche Koordinate konsant hochgeht und welche langsamer steigt
		schnell = x;
		langsam = y;
		
		#Angabe der Variablen, bis zu der hochgezählt werden muss
		ziel = x1;
		
		#Setzen der schnelleren und langsameren Schrittweite		
		stepSchnell = stepx;
		stepLangsam = stepy;
		
		#Setzen der Variable, die angibt, ob x die schneller ansteigende Koordinate ist
		xschnell = true;	
		
	temporaeresBild.lock();	
	#Durchlaufe die schnelle Variable bis sie ihren Endpunkt erreicht
	while schnell!=ziel: 
		#Male den aktuellen Pixel mit Überprüfung, welcher Wert schneller ansteigt. 
		if xschnell:
			temporaeresBild.set_pixel(schnell,langsam, aktuelle_farbe);
		else:
			temporaeresBild.set_pixel(langsam,schnell, aktuelle_farbe);
		#Wenn Q negativ ist, erhöhe Q um Q_equal
		if (Q<0):
			Q = Q + Q_equal;
		#Sonst erhöhe Q um Q_step und erhöhe die langsame Variable um seine Schrittweite
		else :
			Q = Q + Q_step;
			langsam+= stepLangsam;
		schnell+=stepSchnell
	temporaeresBild.set_pixel(x1,y1, aktuelle_farbe);
	temporaeresBild.unlock();
	setze_temporaere_Zeichenflaeche();


"""
speichert eine eigene Farbe persistent als Bild ab
Eingabe name: Name der eigenen Farbe
"""
func eigene_Farbe_speichern(name):
	var icon1 = Image.new();
	icon1.create(16, 16, false, Image.FORMAT_RGBA8);
	icon1.fill(aktuelle_farbe);
	icon1.lock();
	icon1.unlock();
	knopf_aktualisieren(name, icon1);
	#persistent Speichern
	persistenz.speicher_bild_als_textur(icon1, "res://Bilder/Farben/"+name+".png")


"""
wechselt zum Stift, falls der Radierer aktiv war und eine Farbe gedrückt wird
"""
func Farbwechsel_bei_Radierer():
	aktuellerModusbutton.pressed= false;
	aktuellerModusbutton = get_node("../Stift");
	aktuellerModusbutton.pressed= true;
	modus = "Stift";


"""
wenn die eigene Farbe 1 gedrückt wird, wird zu dieser gewechselt
"""
func _on_EigeneFarbe1_pressed():
	eigeneFarbeaktuell = 1;
	wechsel_zu_eigene_Farbe();


"""
wenn ein Farbbutton gedrückt wird, wo man die Farbe selber einstellen kann
beim 1.Mal öffnet sich der Colorpicker
danach wird die dort gespeicherte Farbe ausgewählt
"""
func wechsel_zu_eigene_Farbe():
	if aktuellerFarbbutton != get_node("../EigeneFarbe"+str(eigeneFarbeaktuell)):
		aktuellerFarbbutton.pressed= false;
		aktuellerFarbbutton= get_node("../EigeneFarbe"+str(eigeneFarbeaktuell));
	else:
		aktuellerFarbbutton.pressed= true;
	if eigeneFarbe[eigeneFarbeaktuell-1] == Color(0,0,0,0):
		get_node("../Farbwahl/Zurueck").hide();
		oeffne_Farbauswahl();
		
	else:
		get_node("../Farbwahl/Zurueck").show();
		get_node("../Farbauswahl").show();
		get_node("../Farbwahl").color= eigeneFarbe[eigeneFarbeaktuell-1];
		aktuelle_farbe = eigeneFarbe[eigeneFarbeaktuell-1];
		if modus =="Radierer":
			Farbwechsel_bei_Radierer();


"""
öffnet den Colorpicker
"""
func oeffne_Farbauswahl():
	get_node("../Farbwahl").show();
	get_tree().call_group("Steuerelemente", "hide");
	alter_modus = modus;
	modus="Farbauswahl";
	deaktiviere_buttons();


"""
wenn die eigene Farbe 2 gedrückt wird, wird zu dieser gewechselt
"""
func _on_EigeneFarbe2_pressed():
	eigeneFarbeaktuell = 2;
	wechsel_zu_eigene_Farbe();


"""
wenn die eigene Farbe 3 gedrückt wird, wird zu dieser gewechselt
"""
func _on_EigeneFarbe3_pressed():
	eigeneFarbeaktuell = 3;
	wechsel_zu_eigene_Farbe();


"""
wenn die eigene Farbe 4 gedrückt wird, wird zu dieser gewechselt
"""
func _on_EigeneFarbe4_pressed():
	eigeneFarbeaktuell = 4;
	wechsel_zu_eigene_Farbe();


"""
wenn die eigene Farbe 5 gedrückt wird, wird zu dieser gewechselt
"""
func _on_EigeneFarbe5_pressed():
	eigeneFarbeaktuell = 5;
	wechsel_zu_eigene_Farbe();


"""
lädt die eigenen Farben aus dem Speicher in ein Array ein
"""
func eigene_Farben_einladen():
	for i in range(1,6):
		var icon = Image.new();
		icon = persistenz.lade_bild("res://Bilder/Farben/EigeneFarbe"+str(i)+".png");
		icon.lock();
		eigeneFarbe[i-1]= icon.get_pixel(0,0);
		icon.unlock();


"""
malt ein Rechteck auf die temporäre Zeichenfläche
Eingabe start: Starteckwerte
Eingabe ende: Endeckwerte
"""
func male_Rechteck(start, ende):
	start.x = floor(start.x/8);
	start.y = floor(start.y/8);
	ende.x = floor(ende.x/8);
	ende.y = floor(ende.y/8);
	if start.x> ende.x:
		var zwischen;
		zwischen = start.x;
		start.x = ende.x;
		ende.x = zwischen;
	if start.y> ende.y:
		var zwischen;
		zwischen = start.y;
		start.y = ende.y;
		ende.y = zwischen;
	temporaeresBild.lock();
	for i in range (0, abs(start.x-ende.x)):
		temporaeresBild.set_pixel(start.x+i, start.y, aktuelle_farbe);
	for i in range (0, abs(start.x-ende.x)):
		temporaeresBild.set_pixel(start.x+i, ende.y, aktuelle_farbe);
	for i in range (0, abs(start.y-ende.y)):
		temporaeresBild.set_pixel(start.x, start.y+i, aktuelle_farbe);
	for i in range (0, abs(start.y-ende.y)+1):
		temporaeresBild.set_pixel(ende.x, start.y+i, aktuelle_farbe);
	temporaeresBild.unlock();
	
	setze_temporaere_Zeichenflaeche();


"""
wenn der Knopf Rechteck gedrückt wird, wird der Modus auf Rechteck umgestellt
"""
func _on_Rechteck_pressed():
	modus="Rechteck";
	linien_ende = null;
	linien_start= null;
	aktuellerModusbutton.pressed= false;
	aktuellerModusbutton = get_node("../Rechteck");


"""
kopiert die temporäre Zeichenfläche in die richtige
"""
func uebernehme_temporaere_Zeichenflaeche():
	
	#temporäre Zeichenfläche in richtiges Bild kopieren
	bild.lock();
	temporaeresBild.lock();
	for x in range (64):
		for y in range (64):
			if(temporaeresBild.get_pixel(x,y) != Color(0,0,0,0)):
				bild.set_pixel(x,y,temporaeresBild.get_pixel(x,y));
	bild.unlock();
	temporaeresBild.unlock();
	#Bild neu auf Zeichenfläche laden
	setze_Zeichenflaeche();
	aktualisiere_vorschau();
	#temporäre Zeichenfläche löschen
	leere_temporaere_Zeichenflaeche();
	setze_temporaere_Zeichenflaeche();


"""
leert die temporäre Zeichenfläche
"""
func leere_temporaere_Zeichenflaeche():
	temporaeresBild.fill(Color(0,0,0,0));


"""
wechselt zu einer anderen Figur, weil das Popup bestätigt wurde
"""
func _on_Ja_pressed():
	Coin_Wechsel();
	get_node("../CoinWechsel").hide();
	aktiviere_buttons();
	popup_offen = false;


"""
wechselt nicht zu einer anderen Figur, weil das Popup nicht bestätigt wurde
"""
func _on_Nein_pressed():
	vorschau = alte_vorschau;
	get_node("../CoinWechsel").hide();
	get_node("../"+aktiver_knopf).pressed= true;
	get_node("../"+coinWechsel).pressed= false;
	aktiviere_buttons();
	popup_offen = false;


"""
Funktion, die alle Buttons der Malenszene deaktiviert
"""
func deaktiviere_buttons():
	var Kinder = get_parent().get_children();
	for Kind in Kinder:
		if Kind is Button:
			Kind.disabled = true;


"""
Funktion, die alle Buttons der Malenszene aktiviert
"""
func aktiviere_buttons():
	var Kinder = get_parent().get_children();
	for Kind in Kinder:
		if Kind is Button:
			Kind.disabled = false;


"""
Algorithmus, der Pixel für Pixel eine Viertel Ellipse abgeht und deren Punkte ausrechnet
Eingabe cx: Mittelpunkt x-Koordinate
Eingabe cy: Mittelpunkt y-Koordinate
Eingabe radiusx: Radius x-Richtung
EIngabe radiusy: Radius y-Richtung
siehe Quellen
"""
func male_Ellipse(cx,cy, radiusx, radiusy):
	var zweiAQuadrat = 2* radiusx*radiusx;
	var zweiBQuadrat= 2* radiusy*radiusy;
	var x = radiusx;
	var y = 0;
	var xwechsel = radiusy*radiusy*(1-2*radiusx);
	var ywechsel = radiusx*radiusx;
	var ellipsenfehler= 0;
	var stopX = zweiBQuadrat*radiusx; 
	var stopY = 0;
	temporaeresBild.lock();
	
	
	while stopX> stopY or (stopX== stopY and stopX != 0):
		male_vier_Ellipsenpunkte(x,y, cx,cy);
		y= y+1;
		stopY = stopY +zweiAQuadrat;
		ellipsenfehler = ellipsenfehler + ywechsel;
		ywechsel = ywechsel + zweiAQuadrat;
		if 2* ellipsenfehler+ xwechsel > 0:
			x= x-1;
			stopX = stopX -zweiBQuadrat;
			ellipsenfehler = ellipsenfehler + xwechsel;
			xwechsel = xwechsel + zweiBQuadrat;
	x= 0;
	y= radiusy;
	xwechsel = radiusy*radiusy;
	ywechsel= radiusx*radiusx*(1-2*radiusy);
	ellipsenfehler= 0;
	stopX= 0;
	stopY= zweiAQuadrat* radiusy;
	while stopX < stopY or (stopX== stopY and stopY != 0):
		male_vier_Ellipsenpunkte(x,y, cx,cy);
		x= x+1;
		stopX= stopX +zweiBQuadrat;
		ellipsenfehler= ellipsenfehler+ xwechsel;
		xwechsel= xwechsel+ zweiBQuadrat;
		if 2* ellipsenfehler+ ywechsel >0:
			y= y-1;
			stopY= stopY -zweiAQuadrat;
			ellipsenfehler= ellipsenfehler+ ywechsel;
			ywechsel = ywechsel +zweiAQuadrat;
	temporaeresBild.unlock();
	setze_temporaere_Zeichenflaeche();


"""
Hilfsfunktion, welche auf jedem Quadrant einen Punkt einer Ellipse malt
Eingabe cx: Mittelpunkt x-Koordinate
Eingabe cy: Mittelpunkt y-Koordinate
Eingabe x: x-Koordinate
Eingabe y: y-Koordinate
"""
func male_vier_Ellipsenpunkte(x,y, cx,cy):

	var  amRand1 = cx+x >63;
	var  amRand2 = cx-x <0;
	var  amRand3 = cy+y >63;
	var  amRand4 = cy-y <0;
	
	
	if( amRand1 != true and amRand3 != true):
		temporaeresBild.set_pixel(cx+x,cy+y,aktuelle_farbe);
	if( amRand2 != true and amRand3 != true):
		temporaeresBild.set_pixel(cx-x,cy+y,aktuelle_farbe);
	if( amRand2 != true and amRand4 != true):
		temporaeresBild.set_pixel(cx-x,cy-y,aktuelle_farbe);
	if( amRand1 != true and amRand4 != true):
		temporaeresBild.set_pixel(cx+x,cy-y,aktuelle_farbe);


"""
wenn das Ellipsentool ausgewählt wird, wird der Modus auf Ellipse gestellt
"""
func _on_Ellipse_pressed():
	modus="Ellipse";
	aktuellerModusbutton.pressed= false;
	aktuellerModusbutton = get_node("../Ellipse");


"""
lädt auf die Knöpfe die richtigen aktuell ausgewählten Bilder und ermittelt teilweise deren Größe
"""
func lade_Knopfbilder():
	var bildtemporaer = Image.new();
	
	#Blobs
	bildtemporaer = persistenz.lade_bild("Bilder/Standardspielfiguren/Spielfiguren/"+"Blob_1_gerade.png");
	groesseFigur["Blob_1_gerade"] = groesse_Zeichnung(bildtemporaer);
	knopf_aktualisieren("Blob_1_gerade",bildtemporaer);	
	
	bildtemporaer = persistenz.lade_bild("Bilder/Standardspielfiguren/Spielfiguren/"+"Blob_2_gerade.png");
	knopf_aktualisieren("Blob_2_gerade",bildtemporaer);	
	groesseFigur["Blob_2_gerade"] = groesse_Zeichnung(bildtemporaer);
	
	bildtemporaer = persistenz.lade_bild("Bilder/Standardspielfiguren/Spielfiguren/"+"Blob_3_gerade.png");
	knopf_aktualisieren("Blob_3_gerade",bildtemporaer);	
	groesseFigur["Blob_3_gerade"] = groesse_Zeichnung(bildtemporaer);
	
	bildtemporaer = persistenz.lade_bild("Bilder/Standardspielfiguren/Spielfiguren/"+"Blob_4_gerade.png");
	knopf_aktualisieren("Blob_4_gerade",bildtemporaer);	
	groesseFigur["Blob_4_gerade"] = groesse_Zeichnung(bildtemporaer);
	
	bildtemporaer = persistenz.lade_bild("Bilder/Standardspielfiguren/Spielfiguren/"+"Blob_5_gerade.png");
	knopf_aktualisieren("Blob_5_gerade",bildtemporaer);	
	groesseFigur["Blob_5_gerade"] = groesse_Zeichnung(bildtemporaer);
	
	bildtemporaer = persistenz.lade_bild("Bilder/Standardspielfiguren/Spielfiguren/"+"Kanonenkugel.png");
	knopf_aktualisieren("Kanonenkugel",bildtemporaer);	
	groesseFigur["Kanonenkugel"] = groesse_Zeichnung(bildtemporaer);
	
	#Coins
	bildtemporaer = persistenz.lade_bild("Bilder/Standardspielfiguren/Coins/"+"GoodCoin1.png");
	knopf_aktualisieren("GoodCoin1",bildtemporaer);
	groesseFigur["GoodCoin1"] = groesse_Zeichnung(bildtemporaer);
	
	bildtemporaer = persistenz.lade_bild("Bilder/Standardspielfiguren/Coins/"+"GoodCoin2.png");
	knopf_aktualisieren("GoodCoin2",bildtemporaer);	
	groesseFigur["GoodCoin2"] = groesse_Zeichnung(bildtemporaer);
	
	bildtemporaer = persistenz.lade_bild("Bilder/Standardspielfiguren/Coins/"+"BadCoin1.png");
	knopf_aktualisieren("BadCoin1",bildtemporaer);	
	groesseFigur["BadCoin1"] = groesse_Zeichnung(bildtemporaer);
	
	bildtemporaer = persistenz.lade_bild("Bilder/Standardspielfiguren/Coins/"+"BadCoin2.png");
	knopf_aktualisieren("BadCoin2",bildtemporaer);	
	groesseFigur["BadCoin2"] = groesse_Zeichnung(bildtemporaer);
	
	bildtemporaer = persistenz.lade_bild("Bilder/Standardspielfiguren/Coins/"+"RandomCoin.png");
	knopf_aktualisieren("RandomCoin",bildtemporaer);
	groesseFigur["RandomCoin"] = groesse_Zeichnung(bildtemporaer);
	
	# Figruengroesse speichern.
	persistenz.schreibe_variable_in_datei("figurengroesse", groesseFigur, "res://Skripte/Spielverwaltung/Informationsübertragung.gd")
	
	#Hintergrund	
	bildtemporaer = persistenz.lade_bild("Bilder/Standardspielfiguren/Hintergrund/"+"Hintergrund.png");
	knopf_aktualisieren("Hintergrund",bildtemporaer);
	
	#eigene Farben
	bildtemporaer = persistenz.lade_bild("Bilder/Farben/EigeneFarbe1.png");
	knopf_aktualisieren("EigeneFarbe1",bildtemporaer);
	bildtemporaer = persistenz.lade_bild("Bilder/Farben/EigeneFarbe2.png");
	knopf_aktualisieren("EigeneFarbe2",bildtemporaer);
	bildtemporaer = persistenz.lade_bild("Bilder/Farben/EigeneFarbe3.png");
	knopf_aktualisieren("EigeneFarbe3",bildtemporaer);
	bildtemporaer = persistenz.lade_bild("Bilder/Farben/EigeneFarbe4.png");
	knopf_aktualisieren("EigeneFarbe4",bildtemporaer);
	bildtemporaer = persistenz.lade_bild("Bilder/Farben/EigeneFarbe5.png");
	knopf_aktualisieren("EigeneFarbe5",bildtemporaer);

"""
wenn der Knopf übernehmen gedrückt wird, wird der Colorpicker geschlossen und die 
ausgewählte Farbe gespeichert ins Array und als Bild, welches der Knopf als Textur bekommt
"""
func _on_Uebernehmen_pressed():
	eigeneFarbe[eigeneFarbeaktuell-1]= get_node("../Farbwahl").get_pick_color();
	aktuelle_farbe= eigeneFarbe[eigeneFarbeaktuell-1];
	eigene_Farbe_speichern("EigeneFarbe"+str(eigeneFarbeaktuell));
	get_node("../Farbwahl").hide();


"""
wenn der Colorpicker geschlossen wird, muss wieder alles aktiviert werden
"""
func _on_ColorPicker_hide():
	get_tree().call_group("Steuerelemente", "show");
	aktiviere_buttons();
	if alter_modus =="Radierer":
		Farbwechsel_bei_Radierer();
	else:
		modus = alter_modus;


"""
Wenn der Farbwahl-Button gedrückt wird, wird der Colorpicker geöffnet
"""	
func _on_Farbauswahl_pressed():
	get_node("../Farbwahl/Zurueck").show();
	oeffne_Farbauswahl();


"""
Wenn zurück gedrückt wird, wird der Colorpicker geschlossen
"""
func _on_Zurueck_pressed():
	get_node("../Farbwahl").hide();


"""
löscht den Rückgängig- und Wiederholenstapel
"""
func loesche_rueckgaengig_wiederholen():
	rueckgaengigstapel = [];
	wiederholenstapel = [];


"""
wenn die die Zeichenfläche endgültig als Vorlage
gespeichert werden soll, dann wird diese als Bild persistiert
"""
func _on_VorlageBestaetigen_confirmed():
	speichern(aktiver_knopf+"Design"+str(vorlage), "Vorlage"+str(vorlage));

"""
öffnet ein Popup um zu bestätigen, dass die Vorlage überschrieben werden soll
"""
func _on_Design1_pressed():
	oeffne_popup();
	get_node("../VorlageBestaetigen").show();
	vorlage = 1;


"""
öffnet ein Popup um zu bestätigen, dass die Vorlage überschrieben werden soll
"""
func _on_Design2_pressed():
	oeffne_popup();
	get_node("../VorlageBestaetigen").show();
	vorlage = 2;


"""
öffnet ein Popup um zu bestätigen, dass die Vorlage überschrieben werden soll
"""
func _on_Design3_pressed():
	oeffne_popup();
	get_node("../VorlageBestaetigen").show();
	vorlage = 3;


"""
öffnet ein Popup um zu bestätigen, dass die Vorlage überschrieben werden soll
"""
func _on_Design4_pressed():
	oeffne_popup();
	get_node("../VorlageBestaetigen").show();
	vorlage = 4;


"""
öffnet ein Popup um zu bestätigen, dass die Vorlage überschrieben werden soll
"""
func _on_Design5_pressed():
	oeffne_popup();
	get_node("../VorlageBestaetigen").show();
	vorlage = 5;


"""
wenn ein Popup geöffnet wird, wird der Modus auf Dialog gestellt und der alte gespeichert
zusätzlich werden alle Buttons deaktiviert
"""
func oeffne_popup():
	alter_modus = modus;
	modus = "Dialog";
	deaktiviere_buttons();
	popup_offen= true;


"""
wenn das PopUp für Übernehmen geschlossen wird, werden wieder
alle Buttons aktiviert
"""
func _on_UebernehmenBestaetigen_hide():
	aktiviere_buttons();
	popup_offen = false;


"""
wenn das PopUp für die Vorlagen geschlossen wird, werden wieder
alle Buttons aktiviert
"""
func _on_VorlageBestaetigen_hide():
	aktiviere_buttons();
	popup_offen = false;


"""
Ruft die Export/Import Szene auf.
"""
func _on_Exportieren_Importieren():
	OS.set_window_size(Vector2(448,640))
	get_tree().change_scene("res://Szenen/Spielverwaltung/Nutzerdateien.tscn")
