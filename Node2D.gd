extends Node2D


var array;
var arraylength=128;
var aktuelleFarbe;
var modus;
var linienStart;
var linienEnde;
var bresenham;


# Called when the node enters the scene tree for the first time.
func _ready():
	array = create_2d_array(arraylength, arraylength, null);
	aktuelleFarbe = Color(1,1,1,1);
	get_node("../ColorPickerButton").color = Color(1,1,1,1);
	

func _draw():
	for zeile in range(0, arraylength):
		for spalte in range(0, arraylength):
			if array[zeile][spalte] != null:
				var color = PoolColorArray( [array[zeile][spalte]] );
				var zeilegross = zeile*4;
				var spaltegross = spalte*4;
				var point1 = PoolVector2Array([Vector2(zeilegross,spaltegross)]);
				var point2 = PoolVector2Array([Vector2(zeilegross+1,spaltegross)]);
				var point3 = PoolVector2Array([Vector2(zeilegross,spaltegross+1)]);
				var point4 = PoolVector2Array([Vector2(zeilegross+1,spaltegross+1)]);
				var point5 = PoolVector2Array([Vector2(zeilegross+2,spaltegross)]);
				var point6 = PoolVector2Array([Vector2(zeilegross+2,spaltegross+1)]);
				var point7 = PoolVector2Array([Vector2(zeilegross+1,spaltegross+2)]);
				var point8 = PoolVector2Array([Vector2(zeilegross+2,spaltegross+2)]);
				var point9 = PoolVector2Array([Vector2(zeilegross,spaltegross+2)]);
				var point10 = PoolVector2Array([Vector2(zeilegross+3,spaltegross+1)]);
				var point11 = PoolVector2Array([Vector2(zeilegross+1,spaltegross+3)]);
				var point12 = PoolVector2Array([Vector2(zeilegross,spaltegross+3)]);
				var point13 = PoolVector2Array([Vector2(zeilegross+3,spaltegross)]);
				var point14 = PoolVector2Array([Vector2(zeilegross+2,spaltegross+3)]);
				var point15 = PoolVector2Array([Vector2(zeilegross+3,spaltegross+2)]);
				var point16 = PoolVector2Array([Vector2(zeilegross+3,spaltegross+3)]);
				draw_primitive (point1,color, PoolVector2Array() );
				draw_primitive (point2,color, PoolVector2Array() );
				draw_primitive (point3,color, PoolVector2Array() );
				draw_primitive (point4,color, PoolVector2Array() );
				draw_primitive (point5,color, PoolVector2Array() );
				draw_primitive (point6,color, PoolVector2Array() );
				draw_primitive (point7,color, PoolVector2Array() );
				draw_primitive (point8,color, PoolVector2Array() );
				draw_primitive (point9,color, PoolVector2Array() );
				draw_primitive (point10,color, PoolVector2Array() );
				draw_primitive (point11,color, PoolVector2Array() );
				draw_primitive (point12,color, PoolVector2Array() );
				draw_primitive (point13,color, PoolVector2Array() );
				draw_primitive (point14,color, PoolVector2Array() );
				draw_primitive (point15,color, PoolVector2Array() );
				draw_primitive (point16,color, PoolVector2Array() );
	
	linie_malen();
	if modus=="Linie":
		if bresenham == true:
			pass;
		else:
			draw_line(linienStart, linienEnde, Color(1,1,1));
	#	linie_malen();
	


func linie_malen():
	draw_primitive( PoolVector2Array([Vector2(303,303)]), PoolColorArray( [Color(1,1,1)]), PoolVector2Array());

func punkt_malen():
	pass;

func _process(delta):
	if Input.is_action_just_pressed("draw"):
		var mouseposition = get_global_mouse_position();
		if mouseposition.x >= 256:
			if modus== "Stift":
				array[(mouseposition.x-256)/4][mouseposition.y/4]= aktuelleFarbe;
				update();
			elif modus == "Linie":
				linienStart= mouseposition;
	elif Input.is_action_pressed("draw"):
		if modus=="Linie":
			linienEnde = get_global_mouse_position();
			bresenham = false;
			update();
	elif Input.is_action_just_released("draw"):
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
