extends Sprite


var bildgroesse;
var aktuelleFarbe;
var modus = "Stift";
var linienStart;
var linienEnde;
var stiftgroesse;
var bild;
var textur;
var array;
var aktiverKnopf;
var alterModus;
var Vorschau;
var bildkopie;
var aktuellerFarbbutton;
var aktuellerStiftbutton;
var aktuellerModusbutton;
var Colorpickerb;



# Konstruktor
func _ready():
	# Setze Bildschirmgroesse.
	OS.set_window_size(Vector2(900,660));
	
	#Farbe voreinstellen
	aktuellerFarbbutton= get_node("../Farbe9");
	aktuellerFarbbutton.pressed= true;
	aktuelleFarbe = Color(1,1,1,1);
	get_node("../ColorPickerButton").color = Color(1,1,1,1);
	
	#Stiftgroesse voreinstellen
	stiftgroesse = 1;
	aktuellerStiftbutton = get_node("../klein");
	aktuellerStiftbutton.pressed= true;
	aktuellerModusbutton = get_node("../Stift");
	aktuellerModusbutton.pressed= true;
	
	
	bildgroesse = 512;
	bild = Image.new();
	bild.create(bildgroesse, bildgroesse, false, Image.FORMAT_RGBA4444);
	textur = ImageTexture.new();
	aktiverKnopf=" ";
	#Kopie der Zeichenfläche in 64*64
	bildkopie = Image.new();
	
	#Anfangsknopf auf ersten Blob setzen
	aktiverKnopf= "Blob_1_gerade";
	get_node("../Blob_1_gerade").pressed = true;
	einladen(aktiverKnopf);
	#Standardbutton setzen
	setze_Standardbutton(aktiverKnopf);
	#Vorlagebuttonssetzen
	setze_Vorlagen();
	#Vorschau setzen
	Vorschau= "Blob";
	aktualisiere_Vorschau();
	
	#Colorpickerbutton ist zu
	Colorpickerb = false;
	
	#Linien
	linienEnde = null;
	linienStart = null;
	


func bildkopie_erstellen():
	bildkopie.copy_from(bild);
	bildkopie.lock();
	bildkopie.resize(64,64,1);
	bildkopie.unlock();

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

func linie_malen():
	draw_primitive( PoolVector2Array([Vector2(303,303)]), PoolColorArray( [Color(1,1,1)]), PoolVector2Array());

""" 
malt einen 8*8 großen Punkt auf die Zeichenfläche
Eingabe x: x-Wert vom Pixel unten links
Eingabe y: y-Wert vom Pixel unten links 
"""
	
func punkt_malen(x, y):
	var xgross = x*8;
	var ygross = y*8;
	bild.lock();
	for zeile in range (9):
		for spalte in range(9):
			bild.set_pixel(xgross+zeile,ygross+spalte, aktuelleFarbe)
	bild.unlock();
	textur = ImageTexture.new();
	textur.create_from_image(bild);
	texture= textur;
	
	
func punkt_malen_pixel(x,y):
	var xneu = floor(x/8)*8;
	var yneu = floor(y/8)*8;
	print(xneu);
	print(yneu);
	bild.lock();
	for zeile in range (8*stiftgroesse):
		for spalte in range(8*stiftgroesse):
			bild.set_pixel(xneu+zeile-1, yneu+spalte-1, aktuelleFarbe)
	bild.unlock();
	textur = ImageTexture.new();
	textur.create_from_image(bild);
	texture= textur;


func punkt_loeschen(x, y):
	var xneu = floor(x/8)*8;
	var yneu = floor(y/8)*8;
	print(xneu);
	print(yneu);
	bild.lock();
	for zeile in range (8*stiftgroesse):
		for spalte in range(8*stiftgroesse):
			bild.set_pixel(xneu+zeile-1, yneu+spalte-1, Color(0,0,0,0));
	bild.unlock();
	textur = ImageTexture.new();
	textur.create_from_image(bild);
	texture= textur;

func befuellen():
	bild.lock();
	for x in range(511):
		for y in range(511):
			array[x][y] = bild.get_pixel(x,y);
	bild.unlock();

