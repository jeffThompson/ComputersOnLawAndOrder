
// if no Arduino is connected - let us know...

void noSerialText() {
  background(0);
  
  fill(255);
  textAlign(LEFT, CENTER);
  
  textFont(headlineFont, 48);
  text("NO USB DEVICE FOUND", 30, 90);
  
  textFont(detailsFont, 12);
  text("Sorry! Perhaps the button is disconnected?", 30, 130);
  
}
