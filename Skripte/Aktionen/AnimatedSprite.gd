extends AnimatedSprite

var persistenz = preload("res://Szenen/Spielverwaltung/Persistenz.tscn").instance()

#Berechnet die Collision Polygone für den Spieler
func _create_collision_polygon(var bildname):
	
	print("neues Polygon")
	
	var texture = persistenz.lade_bildtextur("res://Bilder/Standardspielfiguren/Spielfiguren/" + bildname + ".png")
	
	var bm = BitMap.new()
	bm.create_from_image_alpha(texture.get_data())	
	var rect = Rect2(position.x, position.y, texture.get_width(), texture.get_height())
	var my_array = bm.opaque_to_polygons(rect)

	var my_polygon = Polygon2D.new()
	my_polygon.set_polygons(my_array)
	
	var polygon_Area = my_polygon
	get_parent().get_node("physischeKollisionBox").set_polygon(my_polygon.polygons[0])
	get_parent().get_node("Hitbox/areaKollisionBox").set_polygon(polygon_Area.polygons[0])