func _process(delta):
	if Colorpickerb == false:
		if Input.is_action_just_pressed("draw"):
			var mouseposition = get_global_mouse_position();
			if mouseposition.x >= 256 and mouseposition.y <= 512 and mouseposition.x < 767:
				if modus == "Linie":
					if linienStart == null:
						linienStart = get_global_mouse_position();
						linienStart.x = linienStart.x-256;
						punkt_malen_pixel(linienStart.x, linienStart.y);
					else:
						linienEnde = get_global_mouse_position();
						linienEnde.x = linienEnde.x-256;
						print("Male Linie");
						male_Linie(linienStart,linienEnde);
						linienStart = null;
						linienEnde = null;
						
				elif modus =="Fuellen":
						array = create_2d_array(512,512,Color(0,0,0,0));
						befuellen();
						fuellen(aktuelleFarbe,mouseposition.x-256,mouseposition.y, array[mouseposition.x-256][mouseposition.y]);
						bild.lock();
						for zeile in range(511):
							for spalte in range(511):
								bild.set_pixel(zeile, spalte,array[zeile][spalte]);
						bild.unlock();
						textur = ImageTexture.new();
						textur.create_from_image(bild);
						texture= textur;
						print("durch");
		elif Input.is_action_pressed("draw"):
			var mouseposition = get_global_mouse_position();
			if mouseposition.x >= 256 and mouseposition.y <= 512 and mouseposition.x < 767:
				#if modus=="Linie":
				#	linienEnde = get_global_mouse_position();
				#	male_Linie(linienStart,linienEnde);
				if modus=="Stift":
					punkt_malen_pixel((mouseposition.x-256),mouseposition.y);
					aktualisiere_Vorschau();
				elif modus == "Radierer":
					punkt_loeschen((mouseposition.x-256),mouseposition.y);
					aktualisiere_Vorschau();
		elif Input.is_action_just_released("draw"):
			var mouseposition = get_global_mouse_position();
			if mouseposition.x >= 256 and mouseposition.y <= 512:
				if modus=="Linie":
					linienEnde = get_global_mouse_position();



func male_Linie(start,ende):
	bildkopie_erstellen()
	# Setzen der Koordinaten-Variablen, die jeweils den aktuellen Punkt angeben
	var y = start.y;
	var x = start.x;
	
	var y1 = ende.y;
	var x1 = ende.x;
	var y0 = start.y;
	var x0 = start.x;
	#Setzen der Variablen, die angeben, ob x & y hoch- oder runtergezählt werden 
	var stepy = 1;
	var stepx = 1;
	
	#Setzen der Variablen, die Delta x und Delta y angeben
	var a = y1-y0;
	var b = -(x1-x0);

	
	#Wenn die Linie nach unten geht, muss y herunterzählen 
	#Ist für den 5. & 8. Oktanten notwendig
	if a < 0:
		a = -1 * a;
		stepy = -1 * stepy;

	
	#Wenn die Linie nach links geht, muss x herunterzählen
	#Ist für den 4. & 5. Oktanten notwendig
	if b > 0:
		b = -1 * b;
		stepx = -1 * stepx;
	
	# Berechnung von Q, Q_step & Q_equal 
	var Q = 2*a+b;
	var Q_step = 2*(a+b);
	var Q_equal = 2*a;
	
	
	#Durchlaufe die x bis es seinen Endpunkt erreicht
	#while[x <50 and x > 0 ]:
	for i in range(0,20):
		print(x);
		print(y);
		#Male den aktuellen Pixel
		bildkopie.set_pixel(x,y, aktuelleFarbe);
			
			#Wenn Q negativ ist, erhöhe Q um Q_equal
		if Q<0:
			Q = Q + Q_equal;
				
			#Sonst erhöhe Q um Q_step und erhöhe die y um seine Schrittweite
		else:
			Q = Q + Q_step;
			y= y+ stepy;
			
		x= x+stepx;
	bild.copy_from(bildkopie);
	bild.lock();
	bild.resize(512,512,1);
	bildkopie.unlock();
	textur = ImageTexture.new();
	textur.create_from_image(bild);
	texture= textur;


func speichern(bildname, Knopf):
	
	bildkopie_erstellen();

	#Bild in den Dateien speichern
	bildkopie.save_png("Bilder/Standardspielfiguren/"+bildname+".png");
	
	#Knopf aktualisieren
	knopf_aktualisieren(Knopf);

func knopf_aktualisieren(Name):
	
	
	var buttontextur = ImageTexture.new()
	buttontextur.create_from_image(bildkopie);
	#Knopf mit aktualisiertem Bild
	var Pfad = "../"+ Name;
	get_node(Pfad).icon= buttontextur;



func _on_ColorPickerButton_popup_closed():
	aktuellerFarbbutton.pressed= false;
	aktuellerFarbbutton= get_node("../ColorPickerButton");
	aktuelleFarbe = get_node("../ColorPickerButton").color;
	modus="";
	Colorpickerb= false;


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


func _on_Spiegeln_pressed():
	var hilfe;
	bild.lock();
	bild.flip_x();
	bild.unlock();
	textur = ImageTexture.new();
	textur.create_from_image(bild);
	texture = textur;


func _on_Farbe1_pressed():
	aktuellerFarbbutton.pressed= false;
	aktuellerFarbbutton= get_node("../Farbe1");
	aktuelleFarbe = Color(0.9,0.23,0.1);
	modus = "Stift";


