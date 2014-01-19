
'''
COPY TAGGED FILES
Jeff Thompson | 2014 | www.jeffreythompson.org

'''

from re import findall
import os
from shutil import copy

input_filename = '/Users/JeffThompson/Documents/Processing/AutomaticScreencapture/BestLawAndOrderScreenshots.txt'
output_directory = '/Users/JeffThompson/Desktop/FinalScreenshotsToPost'
errors = []

# iterate and do your magic
with open(input_filename) as file_list:
	for i, file in enumerate(file_list):
		
		# clean up
		print i
		file = file.strip()
		print file
		
		# extract season/episode
		season_episode = findall(r'Screenshots/(.*?)/LawAndOrder', file)
		season = findall(r'S(.*?)E', season_episode[0])[0]
		episode = findall(r'E(.*?)\b', season_episode[0])[0]
		print '  S ' + season + ', E ' + episode
		
		# create directory, if needed
		directory = output_directory + '/S' + season + 'E' + episode
		if not os.path.exists(directory):
			os.makedirs(directory)
		
		# copy file
		try:
			copy(file, directory)
			print '  copied successfully!'
		except IOError:
			errors.append(file)
			print '  error copying file...'
		
		# spacer
		print ''

# list any errors we had
print '\n- - - - - - - - -\n\nERRORS:'
if len(errors) == 0:
	print '  no errors!'
else:
	for error in errors:
		print '  ' + str(error)

# done!