
/*
VICTIM/PERP GENDER
 Jeff Thompson | 2013 | www.jefrreythompson.org
 
 Counts the # of victims and perpatrators that are male, female, and both.
 
 For an interesting historical comparison, see:
 http://en.wikipedia.org/wiki/Sex_differences_in_crime
 http://www.bjs.gov/content/pub/pdf/htus8008.pdf
 http://www.nyc.gov/html/nypd/html/analysis_and_planning/historical_nyc_crime_data.shtml
 
 For example, murders in the US:
 Perps (90% male, 10% female)
 Victims (75% male, 25% female)
 
 */


String[] data;
int victimMale, victimFemale, victimBoth;
int perpMale, perpFemale, perpBoth;
float numVictims = 0;
float numPerps = 0;

float malePerpMaleVictim = 0;
float malePerpFemaleVictim = 0;
float malePerpBothVictim = 0;

float femalePerpMaleVictim = 0;
float femalePerpFemaleVictim = 0;
float femalePerpBothVictim = 0;

float bothPerpFemaleVictim = 0;
float bothPerpMaleVictim = 0;
float bothPerpBothVictim = 0;


void setup() {

  String filename = sketchPath("") + "../Screenshots/EpisodeGender.csv";
  data = loadStrings(filename);
  victimMale = victimFemale = victimBoth = perpMale = perpFemale = perpBoth = 0;

  for (int i=2; i<data.length; i++) {          // skip header and notes at top
    String[] episode = split(data[i], ',');    // extract data
    if (episode.length < 4) continue;          // if all data not listed, skip

    String victimGender = episode[2];
    if (victimGender.equals("male")) {
      victimMale++;
      numVictims++;
    }
    else if (victimGender.equals("female")) {
      victimFemale++;
      numVictims++;
    }
    else if (victimGender.contains("both")) {
      victimMale++;
      victimFemale++;
      numVictims += 2;
    }     

    String perpGender = episode[3];
    if (perpGender.equals("male")) {
      perpMale++;
      numPerps++;
    }
    else if (perpGender.equals("female")) {
      perpFemale++;
      numPerps++;
    }
    else if (perpGender.contains("both")) {
      perpMale++;
      perpFemale++;
      numPerps += 2;
    }

    if (perpGender.equals("male") && victimGender.equals("male")) malePerpMaleVictim++;
    else if (perpGender.equals("male") && victimGender.equals("female")) malePerpFemaleVictim++;
    else if (perpGender.equals("male") && victimGender.equals("both")) malePerpBothVictim++;

    else if (perpGender.equals("female") && victimGender.equals("male")) femalePerpMaleVictim++;
    else if (perpGender.equals("female") && victimGender.equals("female")) femalePerpFemaleVictim++;
    else if (perpGender.equals("female") && victimGender.equals("both")) femalePerpBothVictim++;

    else if (perpGender.equals("both") && victimGender.equals("male")) bothPerpMaleVictim++;
    else if (perpGender.equals("both") && victimGender.equals("female")) bothPerpFemaleVictim++;
    else if (perpGender.equals("both") && victimGender.equals("both")) bothPerpBothVictim++;
  }

  println("VICTIMS");
  println("Male:        " + victimMale + " (" + nf((victimMale/numVictims) * 100, 1, 2) + "%)");
  println("Female:      " + victimFemale + " (" + nf((victimFemale/numVictims) * 100, 1, 2) + "%)");
  // println("Both:      " + victimBoth + " (" + nf((victimBoth/numVictims) * 100, 1,2) + "%)");

  println("\nPERPATRATORS");
  println("Male:        " + perpMale + " (" + nf((perpMale/numPerps) * 100, 1, 2) + "%)");
  println("Female:      " + perpFemale + " (" + nf((perpFemale/numPerps) * 100, 1, 2) + "%)");
  // println("Both:        " + perpBoth + " (" + nf((perpBoth/numPerps) * 100, 1,2) + "%)");

  println("\n- - - - - - - -\n");
  println("PERP\t\tMALE\t\t\tFEMALE\t\t\tBOTH");
  println("male\t\t" + int(malePerpMaleVictim) + " (" + nf((malePerpMaleVictim/numVictims) * 100, 1, 2) + "%)\t\t" + int(malePerpFemaleVictim) + " (" + nf((malePerpFemaleVictim/numVictims) * 100, 1, 2) + "%)\t\t" + int(malePerpBothVictim) + " (" + nf((malePerpBothVictim/numVictims) * 100, 1, 2) + "%)");
  println("female\t\t" + int(femalePerpMaleVictim) + " (" + nf((femalePerpMaleVictim/numVictims) * 100, 1, 2) + "%)\t\t" + int(femalePerpFemaleVictim) + " (" + nf((femalePerpFemaleVictim/numVictims) * 100, 1, 2) + "%)\t\t" + int(femalePerpBothVictim) + " (" + nf((femalePerpBothVictim/numVictims) * 100, 1, 2) + "%)");
  println("both\t\t" + int(bothPerpMaleVictim) + " (" + nf((bothPerpMaleVictim/numVictims) * 100, 1, 2) + "%)\t\t" + int(bothPerpFemaleVictim) + " (" + nf((bothPerpFemaleVictim/numVictims) * 100, 1, 2) + "%)\t\t" + int(bothPerpBothVictim) + " (" + nf((bothPerpBothVictim/numVictims) * 100, 1, 2) + "%)");

  // done!
  exit();
}