func _on_Farbe2_pressed():
	aktuellerFarbbutton.pressed= false;
	aktuellerFarbbutton= get_node("../Farbe2");
	aktuelleFarbe = Color(0.9,0.72,0.1);
	modus = "Stift";


func _on_Farbe3_pressed():
	aktuellerFarbbutton.pressed= false;
	aktuellerFarbbutton= get_node("../Farbe3");
	aktuelleFarbe = Color(0.46,0.9,0.1);
	modus = "Stift";


func _on_Farbe4_pressed():
	aktuellerFarbbutton.pressed= false;
	aktuellerFarbbutton= get_node("../Farbe4");
	aktuelleFarbe = Color(0.1,0.9,0.81);
	modus = "Stift";


func _on_Farbe5_pressed():
	aktuellerFarbbutton.pressed= false;
	aktuellerFarbbutton= get_node("../Farbe5");
	aktuelleFarbe = Color(0.1,0.36,0.9);
	modus = "Stift";


func _on_Farbe6_pressed():
	aktuellerFarbbutton.pressed= false;
	aktuellerFarbbutton= get_node("../Farbe6");
	aktuelleFarbe = Color(0.63,0.1,0.9);
	modus = "Stift";


func _on_Farbe7_pressed():
	aktuellerFarbbutton.pressed= false;
	aktuellerFarbbutton= get_node("../Farbe7");
	aktuelleFarbe = Color(0.9,0.1,0.78);
	modus = "Stift";


func _on_Farbe8_pressed():
	aktuellerFarbbutton.pressed= false;
	aktuellerFarbbutton= get_node("../Farbe8");
	aktuelleFarbe = Color(0.95,0.78,0.59);
	modus = "Stift";


func _on_Farbe9_pressed():
	aktuellerFarbbutton.pressed= false;
	aktuellerFarbbutton= get_node("../Farbe9");
	aktuelleFarbe = Color(1,1,1);
	modus = "Stift";


func _on_Farbe10_pressed():
	aktuellerFarbbutton.pressed= false;
	aktuellerFarbbutton= get_node("../Farbe10");
	aktuelleFarbe = Color(0,0,0);
	modus = "Stift";



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


func _on_Button2_button_up():
	bild = Image.new();
	bild.load("Bilder/figur.png");
	bild.lock();
	bild.resize(512,512,1);
	bild.unlock();
	textur = ImageTexture.new();
	textur.create_from_image(bild);
	texture = textur;



func _on_Zurueck_button_up():
	get_tree().change_scene("res://Szenen/Player.tscn")
	OS.set_window_size(Vector2(384,512))


func _on_Fuellen_pressed():
	modus="Fuellen";
	aktuellerModusbutton.pressed= false;
	aktuellerModusbutton = get_node("../Fuellen");


#Dictonary mit besuchten Punkten
#Floodfill
func fuellen(neueFarbe,x,y, alteFarbe):
	var Punktstapel;
	Punktstapel=[];
	Punktstapel.push_front(Vector2(x,y));
	var besuchtePunkte;
	besuchtePunkte=[];
	besuchtePunkte.append(Vector2(x,y));
	while(!Punktstapel.empty()):
		var koordinaten = Punktstapel.pop_front();
		besuchtePunkte.append(koordinaten);
		if(array[koordinaten.x][koordinaten.y] == alteFarbe):
			array[koordinaten.x][koordinaten.y]= neueFarbe;
			if( koordinaten.x+1 <511 and besuchtePunkte.find(Vector2(koordinaten.x+1,koordinaten.y))== -1):
				Punktstapel.push_front(Vector2(koordinaten.x+1,koordinaten.y));
			if(koordinaten.x-1>0 and besuchtePunkte.find(Vector2(koordinaten.x-1,koordinaten.y))== -1):
				Punktstapel.push_front(Vector2(koordinaten.x-1,koordinaten.y));
			if(koordinaten.y+1 < 511 and besuchtePunkte.find(Vector2(koordinaten.x,koordinaten.y+1))== -1):
				Punktstapel.push_front(Vector2(koordinaten.x,koordinaten.y+1));
			if(koordinaten.y-1 >0 and besuchtePunkte.find(Vector2(koordinaten.x,koordinaten.y-1))== -1):
				Punktstapel.push_front(Vector2(koordinaten.x,koordinaten.y-1));
	
	
