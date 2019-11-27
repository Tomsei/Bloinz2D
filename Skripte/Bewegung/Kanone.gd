extends KinematicBody2D

signal kanoneberuehrt

var speed = 150
var Bewegung = Vector2(0,0)



var screen_size
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	position.x = 0
	position.y = 607
	

	

func _physics_process(delta):
	bewegungrechts()


func bewegungrechts():
	Bewegung.x = speed
	move_and_slide(Bewegung)
	$Sprite.flip_h = true
	if is_on_wall() and position.x > 200:
		queue_free()
	
	

	
func bewegunglinks():
	Bewegung.x = -speed
	move_and_collide(Bewegung)
	$Sprite.flip_h = false
	if is_on_wall() and position.x < 200:
		queue_free()


func blobKollision():
	emit_signal("kanoneberuehrt")
	queue_free()

