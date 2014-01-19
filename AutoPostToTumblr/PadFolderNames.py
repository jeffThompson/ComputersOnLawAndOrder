
'''
PAD FOLDER NAMES
Jeff Thompson

Utility to rename folders with leading 0s.
'''

import os, re

input_folder = '/Users/JeffThompson/Documents/ComputersOnLawAndOrder/FinalScreenshotsToPost'

for f in os.listdir(input_folder):
	if not f.startswith('.'):
		season = re.findall(r'S(.*?)E', f)[0]
		episode = re.findall(r'E(.*)', f)[0]
		
		new_filename = 'S' + season.zfill(3) + 'E' + episode.zfill(3)
		print new_filename
		os.rename(input_folder + '/' + f, input_folder + '/' + new_filename)