func fuellenrekursiv(neueFarbe,x,y,alteFarbe):
	
	if( array[x][y] == alteFarbe):
		array[x][y] = neueFarbe;
		fuellenrekursiv(neueFarbe,x+1,y,alteFarbe);
		fuellenrekursiv(neueFarbe,x-1,y,alteFarbe);
		fuellenrekursiv(neueFarbe,x,y+1,alteFarbe);
		#fuellenrekursiv(neueFarbe,x,y-1,alteFarbe);

	"""bild.set_pixel(x,y,farbe);
	var i = 1;
	while(bild.get_pixel(x+i,y) == alteFarbe):
		bild.set_pixel(x+i,y,farbe);
		i= i+1;
	i=1;
	while(bild.get_pixel(x,y+i) == alteFarbe):
		bild.set_pixel(x,y+i,farbe);
		i= i+1;
	i=1;
	while(bild.get_pixel(x,y-i) == alteFarbe):
		bild.set_pixel(x,y-i,farbe);
		i= i+1;
	i=1;
	while(bild.get_pixel(x-i,y) == alteFarbe):
		bild.set_pixel(x-i,y,farbe);
		i= i+1;"""


func _on_BadCoin1_button_down():
	Vorschau = "Coin";
	CoinWechsel("BadCoin1");

func _on_GoodCoin1_button_down():
	Vorschau = "Coin";
	CoinWechsel("GoodCoin1");

	
	
func CoinWechsel(name):
	
	
	# aktiven Knopf auf nicht pressed setzen
	get_node("../"+aktiverKnopf).pressed = false;
	
	#neuen Knopf aktiv setzen
	aktiverKnopf= name;
	
	#Einladen auf die Zeichenfläche
	einladen(name);
	
	#Standardbutton setzen
	setze_Standardbutton(name);
	
	#Vorlagebuttonssetzen
	setze_Vorlagen();
	
	#Vorschau setzen
	aktualisiere_Vorschau();
	
func einladen(pfad):
	bild = Image.new();
	bild.load("Bilder/Standardspielfiguren/"+pfad+".png");
	bild.lock();
	bild.resize(512,512,1);
	bild.unlock();
	textur = ImageTexture.new();
	textur.create_from_image(bild);
	texture = textur;
	
func setze_Standardbutton(pfad):
	var icon = Image.new();
	icon.load("Bilder/Standardspielfiguren/"+pfad+"Standard.png");
	var buttontextur = ImageTexture.new();
	buttontextur.create_from_image(icon);
	get_node("../Standard").icon= buttontextur;


func setze_Vorlagen():
	for i in range(1,6):
		var icon = Image.new();
		icon.load("Bilder/Standardspielfiguren/"+aktiverKnopf+"Design"+str(i)+".png");
		var buttontextur = ImageTexture.new();
		buttontextur.create_from_image(icon);
		get_node("../Vorlage"+str(i)).icon= buttontextur;



func aktualisiere_Vorschau():
	bildkopie_erstellen();
	var texturklein = ImageTexture.new();
	texturklein.create_from_image(bildkopie);
	if Vorschau == "Blob" or Vorschau == "Coin":
		get_node("../"+Vorschau).texture = texturklein;
	else:
		for i in range(0,9):
			get_node("../"+Vorschau+str(i)).texture = texturklein;	
	
	
func _on_Speichern_pressed():
	get_node("../UebernehmenBestaetigen").show();
	alterModus= modus;
	modus="";
	
	

func _on_Vorlage_pressed():
	alterModus=modus;
	modus="Dialog";
	
	get_node("../VorlageBestaetigen").show();


func _on_Leeren_pressed():
	bild.fill(Color(0,0,0,0));
	textur.create_from_image(bild);
	texture = textur;



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
	Vorschau = "Coin";
	CoinWechsel("BadCoin2");


func _on_GoodCoin2_pressed():
	Vorschau = "Coin";
	CoinWechsel("GoodCoin2");


func _on_RandomCoin_pressed():
	Vorschau = "Coin";
	CoinWechsel("RandomCoin");


func _on_Blob_1_gerade_pressed():
	Vorschau = "Blob";
	CoinWechsel("Blob_1_gerade");


func _on_Blob_3_gerade_pressed():
	Vorschau = "Blob";
	CoinWechsel("Blob_3_gerade");


func _on_Blob_2_gerade_pressed():
	Vorschau = "Blob";
	CoinWechsel("Blob_2_gerade");


func _on_Blob_4_gerade_pressed():
	Vorschau = "Blob";
	CoinWechsel("Blob_4_gerade");


func _on_Blob_5_gerade_pressed():
	Vorschau = "Blob";
	CoinWechsel("Blob_5_gerade");


func _on_ColorPickerButton_pressed():
	Colorpickerb= true;


func _on_Hintergrund_pressed():
	Vorschau = "Hintergrund";
	CoinWechsel("Hintergrund");
	


func _on_Kanonenkugel_pressed():
	Vorschau = "Blob";
	CoinWechsel("Kanonenkugel");


func _on_UebernehmenBestaetigen_confirmed():
	speichern(aktiverKnopf, aktiverKnopf);
