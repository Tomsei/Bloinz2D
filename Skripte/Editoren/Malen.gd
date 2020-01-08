extends Sprite


var bildgroesse;
var aktuelleFarbe;
var modus;
var linienStart;
var linienEnde;
var stiftgroesse;
#sich auf der Zeichenfläche befindende Bild
var bild;
var alterInhalt
var textur;
var array;
var aktiverKnopf;
var alterModus;
var Vorschau;
var aktuellerFarbbutton;
var aktuellerStiftbutton;
var aktuellerModusbutton;
var Colorpickerb;
var rueckgaengigstapel;
var wiederholenstapel;
var minx;
var maxx;
var miny;
var maxy;
var eigeneFarbe;
var temporaeresBild;
var temporaereZeichenflaeche;
var coinWechsel;
var alteVorschau;






# Called when the node enters the scene tree for the first time.
func _ready():
	# Setze Bildschirmgroesse.
	OS.set_window_size(Vector2(900,660));
	
	#Farbe voreinstellen
	aktuellerFarbbutton= get_node("../Farbe9");
	aktuellerFarbbutton.pressed= true;
	aktuelleFarbe = Color(1,1,1,1);
	get_node("../ColorPickerButton").color = Color(1,1,1,1);
	
	#Stiftgroesse voreinstellen
	modus = "Stift";
	stiftgroesse = 1;
	aktuellerStiftbutton = get_node("../klein");
	aktuellerStiftbutton.pressed= true;
	aktuellerModusbutton = get_node("../Stift");
	aktuellerModusbutton.pressed= true;
	
	#64*64 groesses Bild was gespeichert wird
	bildgroesse = 64;
	bild = Image.new();
	bild.create(bildgroesse, bildgroesse, false, Image.FORMAT_RGBA8);
	textur = ImageTexture.new();
	aktiverKnopf=" ";

	temporaeresBild= Image.new();
	temporaeresBild.create(bildgroesse, bildgroesse, false, Image.FORMAT_RGBA8);
	temporaereZeichenflaeche=get_node("../temporaereZeichenflaeche");
	
	#Anfangsknopf auf ersten Blob setzen
	aktiverKnopf= "Blob_1_gerade";
	get_node("../Blob_1_gerade").pressed = true;
	Vorschau="Blob"
	
	einladen(aktiverKnopf);
	#Standardbutton setzen
	setze_Standardbutton();
	#Vorlagebuttonssetzen
	setze_Vorlagen();
	#Vorschau aktualisieren
	aktualisiere_Vorschau();

	#Bei neuladen es Maleneditors:
	#setze alle Figurauswahlbuttons auf das neue aktuelle Design
	setze_Figurauswahlbuttons();
	
	#Colorpickerbutton ist zu
	Colorpickerb = false;
	
	rueckgaengigstapel= [];
	Abbild_auf_Rueckgaengigstapel();
	print(rueckgaengigstapel);

	
	wiederholenstapel=[];
	
	#eigene Farben einladen
	eigeneFarbe=[];
	eigeneFarbe.resize(5);
	eigene_Farben_einladen();
	
	#

	




func create_2d_array(width, height, value):
    var a = []

    for y in range(height):
        a.append([])
        a[y].resize(width)

        for x in range(width):
            a[y][x] = value

    return a


func Knoepfe_zuruecksetzen():
	pass

""" 
malt einen Punkt auf das 64 * 64 große Bild
dabei wird darauf geachtet, dass ...
Eingabe x: x-Wert vom Pixel unten links
Eingabe y: y-Wert vom Pixel unten links 
"""	
func punkt_malen_pixel(x,y):
	var xneu = floor(x/8);
	var yneu = floor(y/8);
	bild.lock();
	for i in range(0, stiftgroesse):
		for j in range(0, stiftgroesse):
			bild.set_pixel(xneu+i, yneu+j, aktuelleFarbe);
	bild.unlock();



func punkt_loeschen_pixel(x, y):
	var xneu = floor(x/8);
	var yneu = floor(y/8);
	bild.lock();
	for i in range(0, stiftgroesse):
		for j in range(0, stiftgroesse):
			bild.set_pixel(xneu+i, yneu+j, Color(0,0,0,0));
	bild.unlock();
	textur = ImageTexture.new();
	textur.create_from_image(bild);
	texture= textur;

