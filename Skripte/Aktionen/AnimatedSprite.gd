extends AnimatedSprite

var persistenz = preload("res://Szenen/Spielverwaltung/Persistenz.tscn").instance()
"""
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
	"""
	
func _create_collision_polygon(var bildname):
	var i = 1
	while is_instance_valid(get_parent().get_node("Hitbox").get_child(i)):
		get_parent().get_node("Hitbox").get_child(i).queue_free()
		i = i+1
	
	var texture = persistenz.lade_bildtextur("res://Bilder/Standardspielfiguren/Spielfiguren/" + bildname + ".png")
	
	var bm = BitMap.new()
	bm.create_from_image_alpha(texture.get_data())
	var rect = Rect2(position.x, position.y, texture.get_width(), texture.get_height())
	var my_array = bm.opaque_to_polygons(rect, 0.00001)
	var my_polygon = Polygon2D.new()
	my_polygon.set_polygons(my_array)
	var offsetX = 0
	var offsetY = 0
	if (texture.get_width() % 2 != 0):
		offsetX = 1
	if (texture.get_height() % 2 != 0):
		offsetY = 1
	for i in range(my_polygon.polygons.size()):
		print(my_polygon.polygons.size())
		var my_collision = CollisionPolygon2D.new()
		my_collision.set_polygon(my_polygon.polygons[i])
		my_collision.position -= Vector2((texture.get_width() / 2) + offsetX, (texture.get_height() / 2) + offsetY) * scale.x
		my_collision.scale = scale 
		get_parent().get_node("Hitbox").call_deferred("add_child", my_collision)