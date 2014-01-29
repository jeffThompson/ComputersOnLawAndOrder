import os, re

full_path = '/Users/JeffThompson/Documents/ComputersOnLawAndOrder/FinalScreenshotsToPost'

for file in os.listdir(full_path):
	if not file.startswith('.'):
		print file
		season = int(re.findall(r'S(.*?)E', file)[0])				# S001E001
		episode = int(re.findall(r'E(.*)', file)[0])
		new_filename = 'S' + str(season) + 'E' + str(episode)
		print '  ' + 'renaming to ' + new_filename
		try:
			os.rename(full_path + '/' + file, full_path + '/' + new_filename)
			print '  ' + 'Success!' + '\n'
		except:
			print '  ' + 'ERROR!' + '\n'

print '\n' + 'ALL DONE!'
			