func befuellen():
	bild.lock();
	for x in range(64):
		for y in range(64):
			array[x][y] = bild.get_pixel(x,y);
	bild.unlock();

"""
Methode, die bei jedem neuen Time_Frame aufgerufen wird
"""
func _process(delta):
		if Input.is_action_just_pressed("draw"):
			var mouseposition = get_global_mouse_position();
			if mouseposition.x >= 256 and mouseposition.y <= 512 and mouseposition.x < 767:
				if modus =="Fuellen":
					array = create_2d_array(64,64,Color(0,0,0,0));
					befuellen();
					fuellen2(aktuelleFarbe,((mouseposition.x-256)/8),(mouseposition.y/8), array[(mouseposition.x-256)/8][mouseposition.y/8]);
					bild.lock();
					for zeile in range(64):
						for spalte in range(64):
							bild.set_pixel(zeile, spalte,array[zeile][spalte]);
					bild.unlock();
					setze_Zeichenflaeche();
					aktualisiere_Vorschau();
		elif Input.is_action_pressed("draw"):
			var mouseposition = get_global_mouse_position();
			if mouseposition.x >= 256 and mouseposition.y <= 512 and mouseposition.x < 767:
				if modus=="Stift":
					punkt_malen_pixel((mouseposition.x-256),mouseposition.y);
					aktualisiere_Vorschau();
					setze_Zeichenflaeche();
				elif modus == "Radierer":
					punkt_loeschen_pixel((mouseposition.x-256),mouseposition.y);
					aktualisiere_Vorschau();
					setze_Zeichenflaeche();
				elif modus == "Rechteck":
					if linienStart == null:
						linienStart = get_global_mouse_position();
						linienStart.x = linienStart.x-256;
					else:
						linienEnde = get_global_mouse_position();
						linienEnde.x = linienEnde.x-256;
						leere_temporaere_Zeichenflaeche();
						male_Rechteck(linienStart,linienEnde);
				elif modus == "Linie":
					if linienStart == null:
						linienStart = get_global_mouse_position();
						linienStart.x = linienStart.x-256;
						#punkt_malen_pixel(linienStart.x, linienStart.y);
						#setze_Zeichenflaeche();
					else:
						linienEnde = get_global_mouse_position();
						linienEnde.x = linienEnde.x-256;
						leere_temporaere_Zeichenflaeche();
						male_Linie(linienStart,linienEnde);
						#linienStart = null;
						#linienEnde = null;
				elif modus == "Ellipse":
					if linienStart == null:
						linienStart = get_global_mouse_position();
						linienStart.x = linienStart.x-256;
						#punkt_malen_pixel(linienStart.x, linienStart.y);
						#setze_Zeichenflaeche();
					else:
						linienEnde = get_global_mouse_position();
						linienEnde.x = linienEnde.x-256;
						leere_temporaere_Zeichenflaeche();
						var radiusx =abs(linienEnde.x-linienStart.x);
						var radiusy= abs(linienEnde.y-linienStart.y);
						var cx;
						var cy;
						if linienEnde.x > linienStart.x:
							cx= linienStart.x+1/2*radiusx  ;
						else:
							cx= linienEnde.x+1/2*radiusx  ;
						if linienEnde.y > linienStart.y:
							cy= linienStart.y+1/2*radiusy  ;
						else:
							cy= linienEnde.y+1/2*radiusy;
						male_Ellipse(cx,cy,radiusx,radiusy);
						#linienStart = null;
						#linienEnde = null;
		elif Input.is_action_just_released("draw"):
			var mouseposition = get_global_mouse_position();
			if mouseposition.x >= 256 and mouseposition.y <= 512:
				wiederholenstapel = [];
				Abbild_auf_Rueckgaengigstapel();
				#noch Methode?
				if modus=="Rechteck":
					linienStart= null;
					linienEnde = null;
					uebernehme_temporaere_Zeichenflaeche();
				elif modus=="Linie":
					linienStart= null;
					linienEnde = null;
					uebernehme_temporaere_Zeichenflaeche();
		elif Input.is_action_just_pressed("undo"):
			mache_rueckgaengig();
		elif Input.is_action_just_pressed("redo"):
			wiederhole();

