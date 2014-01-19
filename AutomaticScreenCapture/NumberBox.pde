
// custom number box - sets the number of frames captured
// each time the button is pressed; looks for keypress
// on the box, allows typing/delete

class NumberBox {

  int x, y, w, h;
  boolean active;
  int value;

  boolean blinkState = true;  
  long prevTime;

  NumberBox(int _x, int _y) {
    x = _x;
    y = _y;

    textFont(numberFont, 72);
    w = int(textWidth("888") + 15);
    h = int(textAscent() + 30);

    value = numFrames;    // set to default value (5)
  }

  void checkState() {

    // clicked on - make active!
    if (active == false && mousePressed && mouseX >= x && mouseX <= x+w && mouseY >= y && mouseY <= y+h) {
      active = true;
      prevTime = millis();  // for cursor blink
    }

    // deselect and set value
    else if (active && mousePressed) {
      if (mouseX < x || mouseX > w || mouseY < y || mouseY > y+h) {
        numFrames = value;
        printNumFrames();
        active = false;
      }
    }
  }

  void changeValue(char c) {
    String currentValue = Integer.toString(value);
    String v = str(c);

    // if delete key is pressed...
    if (int(c) == 8) {
      if (currentValue.length() > 1) {
        currentValue = currentValue.substring(0, currentValue.length()-1);
      }
      else if (currentValue.length() == 1) {
        currentValue = "0";
      }
      value = Integer.parseInt(currentValue);
    }

    // if enter/return, set value and deselect button...
    if (int(c) == 10) {
      numFrames = value;
      printNumFrames();
      active = false;
    }

    // if number keys are pressed...
    String numbers = "0123456789";
    if (numbers.contains(v) && currentValue.length() < 3) {      // if a number and 999 or less
      currentValue += v;
      value = Integer.parseInt(currentValue);
    }
  }

  void display() {

    // main box
    if (active) {
      fill(200);
    }
    else {
      fill(100);
    }
    stroke(255);
    rect(x, y, w, h);

    // triangle
    int triSize = 8;
    fill(255, 166, 0);
    noStroke();
    triangle(x+1, y+h/2+triSize, x+1, y+h/2-triSize, x+1+triSize, y+h/2);

    // number of frames
    textAlign(LEFT, BASELINE);
    textFont(numberFont, 72);
    fill(255);
    text(value, x+7, y+h-15);

    // position indiacation line
    if (active) {
      blinkCursor(500);    // argument is the blink rate (ms)
    }

    // caption below
    fill(255);
    textFont(detailsFont, 14);
    text("# of frames", x, y + h + 25);
  }

  void printNumFrames() {
    println("# frames to be captured: " + numFrames);
  }

  void blinkCursor(int blinkInterval) {
    if (millis() >= prevTime + blinkInterval) {    // if enough time has passed
      blinkState = !blinkState;                    // switch on/off
      prevTime = millis();                         // set current time for next blink
    }

    // if on, blink!
    if (blinkState == true) {
      stroke(255);
      line(x + textWidth(str(value)) + 7, y+8, x + textWidth(str(value)) + 7, y+h-8);
    }
  }
}

