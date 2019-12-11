extends "res://Skripte/Bewegung/Muenze/Muenze.gd"







func muenzMagnet(var xPosSpieler):
	
	var differenz = xPosSpieler - position.x
	
	var bewegung = (differenz / bodenhoehe)*1000
	
	if xPosSpieler < position.x:
		Bewegung.x = bewegung
	elif xPosSpieler > position.x:
		Bewegung.x = bewegung
	else:
		Bewegung.x = 0