"""
speichert die Zeichenfläche als png
"""
func speichern(bildname, Knopf):

	#Bild in den Dateien speichern
	if Vorschau=="Blob":
		bild.save_png("Bilder/Standardspielfiguren/Spielfiguren/"+bildname+".png");
		#temporaeresBild.load("Bilder/Standardspielfiguren/Spielfiguren/"+pfad+".png");
	elif Vorschau =="Coin":
		bild.save_png("Bilder/Standardspielfiguren/Coins/"+bildname+".png");	
	else:
		for i in range(0,8):
			#malenordner
			bild.save_png("Bilder/Hintergruende/HimmelVerlauf"+str(i)+".png");
	
	#Knopf aktualisieren
	knopf_aktualisieren(Knopf, bild);

"""
aktualisiert das Icon eines Knopfes mit der Zeichenfläche
@param Name - Name des Knopfes der aktualisiert werden soll
"""
func knopf_aktualisieren(Name, _bild):
	#Knopf mit aktualisiertem Bild
	var Pfad = "../"+ Name;
	get_node(Pfad).icon= mache_Buttontextur(_bild);

func mache_Buttontextur(_bild):
	var buttontextur = ImageTexture.new()
	buttontextur.create_from_image(_bild);
	return buttontextur;
"""
"""

func _on_ColorPickerButton_popup_closed():
	aktuellerFarbbutton.pressed= false;
	aktuellerFarbbutton= get_node("../ColorPickerButton");
	aktuelleFarbe = get_node("../ColorPickerButton").color;
	modus="";



func _on_Stift_pressed():
	modus = "Stift";
	aktuellerModusbutton.pressed= false;
	aktuellerModusbutton = get_node("../Stift");



func _on_Linie_pressed():
	aktuellerModusbutton.pressed= false;
	aktuellerModusbutton = get_node("../Linie");
	modus = "Linie";


func _on_Radierer_pressed():
	aktuellerModusbutton.pressed= false;
	aktuellerModusbutton = get_node("../Radierer");
	modus = "Radierer";


"""
TODO
"""
func _on_Spiegeln_pressed():
	
	var hilfe;
	bild.lock();
	bild.flip_x();
	bild.unlock();
	setze_Zeichenflaeche();
	Abbild_auf_Rueckgaengigstapel();


func _on_Farbe1_pressed():
	aktuellerFarbbutton.pressed= false;
	aktuellerFarbbutton= get_node("../Farbe1");
	aktuelleFarbe = Color(0.9,0.23,0.1);
	if modus =="Radierer":
		Farbwechsel_bei_Radierer();



func _on_Farbe2_pressed():
	aktuellerFarbbutton.pressed= false;
	aktuellerFarbbutton= get_node("../Farbe2");
	aktuelleFarbe = Color(0.9,0.72,0.1);
	if modus =="Radierer":
		Farbwechsel_bei_Radierer();



func _on_Farbe3_pressed():
	aktuellerFarbbutton.pressed= false;
	aktuellerFarbbutton= get_node("../Farbe3");
	aktuelleFarbe = Color(0.46,0.9,0.1);
	if modus =="Radierer":
		Farbwechsel_bei_Radierer();



func _on_Farbe4_pressed():
	aktuellerFarbbutton.pressed= false;
	aktuellerFarbbutton= get_node("../Farbe4");
	aktuelleFarbe = Color(0.1,0.9,0.81);
	if modus =="Radierer":
		Farbwechsel_bei_Radierer();



func _on_Farbe5_pressed():
	aktuellerFarbbutton.pressed= false;
	aktuellerFarbbutton= get_node("../Farbe5");
	aktuelleFarbe = Color(0.1,0.36,0.9);
	if modus =="Radierer":
		Farbwechsel_bei_Radierer();



func _on_Farbe6_pressed():
	aktuellerFarbbutton.pressed= false;
	aktuellerFarbbutton= get_node("../Farbe6");
	aktuelleFarbe = Color(0.63,0.1,0.9);
	if modus =="Radierer":
		Farbwechsel_bei_Radierer();



func _on_Farbe7_pressed():
	aktuellerFarbbutton.pressed= false;
	aktuellerFarbbutton= get_node("../Farbe7");
	aktuelleFarbe = Color(0.9,0.1,0.78);
	if modus =="Radierer":
		Farbwechsel_bei_Radierer();



func _on_Farbe8_pressed():
	aktuellerFarbbutton.pressed= false;
	aktuellerFarbbutton= get_node("../Farbe8");
	aktuelleFarbe = Color(0.95,0.78,0.59);
	if modus =="Radierer":
		Farbwechsel_bei_Radierer();



