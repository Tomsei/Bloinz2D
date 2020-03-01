extends "res://Skripte/Aktionen/Muenze/Muenze.gd"
"""
Szene / Klasse für alle guten Coins
Beinhaltet alle Methoden (ausgelöst durch Random) die für
beide badCoin Klassen benötigt werden also der Schutz vor Bad Coins

Erbt die Methoden und Variablen von der Super Klasse muenze
"""



"""
Methode um Badcoin vom Regenschirm verschwinden zu lassen
"""
func blockiereMuenze():
	queue_free()