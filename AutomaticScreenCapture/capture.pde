
// capture routine using the robot class - essentially
// simulates keyboard events inside VLC

void capture() {
  
  // set focus to VLC
  try {
    String[] params = { "open", "/Users/JeffThompson/Applications/VLC.app" };
    Process process = Runtime.getRuntime().exec(params);
    process.waitFor();
  }
  catch (Exception e) {
    //
  }

  // tell Arduino we're capturing (helps prevent retriggering)
  serialPort.write('1');    // send 1 as a char to know we're capturing
  print("Capturing:    ");

  // pause
  robot.keyPress(KeyEvent.VK_SPACE);
  robot.keyRelease(KeyEvent.VK_SPACE);
  delay(pause);

  // capture various frames
  for (int i=0; i<numFrames; i++) {

    print(i+1 + "  ");                   // current frame being captured

    // take screenshot
    robot.keyPress(KeyEvent.VK_META);    // command
    robot.keyPress(KeyEvent.VK_ALT);     // option (alt)
    robot.keyPress(KeyEvent.VK_S);       // 's'

    robot.keyRelease(KeyEvent.VK_S);     // release keys or bad things happen!
    robot.keyRelease(KeyEvent.VK_ALT);
    robot.keyRelease(KeyEvent.VK_META);
    delay(pause);

    // next frame
    robot.keyPress(KeyEvent.VK_E);
    robot.keyRelease(KeyEvent.VK_E);
    delay(pause);
  }

  // play again
  robot.keyPress(KeyEvent.VK_SPACE);
  robot.keyRelease(KeyEvent.VK_SPACE);

  // tell Arduino we're done capturing
  serialPort.write('0');    // send 0 as a char to know we're done
  print("DONE!\n");
}