func _on_Farbe9_pressed():
	
	aktuellerFarbbutton.pressed= false;
	aktuellerFarbbutton= get_node("../Farbe9");
	aktuelleFarbe = Color(1,1,1);
	if modus =="Radierer":
		Farbwechsel_bei_Radierer();



func _on_Farbe10_pressed():
	aktuellerFarbbutton.pressed= false;
	aktuellerFarbbutton= get_node("../Farbe10");
	aktuelleFarbe = Color(0,0,0);
	if modus =="Radierer":
		Farbwechsel_bei_Radierer();




func _on_klein_pressed():
		
	aktuellerStiftbutton.pressed= false;
	aktuellerStiftbutton = get_node("../klein");
	stiftgroesse= 1;


func _on_mittel_pressed():
	aktuellerStiftbutton.pressed= false;
	aktuellerStiftbutton = get_node("../mittel");
	stiftgroesse= 2;


func _on_gro_pressed():
	aktuellerStiftbutton.pressed= false;
	aktuellerStiftbutton = get_node("../gross");
	stiftgroesse= 3;


func _on_Zurueck_button_up():
	get_tree().change_scene("res://Szenen/Oberflaeche/Spieloberflaeche.tscn")
	OS.set_window_size(Vector2(448,640))


func _on_Fuellen_pressed():
	modus="Fuellen";
	aktuellerModusbutton.pressed= false;
	aktuellerModusbutton = get_node("../Fuellen");




func fuellen2(neueFarbe,x,y, alteFarbe):
	var Punktstapel;
	Punktstapel=[];
	Punktstapel.push_front(Vector2(x,y));
	while(!Punktstapel.empty()):
		var koordinaten = Punktstapel.pop_front();
		if(array[koordinaten.x][koordinaten.y] == alteFarbe):
			array[koordinaten.x][koordinaten.y]= neueFarbe;
			if( koordinaten.x+1 <64):
				Punktstapel.push_front(Vector2(koordinaten.x+1,koordinaten.y));
			if(koordinaten.x-1>=0):
				Punktstapel.push_front(Vector2(koordinaten.x-1,koordinaten.y));
			if(koordinaten.y+1 < 64 ):
				Punktstapel.push_front(Vector2(koordinaten.x,koordinaten.y+1));
			if(koordinaten.y-1 >=0):
				Punktstapel.push_front(Vector2(koordinaten.x,koordinaten.y-1));
	



func _on_BadCoin1_pressed():
	get_node("../CoinWechsel").show();
	alterModus= modus;
	modus="Dialog";
	alteVorschau= Vorschau;
	Vorschau = "Coin";
	coinWechsel="BadCoin1";
	get_node("../"+aktiverKnopf).pressed= false;
	deaktiviere_Buttons();

func _on_GoodCoin1_pressed():
	get_node("../CoinWechsel").show();
	alterModus= modus;
	modus="Dialog";
	alteVorschau= Vorschau;
	Vorschau = "Coin";
	coinWechsel="GoodCoin1";
	get_node("../"+aktiverKnopf).pressed= false;
	deaktiviere_Buttons();

"""
Prozedur, die aufgerufen wird, falls ein Knopf der unteren Leiste gedrückt wird
Damit wechselt sich die Spielfigur, deren Design gerade bearbeitet wird
@param name - Name der neu zu bearbeitenden Spielfigur
"""
func CoinWechsel(name):
	
	
	# aktiven Knopf auf nicht pressed setzen
	#get_node("../"+aktiverKnopf).pressed = false;
	
	#neuen Knopf aktiv setzen
	aktiverKnopf= name;
	
	#Einladen auf die Zeichenfläche
	einladen(name);

	
	#Standardbutton setzen
	setze_Standardbutton();
	
	#Vorlagebuttonssetzen
	setze_Vorlagen();
	
	#Vorschau setzen
	aktualisiere_Vorschau();

