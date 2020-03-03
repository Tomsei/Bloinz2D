extends "res://Skripte/Aktionen/Muenze/Muenze.gd"

#Szene / Klasse für alle schlechten Coins
#Beinhaltet alle Methoden  die für #beide badCoin Klassen benötigt werden 
#also die Möglichkeit das Bad COin verschwinden wenn sie den Schutz berühren

#Erbt die Methoden und Variablen von der Super Klasse muenze


#Methode um Badcoin vom Regenschirm verschwinden zu lassen
func blockiereMuenze():
	queue_free()