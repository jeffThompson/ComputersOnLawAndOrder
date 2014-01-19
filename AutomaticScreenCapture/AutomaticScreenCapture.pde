
import java.awt.Robot;               // "robot" and screencapture
import java.awt.AWTException;
import java.awt.event.KeyEvent;
import java.awt.Frame;
import processing.serial.*;          // for connection to Arduino
import java.io.File;

/*
AUTOMATIC SCREENCAPTURE
 Jeff Thompson | 2012-14 | www.jeffreythompson.org
 
 Created as part of a commission by Rhizome.org (a big 'thank you!')
 
 Automatically takes control of VLC using a single button connected
 to an Arduino (for source code and schematic, see the 'ArduinoCode' tab).
 
 Works by pausing your movie, takes a screenshot, advances by N frames
 (taking screenshots along the way), and starts the movie again!
 
 This sketch uses the Java AWT 'robot' class, which allows you to
 create virtual keystrokes (automatic keyboard shortcuts in VLC).
 
 CHANGE VLC COMMANDS:
 Depending on how you want to format your screenshots, you may want to
 change settings in VLC (VLC > Preferences > Video...). Note: you will
 likely have to restart VLC for these changes to take effect.
 
 Filename settings: LawAndOrder-$T- (with 'sequential numbering' checked)
 $T = time in the file as HH_MM_SS
 
 Note: newer versions of VLC (2.1+) seem to be broken
 for saving with variables like this... :( 
 
 Example resulting filename:
 LawAndOrder-00_01_27-0001.png
 
 This filename is renamed on exit to:
 01Season_01Episode_00h40m32s_0001.png
 
 A list of variables for screenshot formatting can be found at:
 http://wiki.videolan.org/Documentation:Play_HowTo/Format_String
 
 */

int season = 20;
int episode = 456;

int numFrames = 5;                         // how many frames to automatically capture
int pause = 500;                           // time between pause/next-frame events (ms)
boolean fastjump = false;                  // jump lots of frames (default off)
int keyIn = 49;                            // value to look for, starts capture process (#1 = 49 in ascii)
boolean minify = false;                    // automatically minimize when opened?
boolean renameOnExit = true;               // rename files on exit (suggested)
String screenshotFolder = "Screenshots";   // folder where screenshots are stored

boolean captureIt = false;                 // flag for running screencapture
boolean serialConnected = false;           // is there something connected to the serial port?
Robot robot;                               // robot object for virtual keyboard
Serial serialPort;                         // serial object for communication with Arduino
String portName;                           // serial port when initializing
NumberBox numberBox;                       // custom number box object to change the number of frames

String episodeNameForDisplay, episodeNameForFile;    // episode name for onscreen and file
PFont headlineFont, detailsFont, numberFont;         // fonts for UI

void setup() {

  // basic setup
  size(620, 200);    // 950 with the full text onscreen
  smooth();
  frame.setTitle("Automatic Screen Capture");

  // fonts
  headlineFont = loadFont("LetterGothicStd-48.vlw");
  detailsFont = loadFont("LetterGothicStd-14.vlw");
  numberFont = loadFont("LetterGothicStd-72.vlw");

  // create robot and serial objects
  try {
    robot = new Robot();
  }
  catch (AWTException e) {
    println("Couldn't create robot...");
  }

  try {
    println(Serial.list());
    portName = Serial.list()[5];    // with Arduino 1.0 and/or Processing 2.1, this might not be 0 any more
    serialPort = new Serial(this, portName, 9600);
    serialConnected = true;
  }
  catch (Exception e) {
    println("Error creating serial connection - perhaps no device connected?");
  }

  // numberBox for # of frames (arguments are x/y position)
  numberBox = new NumberBox(35, 5);
  numberBox.y = (height - numberBox.h) / 2;    // center vertically
  numberBox.printNumFrames();                  // let us know how many frames will be captured

  // rename files on exit (helps prevent problems of file overwriting, etc)
  if (renameOnExit) {
    File parentFolder = new File(sketchPath("")).getParentFile();
    screenshotFolder = parentFolder.getAbsolutePath() + "/" + screenshotFolder + "/";
    prepareExitHandler();    // prepare our exit handler
  }

  String[] episodeList = loadStrings("SeasonAndEpisodeList.csv");
  episodeNameForFile = "";
  for (int i=1; i<episodeList.length; i++) {          // skip header
    String[] details = split(episodeList[i], ",");
    if (Integer.parseInt(details[0]) == season && Integer.parseInt(details[1]) == episode) {
      String episodeName = details[2];

      // add commas - a hand-done hack for lazy CSV programming
      if (episodeName.equals("By Hooker By Crook")) episodeName = "By Hooker, By Crook";
      else if (episodeName.equals("Baby It's You")) episodeName = "Baby, It's You (Part 1)";
      else if (episodeName.equals("Black White and Blue")) episodeName = "Black, White and Blue";
      else if (episodeName.equals("America Inc")) episodeName = "America, Inc";
      else if (episodeName.equals("Sideshow")) episodeName = "Sideshow, Part 1";

      episodeNameForDisplay = episodeName;
      episodeNameForFile = episodeName.replaceAll("\\W", "_");                  
      break;
    }
  }

  // open some related folders and files - just makes things a little easier :)
  try {

    // open folder
    String[] params = {
      "open", "/Users/JeffThompson/Documents/Processing/AutomaticScreencapture/Screenshots"
    };
    Runtime.getRuntime().exec(params);

    // open notes and gender list
    params[1] = "/Users/JeffThompson/Documents/Processing/AutomaticScreencapture/Screenshots/EpisodeNotes.csv";
    Runtime.getRuntime().exec(params);  
    params[1] = "/Users/JeffThompson/Documents/Processing/AutomaticScreencapture/Screenshots/EpisodeGender.csv";
    Runtime.getRuntime().exec(params);

    // wait a moment for text editor to load (otherwise it appears on top - a hack, boo)
    delay(500);

    // set focus to VLC (or open, if not already)
    params[1] = "/Users/JeffThompson/Applications/VLC.app";
    Runtime.getRuntime().exec(params);
  }
  catch (Exception e) {
    println(e);
  }
}


void draw() {

  // if an Arduino is connected via serial (usb), run as usual
  if (serialConnected) {

    // print text and check number box
    textDetails();
    numberBox.checkState();
    numberBox.display();

    // read serial port for a button pressed
    if (serialPort.available() > 0 && captureIt == false) {   // is there a byte waiting to be received?
      int val = serialPort.read();                            // yes? read it
      if (val == keyIn ) captureIt = true;                    // if it's the one we're looking for, do your thing!
    }

    // run capture routine
    if (captureIt) {
      capture();
      captureIt = false;
    }
  }

  // if we couldn't connect to a serial device (the Arduino), try again and let us know 
  else {
    try {
      portName = Serial.list()[0];
      serialPort = new Serial(this, portName, 9600);
      serialConnected = true;
    }
    catch (Exception e) {
      noSerialText();        // if it doesn't work again, show a text saying so
    }
  }
}

// keypress > number change
void keyPressed() {
  if (numberBox.active) numberBox.changeValue(key);
}

// end serial communication on exit
public void dispose() {
  serialPort.clear();
  serialPort.stop();
}