"""
lädt ein Bild aus den Dateien in die Variable bild ein und aktualisiert die Zeichenfläche
"""	
func einladen(pfad):
	bild = Image.new();
	if Vorschau=="Blob":
		bild.load("Bilder/Standardspielfiguren/Spielfiguren/"+pfad+".png");
		#temporaeresBild.load("Bilder/Standardspielfiguren/Spielfiguren/"+pfad+".png");
	elif Vorschau =="Coin":
		bild.load("Bilder/Standardspielfiguren/Coins/"+pfad+".png");	
	else:
		bild.load("Bilder/Standardspielfiguren/Hintergrund/"+pfad+".png");
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
	if Vorschau =="Blob":
		icon.load("Bilder/Standardspielfiguren/Spielfiguren/"+aktiverKnopf+"Standard.png");
	elif Vorschau =="Coin":
		icon.load("Bilder/Standardspielfiguren/Coins/"+aktiverKnopf+"Standard.png");
	else:
		icon.load("Bilder/Standardspielfiguren/Hintergrund/"+aktiverKnopf+"Standard.png");
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
		if Vorschau == "Blob":
			icon.load("Bilder/Standardspielfiguren/Spielfiguren/"+aktiverKnopf+"Design"+str(i)+".png");
		elif Vorschau =="Coin":
			icon.load("Bilder/Standardspielfiguren/Coins/"+aktiverKnopf+"Design"+str(i)+".png");
		else:
			icon.load("Bilder/Standardspielfiguren/Hintergrund/"+aktiverKnopf+"Design"+str(i)+".png");	
		var buttontextur = ImageTexture.new();
		buttontextur.create_from_image(icon);
		get_node("../Vorlage"+str(i)).icon= buttontextur;

"""
aktualisiert das Vorschaubild an der linken Seite je nachdem, 
welche Spielfigur oder der Hintergrund gerade bearbeitet wird
"""
func aktualisiere_Vorschau():
	var texturklein = ImageTexture.new();
	texturklein.create_from_image(bild,0);
	if Vorschau == "Blob" or Vorschau == "Coin":
		get_node("../"+Vorschau).texture = texturklein;
	else:
		for i in range(0,9):
			get_node("../"+Vorschau+str(i)).texture = texturklein;	
	
"""
"""
func _on_Speichern_pressed():
	get_node("../UebernehmenBestaetigen").show();
	alterModus= modus;
	modus="Dialog";
	
	

func _on_Vorlage_pressed():
	alterModus=modus;
	modus="Dialog";
	get_node("../VorlageBestaetigen").show();

"""
setzt die Zeichenfläche mit durchsichtigen Pixeln
"""
func _on_Leeren_pressed():
	bild.fill(Color(0,0,0,0));
	setze_Zeichenflaeche();
	Abbild_auf_Rueckgaengigstapel();




func _on_Design1_pressed():
	get_node("../VorlageBestaetigen").hide();
	speichern(aktiverKnopf+"Design1", "Vorlage1");
	modus= alterModus;
	


func _on_Design2_pressed():
	get_node("../VorlageBestaetigen").hide();
	speichern(aktiverKnopf+"Design2", "Vorlage2");
	modus= alterModus;


func _on_Design3_pressed():
	get_node("../VorlageBestaetigen").hide();
	speichern(aktiverKnopf+"Design3", "Vorlage3");
	modus= alterModus;



func _on_Design4_pressed():
	get_node("../VorlageBestaetigen").hide();
	speichern(aktiverKnopf+"Design4", "Vorlage4");
	modus= alterModus;



func _on_Design5_pressed():
	get_node("../VorlageBestaetigen").hide();
	speichern(aktiverKnopf+"Design5", "Vorlage5");
	modus= alterModus;


func _on_Vorlage1_pressed():
	#Vorlage einladen
	einladen(aktiverKnopf+"Design1");
	aktualisiere_Vorschau();




func _on_Vorlage2_pressed():
	#Vorlage einladen
	einladen(aktiverKnopf+"Design2");
	aktualisiere_Vorschau();



func _on_Vorlage3_pressed():
	#Vorlage einladen
	einladen(aktiverKnopf+"Design3");
	aktualisiere_Vorschau();




func _on_Vorlage4_pressed():
	#Vorlage einladen
	einladen(aktiverKnopf+"Design4");
	aktualisiere_Vorschau();


func _on_Vorlage5_pressed():
	#Vorlage einladen
	einladen(aktiverKnopf+"Design5");
	aktualisiere_Vorschau();


func _on_Standard_pressed():
	#Standard einladen
	einladen(aktiverKnopf+"Standard");
	aktualisiere_Vorschau();



func _on_BadCoin2_pressed():
	get_node("../CoinWechsel").show();
	alterModus= modus;
	modus="Dialog";
	alteVorschau= Vorschau;
	Vorschau = "Coin";
	coinWechsel="BadCoin2";
	get_node("../"+aktiverKnopf).pressed= false;
	deaktiviere_Buttons();


