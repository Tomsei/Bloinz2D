# Godot mit Bloinz 2D einrichten

## Godot herunterladen

Godot von [hhtps://godotengine.org/download](https://godotengine.org/download/) herunterladen und entpacken.
Hierzu reicht die 'Standard Version' aus.

## Projekt klonen und in Godot öffnen

### Projekt klonen

Als erstes per Konsole zum gewünschtem Ziel navigieren.
In der git Konsole

`git clone git@projectbase.medien.hs-duesseldorf.de:dahm/godot-tutorial.git`

eingeben.
Nach dem login ist das Projekt nun mit dem Ordner `godot-tutorial` vorhanden. Jetzt in das verzeichnis wechseln.
Zum Entwickeln ist es Sinnvoll in den develop branch zu wechseln.
Hierzu

`git checkout develop`

eingeben.

Jetzt sollte das Projekt mit seiner Ordnerstruktur vorhanden sein.

### Projekt in Godot öffnen

Godot öffnen. Hier sollte man mit der Projektverwaltung begrüßt werden. Ist das nicht der Fall kann man diese über "Projekt -> Verlasse zur Projektverwaltung" aufrufen.
Hier gibt es zwei Möglichkeiten das Projekt zu importieren.

1. Die wohl einfachste Methode ist nach dem Projekt zu scannen.
    Hierzu wählt man rechts den Punkt Scannen aus. Wählt dann einen Übergeordneten Ordner aus und klickt dann unten auf "Diesen Ordner auswählen". Danach erscheint das Projekt mit dem Namen "Bloinz 2D" und dem Projektpfad in der Projektliste.

    ![Projekt_scannen](https://projectbase.medien.hs-duesseldorf.de/dahm/godot-tutorial/wikis/uploads/9c83019da2cf56576d0ea1c12d1841d2/Projekt_scannen.png)

2. Bei der anderen Variante geht man über den Punkt "Import".
    Im Dialog klickt man auf die Schaltfläche "Durchsuchen" und navigiert zum Projektordner. Hier wählt man die Datei `project.godot`. Hat man alles richtig gemacht erscheint ein grüner Haken neben dem Pfad. Nach klick auf "Importieren & Bearbeiten" erscheint das Projekt in der Projektliste.

    ![Projekt importieren](https://projectbase.medien.hs-duesseldorf.de/dahm/godot-tutorial/wikis/uploads/9c83019da2cf56576d0ea1c12d1841d2/Projekt_scannen.png)