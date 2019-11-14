extends Node2D


var array;
var arraylength=64;
var aktuelleFarbe;
var modus = "Stift";
var linienStart;
var linienEnde;
var bresenham;
var stiftgroesse;


# Called when the node enters the scene tree for the first time.
func _ready():
	array = create_2d_array(arraylength, arraylength, null);
	aktuelleFarbe = Color(1,1,1,1);
	get_node("../ColorPickerButton").color = Color(1,1,1,1);
	stiftgroesse = 0;
	

func _draw():
	for zeile in range(0, arraylength):
		for spalte in range(0, arraylength):
			if array[zeile][spalte] != null:
				punkt_malen(zeile, spalte);
	if modus=="Linidfe":
		if bresenham == true:
			bresenham = false;
		else:
			draw_line(linienStart, linienEnde, Color(1,1,1));


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
	for zeile in range (9):
		for spalte in range(9):
			var color = PoolColorArray( [array[x][y]] );
			var punkt = PoolVector2Array([Vector2(xgross+zeile,ygross+spalte)]);
			draw_primitive (punkt,color, PoolVector2Array() );
	

func _process(delta):
	if Input.is_action_just_pressed("draw"):
		var mouseposition = get_global_mouse_position();
		if mouseposition.x >= 256 and mouseposition.y <= 512:
			if modus== "Stift":
				for i in range( 0, pow(2,stiftgroesse)):
					for j in range(0, pow(2, stiftgroesse)):
						array[((mouseposition.x-256)/8)+(i-stiftgroesse)][(mouseposition.y/8)+(j-stiftgroesse)]= aktuelleFarbe;
				update();
			elif modus == "Linie":
				linienStart= mouseposition;
			elif modus == "Radierer":
				for i in range( 0, pow(2,stiftgroesse)):
					for j in range(0, pow(2, stiftgroesse)):
						array[((mouseposition.x-256)/8)+(i-stiftgroesse)][(mouseposition.y/8)+(j-stiftgroesse)]= null;
				update();
	elif Input.is_action_pressed("draw"):
		var mouseposition = get_global_mouse_position();
		if mouseposition.x >= 256 and mouseposition.y <= 512:
			if modus=="Linie":
				linienEnde = get_global_mouse_position();
				bresenham = false;
				update();
			elif modus=="Stift":
				for i in range( 0, pow(2,stiftgroesse)):
					for j in range(0, pow(2, stiftgroesse)):
						array[((mouseposition.x-256)/8)+(i-stiftgroesse)][(mouseposition.y/8)+(j-stiftgroesse)]= aktuelleFarbe;
				update();
			elif modus == "Radierer":
				for i in range( 0, pow(2,stiftgroesse)):
					for j in range(0, pow(2, stiftgroesse)):
						array[((mouseposition.x-256)/8)+(i-stiftgroesse)][(mouseposition.y/8)+(j-stiftgroesse)]= null;
				update();
	elif Input.is_action_just_released("draw"):
		var mouseposition = get_global_mouse_position();
		if mouseposition.x >= 256 and mouseposition.y <= 512:
			if modus=="Linie":
				linienEnde = get_global_mouse_position();
				bresenham = true;
				update();
	
	
	
func create_2d_array(width, height, value):
    var a = []

    for y in range(height):
        a.append([])
        a[y].resize(width)

        for x in range(width):
            a[y][x] = value

    return a

func speichern():
	var img;
	img = Image.new();
	img.create(arraylength, arraylength, false, Image.FORMAT_RGBA8);
	img.lock();
	for zeile in range(arraylength):
		for spalte in range(arraylength):
			if array[zeile][spalte] != null:
				img.set_pixel(zeile, spalte,array[zeile][spalte]);
			else:
				img.set_pixel(zeile, spalte,Color(0,0,0,1));
	img.unlock();
	var itex = ImageTexture.new()
	itex.create_from_image(img);
	get_node("../Sprite").texture= itex;

func _on_Button_pressed():
	speichern();
	


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
	for zeile in range(64):
		for spalte in range(32):
			if array[zeile][spalte] != null:
				hilfe =array[zeile][spalte];
				print(zeile)
				print( spalte)
				print(63-spalte);
				array[zeile][spalte] = array[zeile][(63-spalte)];
				array[zeile][(63-spalte)] = hilfe;
	update();


func _on_Farbe1_pressed():
	aktuelleFarbe = Color(0.07,0.93,0.06);



func _on_Farbe2_pressed():
	pass # Replace with function body.


func _on_Farbe3_pressed():
	pass # Replace with function body.


func _on_Farbe4_pressed():
	pass # Replace with function body.


func _on_Farbe5_pressed():
	pass # Replace with function body.


func _on_Farbe6_pressed():
	pass # Replace with function body.


func _on_Farbe7_pressed():
	pass # Replace with function body.


func _on_Farbe8_pressed():
	pass # Replace with function body.


func _on_Farbe9_pressed():
	pass # Replace with function body.


func _on_Farbe10_pressed():
	pass # Replace with function body.



func _on_klein_pressed():
	stiftgroesse= 0;


func _on_mittel_pressed():
	stiftgroesse= 1;


func _on_gro_pressed():
	stiftgroesse=2;


func _on_Button2_button_up():
	var bild = Image.new();
	bild.load("figur.png");
	print("da");
	bild.lock();
	#for zeile in range(63):
	#	for spalte in range(63):
	#		array[zeile][spalte]= bild.get_pixel(zeile,spalte); 
	bild.unlock();
	update();
	print("fertig");