func _on_GoodCoin2_pressed():
	get_node("../CoinWechsel").show();
	alterModus= modus;
	modus="Dialog";
	alteVorschau= Vorschau;
	Vorschau = "Coin";
	coinWechsel="GoodCoin2";
	get_node("../"+aktiverKnopf).pressed= false;
	deaktiviere_Buttons();


func _on_RandomCoin_pressed():
	get_node("../CoinWechsel").show();
	alterModus= modus;
	modus="Dialog";
	alteVorschau= Vorschau;
	Vorschau = "Coin";
	coinWechsel="RandomCoin";
	get_node("../"+aktiverKnopf).pressed= false;
	deaktiviere_Buttons();

func _on_Blob_1_gerade_pressed():
	get_node("../CoinWechsel").show();
	alterModus= modus;
	modus="Dialog";
	alteVorschau= Vorschau;
	Vorschau = "Blob";
	coinWechsel="Blob_1_gerade";
	get_node("../"+aktiverKnopf).pressed= false;
	deaktiviere_Buttons();


func _on_Blob_3_gerade_pressed():
	get_node("../CoinWechsel").show();
	alterModus= modus;
	modus="Dialog";
	alteVorschau= Vorschau;
	Vorschau = "Blob";
	coinWechsel="Blob_3_gerade";
	get_node("../"+aktiverKnopf).pressed= false;
	deaktiviere_Buttons();


func _on_Blob_2_gerade_pressed():
	get_node("../CoinWechsel").show();
	alterModus= modus;
	modus="Dialog";
	alteVorschau= Vorschau;
	Vorschau = "Blob";
	coinWechsel="Blob_2_gerade";
	get_node("../"+aktiverKnopf).pressed= false;
	deaktiviere_Buttons();


func _on_Blob_4_gerade_pressed():
	get_node("../CoinWechsel").show();
	alterModus= modus;
	modus="Dialog";
	alteVorschau= Vorschau;
	Vorschau = "Blob";
	coinWechsel="Blob_4_gerade";
	get_node("../"+aktiverKnopf).pressed= false;
	deaktiviere_Buttons();


func _on_Blob_5_gerade_pressed():
	get_node("../CoinWechsel").show();
	alterModus= modus;
	modus="Dialog";
	alteVorschau= Vorschau;
	Vorschau = "Blob";
	coinWechsel="Blob_5_gerade";
	get_node("../"+aktiverKnopf).pressed= false;
	deaktiviere_Buttons();


func _on_ColorPickerButton_pressed():
	Colorpickerb= true;


func _on_Hintergrund_pressed():
	get_node("../CoinWechsel").show();
	alterModus= modus;
	modus="Dialog";
	alteVorschau= Vorschau;
	Vorschau = "Hintergrund";
	coinWechsel="Hintergrund";
	get_node("../"+aktiverKnopf).pressed= false;
	deaktiviere_Buttons();
	


func _on_Kanonenkugel_pressed():
	get_node("../CoinWechsel").show();
	alterModus= modus;
	modus="Dialog";
	alteVorschau= Vorschau;
	Vorschau = "Blob";
	coinWechsel="Kanonenkugel";
	get_node("../"+aktiverKnopf).pressed= false;
	deaktiviere_Buttons();


func _on_UebernehmenBestaetigen_confirmed():
	speichern(aktiverKnopf, aktiverKnopf);



func _on_Rueckgaengig_pressed():
	mache_rueckgaengig();

func mache_rueckgaengig():
	if rueckgaengigstapel.size() > 1:
		print("bin in rückgängig");
		wiederholenstapel.push_back(rueckgaengigstapel.pop_back());
		bild.copy_from(rueckgaengigstapel.back());
		setze_Zeichenflaeche();
		aktualisiere_Vorschau();

func _on_Wiederholen_pressed():
	wiederhole();

func wiederhole():
	if wiederholenstapel.size() > 0:
		bild.copy_from(wiederholenstapel.back());
		rueckgaengigstapel.push_back(wiederholenstapel.pop_back());
		setze_Zeichenflaeche();
		aktualisiere_Vorschau();

func _on_CoinWechsel_confirmed():
	pass # Replace with function body.


func _on_CoinWechsel_popup_hide():
	print("angekommen");
	modus=alterModus;
	print(modus);
	



