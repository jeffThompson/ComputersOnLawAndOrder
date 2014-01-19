
#include <CapacitiveSensor.h>

/*
 AUTOMATIC SCREEN-CAPTURE BUTTON
 Jeff Thompson | 2013 | www.jeffreythompson.org
 
 Simple touch sensor for capturing screenshots in VLC - uses the Capacitive Sensor
 library (http://playground.arduino.cc//Main/CapacitiveSensor).
 
 Created for a project commissioned by Rhizome.org (thanks!)
 
 SCHEMATIC:
 |----------------------------------------------------
 D10  --- 1k ----|---
 |      both ends attached under/soldered to a piece of copper tape
 D11  --- 10M ---|---
 |----------------------------------------------------
 
 For further details, see the build-log.
 */

int threshold = 300;             // value at which the button is considered pressed/on
int interval = 200;              // number of reading the CapSense averages
int wait = 1000;                 // ms to wait after a hit to look again (prevents retriggering)

CapacitiveSensor cs = CapacitiveSensor(11,10);   // 1k protection resistor on pin 11, 10M sensing resistor on pin 10
int ledPin = 13;                                 // led connected from pin 13 to ground (or internal led)

boolean capturing = false;       // are we currently capturing in the Processing app?
boolean buttonState = false;     // on/off button state
boolean prevState = false;       // previous (for sensing edge)


void setup() {
  pinMode(ledPin, OUTPUT);       // set led pin to output
  Serial.begin(9600);            // start serial communication
}

void loop() {

  if (Serial.available() > 0) {
    int b = Serial.read();
    if (b == '1') {
      capturing = true;
    }
    else if (b == '0') {
      capturing = false;
    }
  }
  
  // read sensor only if we're not capturing in the Processing app
  if (!capturing) {
    long val =  cs.capacitiveSensor(interval);    // read touch sensor

    // if above the threshold, set as on; if not, set as off
    if (val >= threshold) {
      buttonState = true;
    }
    else {
      buttonState = false;
    }

    // set led high or low if the state of the button has changed
    // we don't just do this every time, as it would cause flickering
    if (buttonState != prevState) {        // if different....
      if (buttonState == true) {           // and true...
        digitalWrite(ledPin, HIGH);        // set high/on
        Serial.print(1);                   // and send a 1 over USB
      }
      else {                               // ditto low
        digitalWrite(ledPin, LOW);
      }      
      prevState = buttonState;
    }

    // a short delay to prevent overload (especially for
    // sending data via serial connection)
    delay(10);
  }
}


