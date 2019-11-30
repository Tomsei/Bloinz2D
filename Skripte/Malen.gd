extends Sprite


var bildgroesse;
var aktuelleFarbe;
var modus = "Stift";
var linienStart;
var linienEnde;
var bresenham;
var stiftgroesse;
var bild;
var textur;
var array;
var aktiverKnopf;
var alterModus;
var Vorschau;
var bildkopie;



# Called when the node enters the scene tree for the first time.
func _ready():
	# Setze Bildschirmgroesse.
	OS.set_window_size(Vector2(900,660));
	aktuelleFarbe = Color(1,1,1,1);
	get_node("../ColorPickerButton").color = Color(1,1,1,1);
	stiftgroesse = 1;
	bildgroesse = 512;
	bild = Image.new();
	bild.create(bildgroesse, bildgroesse, false, Image.FORMAT_RGBA4444);
	textur = ImageTexture.new();
	aktiverKnopf=" ";
	#Kopie der Zeichenfläche in 64*64
	bildkopie = Image.new();
		
		
		
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
	if Input.is_action_just_pressed("draw"):
		var mouseposition = get_global_mouse_position();
		if mouseposition.x >= 256 and mouseposition.y <= 512 and mouseposition.x < 767:
			if modus == "Linie":
				linienStart= mouseposition;
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
			if modus=="Linie":
				linienEnde = get_global_mouse_position();
				bresenham = false;
				update();
			elif modus=="Stift":
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
				bresenham = true;
				update();
	
	
	



func speichern(bildname, Knopf):
	
	if Knopf != " ":

		#Bild in den Dateien speichern
		bildkopie.save_png("Bilder/Standardspielfiguren/"+bildname+".png");
		
		#Knopf aktualisieren
		knopf_aktualisieren(Knopf, bildkopie);

func knopf_aktualisieren(Name, bildkopie):
	
	var buttontextur = ImageTexture.new()
	buttontextur.create_from_image(bildkopie);
	#Knopf mit aktualisiertem Bild
	var Pfad = "../"+ Name;
	get_node(Pfad).icon= buttontextur;



func _on_ColorPickerButton_popup_closed():
	aktuelleFarbe = get_node("../ColorPickerButton").color;
	print(aktuelleFarbe);


func _on_Stift_pressed():
	modus = "Stift";


func _on_Linie_pressed():
	modus = "Linie";


func _on_Radierer_pressed():
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
	aktuelleFarbe = Color(0.9,0.23,0.1);


func _on_Farbe2_pressed():
	aktuelleFarbe = Color(0.9,0.72,0.1);


func _on_Farbe3_pressed():
	aktuelleFarbe = Color(0.46,0.9,0.1);


func _on_Farbe4_pressed():
	aktuelleFarbe = Color(0.1,0.9,0.81);


func _on_Farbe5_pressed():
	aktuelleFarbe = Color(0.1,0.36,0.9);


func _on_Farbe6_pressed():
	aktuelleFarbe = Color(0.63,0.1,0.9);


func _on_Farbe7_pressed():
	aktuelleFarbe = Color(0.9,0.1,0.78);


func _on_Farbe8_pressed():
	aktuelleFarbe = Color(0.95,0.78,0.59);


func _on_Farbe9_pressed():
	aktuelleFarbe = Color(1,1,1);


func _on_Farbe10_pressed():
	aktuelleFarbe = Color(0,0,0);



func _on_klein_pressed():
	stiftgroesse= 1;


func _on_mittel_pressed():
	stiftgroesse= 2;


func _on_gro_pressed():
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
	get_tree().change_scene("res://Szenen/Spieloberflaeche.tscn")
	OS.set_window_size(Vector2(384,512))


func _on_Fuellen_pressed():
	modus="Fuellen";

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
	if(aktiverKnopf != " "):
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
	get_node("../"+Vorschau).texture = texturklein;
	
	
func _on_Speichern_pressed():

	speichern(aktiverKnopf, aktiverKnopf);
	

func _on_Vorlage_pressed():
	alterModus=modus;
	modus="Dialog";
	
	get_node("../VorlageBestaetigen").show();


func _on_Design1_pressed():
	get_node("../VorlageBestaetigen").hide();
	speichern(aktiverKnopf+"Design1", "Vorlage1");
	modus= alterModus;
	

func _on_Leeren_pressed():
	bild.fill(Color(0,0,0,0));
	textur.create_from_image(bild);
	texture = textur;

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




func _on_Vorlage2_pressed():
	#Vorlage einladen
	einladen(aktiverKnopf+"Design2");



func _on_Vorlage3_pressed():
	#Vorlage einladen
	einladen(aktiverKnopf+"Design3");




func _on_Vorlage4_pressed():
	#Vorlage einladen
	einladen(aktiverKnopf+"Design4");



func _on_Vorlage5_pressed():
	#Vorlage einladen
	einladen(aktiverKnopf+"Design5");


func _on_Standard_pressed():
	#Standard einladen
	einladen(aktiverKnopf+"Standard");


func _on_Button3_pressed():
	pass # Replace with function body.


func _on_Button5_pressed():
	pass # Replace with function body.


func _on_Button6_pressed():
	pass # Replace with function body.


func _on_Button7_pressed():
	pass # Replace with function body.


func _on_BadCoin2_pressed():
	Vorschau = "Coin";
	CoinWechsel("BadCoin2");


func _on_GoodCoin2_pressed():
	Vorschau = "Coin";
	CoinWechsel("GoodCoin2");


func _on_RandomCoin_pressed():
	Vorschau = "Coin";
	CoinWechsel("RandomCoin");
