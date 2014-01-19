
'''
AUTO POST TO TUMBLR
Jeff Thompson | 2013-14 | www.jeffreythompson.org

A script to post Law & Order screenshots to Tumblr.

CONFIG FILE
The post settings are stored in a JSON file in the following format:
	{ 'consumer_key': 'xxxx', 'consumer_secret': 'xxxx', 'oauth_token': 'xxxx', 'oauth_secret': 'xxxx' }
This file has been left out of this repository, since it contains Tumblr passwords :)

REQUIRES
+ PyTumblr: https://github.com/tumblr/pytumblr

TO DO:
+ 

'''

import pytumblr														# Tumblr API
import os																	# for listing files, etc
import csv																# for parsing notes, quotes, etc
import re																	# data parsing
import shutil															# for moving uploaded folders
from OAuthSettings import settings				# import from settings.py

blog_address = 'computersonlawandorder.tumblr.com'		# where are we posting?
custom_tweet = False																	# add custom Tweet text to photo? (not for quotes post)
run_as_cron = False																		# exit when running as Cron job

bold_start = '\033[1m'																# special characters for bold text output in Terminal window...
bold_end = '\033[0m'																	# via http://askubuntu.com/a/45246


# LIST DIRECTORY, IGNORE HIDDEN FILES
# via: http://stackoverflow.com/a/7099342/1167783
def listdir_nohidden(path):
	files = []
	for f in os.listdir(path):
		if not f.startswith('.'):
			files.append(f)
	return files


# LOAD NOTES, ETC FROM FILE
def get_metadata(path):
	out = []
	with open(path, 'rb') as file:
		reader = csv.reader(file)
		for data in reader:
			if int(data[0]) == season and int(data[1]) == episode:
				for i in range(2, len(data)):
					out.append(data[i].strip())		# clear newlines, add to list
	return out


# TIDY UP AND START
print ('\n' * 20)
os.system('cls' if os.name=='nt' else 'clear')


# LOAD TUMBLR SETTINGS FROM FILE
client = pytumblr.TumblrRestClient(
	settings['consumer_key'],
	settings['consumer_secret'],
	settings['oauth_token'],
	settings['oauth_secret']
)


# EXTRACT NEXT SEASON/EPISODE
all_dirs = listdir_nohidden('../FinalScreenshotsToPost/')		# list screenshots directory
current_directory = all_dirs[0]
season = int(re.findall(r'S(.*?)E', all_dirs[0])[0])
episode = int(re.findall(r'E(.*)', all_dirs[0])[0])
print bold_start + 'SEASON ' + str(season) + ', EPISODE ' + str(episode) + bold_end


# LOAD LIST OF IMAGES, EPISODE TITLE
images = listdir_nohidden('../FinalScreenshotsToPost/' + current_directory)
episode_title = re.findall(r'Episode' + str(episode) + '-(.*?)-', images[0])[0]
episode_title = re.sub('_', ' ', episode_title)
print '\n' + 'Title:    "' + episode_title + '"'


# CREATE TAGS AND SLUG
tags = [ 'season ' + str(season), 'episode ' + str(episode), '"' + episode_title + '"' ]
firsts = get_metadata('../AnalysesAndEphemera/FirstsOnTheShow.txt')
if len(firsts) > 0:
	for first in firsts:
		tags.append(first.strip())
notes = get_metadata('../AnalysesAndEphemera/OtherMiscNotes.txt')
if len(notes) > 0:
	for note in notes:
		tags.append(notes.strip())
print 'Tags:    ',
for i, tag in enumerate(tags):
	if i < len(tags) - 1:
		print tag + ', ',
	else:
		print tag
slug = 's' + str(season) + 'e' + str(episode)


# GET QUOTES, POST!
# post quote with standard Tweet (quote, no citation)
quotes = get_metadata('../AnalysesAndEphemera/Quotes.txt')
if len(quotes) > 0:
	print 'Quotes:   ' + str(quotes)
	for quote in quotes:
		print '\n' + 'Posting quote...'
		response = client.create_quote(blog_address, quote=quote, tags=tags, slug=slug)
		if 'id' in response:
			print '- successful!'
		else:
			print '- error uploading post, sorry... :('


# POST IMAGES!
for i, image in enumerate(images):
	print '\n' + 'Posting image...'
	image_path = '../FinalScreenshotsToPost/' + current_directory + '/' + image
	tweet = episode_title + ' (' + str(i+1) + '/' + str(len(images)) + ') - '
	if custom_tweet:
		response = client.create_photo(blog_address, data=image_path, tags=tags, slug=slug, tweet=tweet)
	else:
		response = client.create_photo(blog_address, data=image_path, tags=tags, slug=slug)
	if 'id' in response:
		print '- successful!'
	else:
		print '- error uploading post, sorry... :('
		print response


# MOVE POSTED FOLDER
print '\n' + 'Moving current folder...'
shutil.move('../FinalScreenshotsToPost/' + current_directory, '../PostedEpisodes/' + current_directory)


# DONE!
print '\n' + 'DONE!' + ('\n' * 3)
if run_as_cron:
	exit()
