
# RENAME FILES
# whoops, fix mis-named files

import os
import re

# what it was
wrongEpisode = "Sideshow__Part_1"		# spaces should be listed as _

# what it should be
season = 9
episodeNumber = 195
episodeName = "Sideshow"

directory = "/Users/JeffThompson/Documents/Processing/AutomaticScreencapture/Screenshots/S9E195/"

for f in os.listdir(directory):
	if wrongEpisode in f:
		p = re.compile(wrongEpisode + '-([0-9].*?)\.png')
		m = re.findall(p, f)
		filename = "LawAndOrder-Season" + str(season) + "-Episode" + str(episodeNumber) + "-" + episodeName + "-" + m[0] + ".png"
		os.rename(directory + f, directory + filename)
		print filename