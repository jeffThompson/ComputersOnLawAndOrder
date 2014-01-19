
import java.io.File;    // required for file parsing

/*
 COMPUTER COUNT
 Jeff Thompson | 2013 | www.jeffreythompson.org
 
 Counts the # of screenshots... so not really the # of computers,
 but a good approximation. Divides by 5 (the # of screenshots per
 sighting).
 
 */

int[] computerCount = new int[21];
int[] noComputerCount = new int[21];
int mostComputers = 0;
int mostSeason = 0;
int mostEpisode = 0;


void setup() {

  File mainDir = new File(sketchPath("") + "../Screenshots");
  String notesFile = sketchPath("") + "../Screenshots/EpisodeNotes.csv";

  // get # of screenshots for each episode
  File[] episodes = mainDir.listFiles();
  for (File f : episodes) {
    if (f.isDirectory()) {                                // if a directory (folder of screenshots)
      String[] s = match(f.getName(), "S([0-9].*?)E");    // extract season from folder name (S*E*)
      String[] e = match(f.getName(), "E(.*?)\\b");       // get episode # too
      
      if (s != null && e != null) {                       // if a match (a folder of screenshots)
        int season = Integer.parseInt(s[1]);              // convert season match to integer        
        int episode = Integer.parseInt(e[1]);             // ditto episode
        int numComputers = f.listFiles().length;          // get # of computers

        computerCount[season] += numComputers;            // add to count
        
        // check if record # of computers
        if (f.listFiles().length > mostComputers) {
          mostSeason = season;
          mostEpisode = episode;
          mostComputers = numComputers + 1;               // +1 for some reason, oh well... 
        }
      }
    }
  }

  // get all instances of "no computers!" in the notes file
  String[] notes = loadStrings(notesFile);
  for (int i=0; i<notes.length; i++) {
    if (notes[i].contains("no computers!")) {
      String[] splitData = split(notes[i], ",");
      int season = Integer.parseInt(splitData[0]);    // extract season #
      noComputerCount[season] += 1;
    }
  }

  // iterate the count results and print
  println("# OF COMPUTERS PER SEASON");
  println("\nseason\tcount\tw/ no comps");
  int total = 0;
  for (int i=1; i<computerCount.length; i++) {
    println(i + ":\t" + (computerCount[i]/5) + "\t" + noComputerCount[i]);    // div by 5 since we take 5 screenshots per sighting
    total += computerCount[i]/5;
  }

  // averages
  println("\nAverage of " + (total/20) + " computers per season");
  println("Average of " + (total/456) + " computers per episode");

  // no computers
  int noComputersTotal = 0;
  for (int i=0; i<noComputerCount.length; i++) noComputersTotal += noComputerCount[i];
  println("Episodes with no computers: " + noComputersTotal);

  // most computers
  println("\nMost computers: " + (mostComputers/5) + " (season " + mostSeason + ", episode " + mostEpisode + ")");

  // all done!
  exit();
}