func groesse_Zeichnung():
	bild.lock();
	maxy= 0;
	for x in range (64):
		for y in range (64):
			if(bild.get_pixel(x,y) != Color(0,0,0,0)):
				if minx == null:
					minx = x;
				maxx= x;
				if miny == null:
					miny = y;
				if y < miny:
					miny = y;
				if y > maxy:
					maxy = y;
	bild.unlock();
	#rückgangig
	"""
	verschiebt die Zeichnung in Y Richtung nach unten zum Bildrand,
	damit die Spielfigur nicht mehr schwebt im Spiel
	"""
func setze_an_unteren_Bildrand():
	groesse_Zeichnung();
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
	aktualisiere_Vorschau();
	Abbild_auf_Rueckgaengigstapel();


func _on_Bildrand_pressed():
	setze_an_unteren_Bildrand();
	
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
		
func setze_Figurauswahlbuttons():
	pass;
	
func alles_rueckgaengig():
	#für jede Spielfigur:
	
	#setze Vorlagenbuttons auf alte Vorlage
	pass;
	#setze aktuelle Figur auf Standard

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
			temporaeresBild.set_pixel(schnell,langsam, aktuelleFarbe);
		else:
			temporaeresBild.set_pixel(langsam,schnell, aktuelleFarbe);
		#Wenn Q negativ ist, erhöhe Q um Q_equal
		if (Q<0):
			Q = Q + Q_equal;
		#Sonst erhöhe Q um Q_step und erhöhe die langsame Variable um seine Schrittweite
		else :
			Q = Q + Q_step;
			langsam+= stepLangsam;
		schnell+=stepSchnell
	temporaeresBild.set_pixel(x1,y1, aktuelleFarbe);
	temporaeresBild.unlock();
	setze_temporaere_Zeichenflaeche();
	
func eigene_Farbe_speichern(name):
	var icon1 = Image.new();
	icon1.create(16, 16, false, Image.FORMAT_RGBA8);
	icon1.fill(aktuelleFarbe);
	icon1.lock();
	icon1.unlock();
	knopf_aktualisieren(name, icon1);
	#persistent Speichern
	icon1.save_png("Bilder/Farben/"+name+".png");
	
	
	

func _on_EigeneFarbeSpeichern1_pressed():
	eigeneFarbe[0]= aktuelleFarbe;
	eigene_Farbe_speichern("EigeneFarbe1");


func _on_EigeneFarbeSpeichern2_pressed():
	eigeneFarbe[1]= aktuelleFarbe;
	eigene_Farbe_speichern("EigeneFarbe2");


func _on_EigeneFarbeSpeichern3_pressed():
	eigeneFarbe[2]= aktuelleFarbe;
	eigene_Farbe_speichern("EigeneFarbe3");
	

func _on_EigeneFarbeSpeichern4_pressed():
	eigeneFarbe[3]= aktuelleFarbe;
	eigene_Farbe_speichern("EigeneFarbe4");


func _on_EigeneFarbeSpeichern5_pressed():
	eigeneFarbe[4]= aktuelleFarbe;
	eigene_Farbe_speichern("EigeneFarbe5");

func Farbwechsel_bei_Radierer():
	aktuellerModusbutton.pressed= false;
	aktuellerModusbutton = get_node("../Stift");
	aktuellerModusbutton.pressed= true;
	modus = "Stift";
	

func _on_EigeneFarbe1_pressed():
	aktuellerFarbbutton.pressed= false;
	aktuellerFarbbutton= get_node("../EigeneFarbe1");
	aktuelleFarbe = eigeneFarbe[0];
	if modus =="Radierer":
		Farbwechsel_bei_Radierer();


func _on_EigeneFarbe2_pressed():
	aktuellerFarbbutton.pressed= false;
	aktuellerFarbbutton= get_node("../EigeneFarbe2");
	aktuelleFarbe = eigeneFarbe[1];
	if modus =="Radierer":
		Farbwechsel_bei_Radierer();
		


func _on_EigeneFarbe3_pressed():
	aktuellerFarbbutton.pressed= false;
	aktuellerFarbbutton= get_node("../EigeneFarbe3");
	aktuelleFarbe = eigeneFarbe[2];
	if modus =="Radierer":
		Farbwechsel_bei_Radierer();


func _on_EigeneFarbe4_pressed():
	aktuellerFarbbutton.pressed= false;
	aktuellerFarbbutton= get_node("../EigeneFarbe4");
	aktuelleFarbe = eigeneFarbe[3];
	if modus =="Radierer":
		Farbwechsel_bei_Radierer();


