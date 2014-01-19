
# RESOLUTION GRAPH
# Jeff Thompson | 2013 | www.jeffreythompson.org
#
# How have DVD resolutions changed over the 20 seasons
# of "Law & Order"? Answer: not much...

from __future__ import division		# force floating point division for aspect ratio
import os													# for file iteration
from PIL import Image							# for image size
import locale											# number formatting with commas
from fractions import Fraction		# for getting aspect ratio

print '\n'

# where to find folders/images
directory = "/Users/JeffThompson/Documents/Processing/AutomaticScreencapture/Screenshots"

# commas for separator
# via: http://stackoverflow.com/a/1823101/1167783
locale.setlocale(locale.LC_ALL, 'en_US')

# look through folders, store image's details
season = 1
resolutions = []

for subdir in os.listdir(directory):
	if ('S' + str(season)) in os.path.basename(subdir):					# if folder starts with 'S' (ignores other files)
		for f in os.listdir(directory + '/' + subdir):						# look inside each season folder
			if f[0] == '.':																					# ignore hidden files like .DS_Store
				continue
			img = Image.open(directory + '/' + subdir + '/' + f)		# get image
			w = img.size[0]																					# store image's dimensions
			h = img.size[1]
			ratio = Fraction(w,h)																		# ... and aspect ratio
			area = w * h																						# and area
			resolutions.append([season, w, h, ratio, area])					# store as a list
			break																										# skip ahead (so we don't list EVERY episode)
		season += 1																								# move to the next season

#print results!
print 'season:\t\tdimensions\tratio\t\tarea'		# header
for s in resolutions:
	print str("%02d" % s[0]) + ':\t\t' + str(s[1]) + ' x ' + str(s[2]) + '\t' + str(s[3]) + '\t\t' + locale.format("%d", s[4], grouping=True) + ' px/sq'
	
print '\n'