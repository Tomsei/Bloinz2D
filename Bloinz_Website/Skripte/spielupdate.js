function resizeSpiel(hoehe, breite) {
    window.parent.resizeSpielParent(hoehe, breite);

}


function resizeSpielParent(hoehe, breite) {
            
    var spiel = document.getElementById("spiel");
    
    spiel.height = hoehe + 'px';
    spiel.width = breite + 'px';           
}