func _on_EigeneFarbe5_pressed():
	aktuellerFarbbutton.pressed= false;
	aktuellerFarbbutton= get_node("../EigeneFarbe5");
	aktuelleFarbe = eigeneFarbe[4];
	if modus =="Radierer":
		Farbwechsel_bei_Radierer();

	
func eigene_Farben_einladen():
	for i in range(1,6):
		var icon = Image.new();
		icon.load("Bilder/Farben/EigeneFarbe"+str(i)+".png");
		icon.lock();
		eigeneFarbe[i-1]= icon.get_pixel(0,0);
		icon.unlock();


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
		temporaeresBild.set_pixel(start.x+i, start.y, aktuelleFarbe);
	for i in range (0, abs(start.x-ende.x)):
		temporaeresBild.set_pixel(start.x+i, ende.y, aktuelleFarbe);
	for i in range (0, abs(start.y-ende.y)):
		temporaeresBild.set_pixel(start.x, start.y+i, aktuelleFarbe);
	for i in range (0, abs(start.y-ende.y)+1):
		temporaeresBild.set_pixel(ende.x, start.y+i, aktuelleFarbe);
	temporaeresBild.unlock();
	
	setze_temporaere_Zeichenflaeche();


func _on_Rechteck_pressed():
	modus="Rechteck";
	linienEnde = null;
	linienStart= null;
	aktuellerModusbutton.pressed= false;
	aktuellerModusbutton = get_node("../Rechteck");
	
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
	aktualisiere_Vorschau();
	#temporäre Zeichenfläche löschen
	leere_temporaere_Zeichenflaeche();
	setze_temporaere_Zeichenflaeche();
	

func leere_temporaere_Zeichenflaeche():
	temporaeresBild.fill(Color(0,0,0,0));




func _on_Ja_pressed():
	modus = alterModus;
	CoinWechsel(coinWechsel);
	get_node("../CoinWechsel").hide();
	aktiviere_Buttons();
	



func _on_Nein_pressed():
	modus = alterModus;
	Vorschau = alteVorschau;
	get_node("../CoinWechsel").hide();
	get_node("../"+aktiverKnopf).pressed= true;
	get_node("../"+coinWechsel).pressed= false;
	aktiviere_Buttons();
	
func deaktiviere_Buttons():
	var Kinder = get_parent().get_children();
	for Kind in Kinder:
		if Kind is Button:
			Kind.disabled = true;

func aktiviere_Buttons():
	var Kinder = get_parent().get_children();
	for Kind in Kinder:
		if Kind is Button:
			Kind.disabled = false;
			
			
			
func male_Ellipse(cx,cy, radiusx, radiusy):
	var zweiAQuadrat = 2* radiusx*radiusx;
	var zweiBQuadrat= 2* radiusy*radiusy;
	var x = radiusx;
	var y = 0;
	var xwechsel = radiusy*radiusy*(1-2*radiusx);
	var ywechsel = radiusx*radiusx;
	var ellipsenfehler= 0;
	var stopX = zweiBQuadrat*radiusx; 
	var stopY := 0;
	
	while stopX >= stopY:
		male_vier_Ellipsenpunkte(x,y, cx,cy);
		y= y+1;
		stopY = stopY +zweiAQuadrat;
		ellipsenfehler = ellipsenfehler + ywechsel;
		if 2* ellipsenfehler+ xwechsel > 0:
			x= x-1;
			stopX = stopX -zweiBQuadrat;
			xwechsel = xwechsel + zweiBQuadrat;
	x= 0;
	y= radiusy;
	xwechsel = radiusy*radiusy;
	ywechsel= radiusx*radiusx*(1-2*radiusy);
	ellipsenfehler= 0;
	stopX= 0;
	stopY= zweiAQuadrat* radiusy;
	while stopX <= stopY:
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
	setze_temporaere_Zeichenflaeche();

func male_vier_Ellipsenpunkte(x,y, cx,cy):
	temporaeresBild.lock()
	temporaeresBild.set_pixel(cx+x,cy+y);
	temporaeresBild.set_pixel(cx-x,cy+y);
	temporaeresBild.set_pixel(cx-x,cy-y);
	temporaeresBild.set_pixel(cx+x,cy-y);
	temporaeresBild.unlock();