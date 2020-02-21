extends TileMap

var persistenz = preload("res://Szenen/Spielverwaltung/Persistenz.tscn").instance();

# Called when the node enters the scene tree for the first time.
func _ready():
	lade_Tilemap();

func lade_Tilemap():
	var id = tile_set.find_tile_by_name("Hintergrund.png 11");
	var textur = persistenz.lade_bildtextur("res://Bilder/Standardspielfiguren/Hintergrund/Hintergrund.png");
	tile_set.tile_set_texture(id,textur);
