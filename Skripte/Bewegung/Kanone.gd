extends KinematicBody2D

signal kanoneberuehrt

#Kanonen Bewegung
var speed = 150
var Bewegung = Vector2(0,0)
var hoehe = 474
var richtungRechts = false

var screen_size


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	if randi() % 2 == 1:
		kanoneRechts()
		richtungRechts = true
		print("rechts")
	else:
		KanoneLinks()
		print("links")
		
	position.y = hoehe






func _physics_process(delta):
	if richtungRechts:
		bewegungrechts()
	else:
		bewegunglinks()

func kanoneRechts():
	position.x = -50 #negativ damit die Kanone in das Bild rein fliegt

func KanoneLinks():
	position.x = screen_size.x + 50 #damit sie von der Seite rein fliegt



func bewegungrechts():
	Bewegung.x = speed
	print(Bewegung.x)
	move_and_slide(Bewegung)
	$Sprite.flip_h = true
	if is_on_wall() and position.x > screen_size.x:
		queue_free()

	
func bewegunglinks():
	Bewegung.x = -speed
	move_and_slide(Bewegung)
	$Sprite.flip_h = false
	if is_on_wall() and position.x < 200:
		queue_free()


func blobKollision():
	emit_signal("kanoneberuehrt")
	queue_free()

