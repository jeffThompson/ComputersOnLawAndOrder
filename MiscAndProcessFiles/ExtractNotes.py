
'''
EXTRACT SOME DATA FROM NOTES
Jeff Thompson | 2014 | www.jeffreythompson.org

Extracts some data from my 'Notes' file.
'''

import csv, re

no_computers = []
urls = []
firsts = []
quotes = []
everything_else = []

with open('../EpisodeNotes.csv', 'rb') as file:
	reader = csv.reader(file)
	for data in reader:
		s = data[0]
		e = data[1]
		
		for i in range(2, len(data)):
			d = data[i].strip()						# remove extra spaces
			
			# ignore 'no computers!
			if d == 'no computers!':
				no_computers.append(s + ', ' + e + ', ' + d)
			
			elif d.endswith('.com') or d.endswith('.org') or d.endswith('.net') or d.endswith('.bz'):
				urls.append (s + ', ' + e + ', ' + d)
			
			# get instances of firsts
			elif d.startswith('first'):
				# firsts.append(s + ', ' + e + ', ' + d)
				firsts.append(d + ' (' + s + ', ' + e + ')')
			
			# get quotes
			elif d.startswith('*'):			  # a hack added to the original file, since we can't keep quotes when parsing
				if d.endswith('.') or d.endswith('!') or d.endswith('?'):
					# quotes.append(s + ', ' + e + ', "' + d[1:] + '"')
					quotes.append('"' + d[1:] + '" (' + s + ', ' + e + ')')
				else:
					# quotes.append(s + ', ' + e + ', "' + d[1:] + '."')
					quotes.append('"' + d[1:] + '." (' + s + ', ' + e + ')')		# fix missing punctuation

			# get everything else
			else:
				everything_else.append(s + ', ' + e + ', ' + d)

# what did you find?
print '\n\n\n'

print 'NO COMPUTERS (' + str(len(no_computers)) + '):'
for none in no_computers:
	print none

print '\n\n\n'

''' ignored - missing a few
print 'URLs (' + str(len(urls)) + '):'
for url in urls:
	print url

print '\n\n\n'
'''

print 'FIRSTS (' + str(len(firsts)) + '):'
for first in firsts:
	print first

print '\n\n\n'

print 'QUOTES (' + str(len(quotes)) + '):'
for quote in quotes:
	print quote

print '\n\n\n'

print 'EVERYTHING ELSE (' + str(len(everything_else)) + '):'
for other in everything_else:
	print other

print '\n\n\n'

