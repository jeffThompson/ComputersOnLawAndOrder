
'''
AUTO POST TO TUMBLR
Jeff Thompson | 2013-14 | www.jeffreythompson.org

A script to post Law & Order screenshots to Tumblr.

CONFIG FILE
The post settings are stored in a JSON file in the following format:
	{ 'consumer_key': 'xxxx', 'consumer_secret': 'xxxx', 'oauth_token': 'xxxx', 'oauth_secret': 'xxxx' }
	
Twitter settings include 'twitter_' before the listing. This file has been left out of this repository,
since it contains Tumblr passwords :)

REQUIRES
+ PyTumblr: https://github.com/tumblr/pytumblr
+ Twitter (for custom Tweeting): https://github.com/bear/python-twitter

'''

import pytumblr														# Tumblr API
import os																	# for listing files, etc
import csv																# for parsing notes, quotes, etc
import re																	# data parsing
import shutil															# for moving uploaded folders
from OAuthSettings import settings				# import from settings.py
import twitter														# for posting to Twitter
from sys import exit											# for exiting when done posting


blog_address = 'computersonlawandorder.tumblr.com'		# where are we posting?
custom_tweet = True																		# create custom Tweet? use only when not enabled in Tumblr
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
					s = data[i].strip()		# clear newlines
					out.append(s)					# add to list
	return out


# TIDY UP AND START
print ('\n' * 20)
os.system('cls' if os.name=='nt' else 'clear')


# LOAD TUMBLR OAUTH SETTINGS FROM FILE
client = pytumblr.TumblrRestClient(
	settings['consumer_key'],
	settings['consumer_secret'],
	settings['oauth_token'],
	settings['oauth_secret']
)


# ALSO LOAD TWITTER SETTINGS...
if custom_tweet:
	consumer_key = settings['twitter_consumer_key']
	consumer_secret = settings['twitter_consumer_secret']
	access_token_key = settings['twitter_oauth_token']
	access_token_secret = settings['twitter_oauth_secret']
	api = twitter.Api(consumer_key = consumer_key, consumer_secret = consumer_secret, access_token_key = access_token_key, access_token_secret = access_token_secret)


# EXTRACT NEXT SEASON/EPISODE
all_dirs = listdir_nohidden('../FinalScreenshotsToPost/')		# list screenshots directory
current_directory = all_dirs[0]															# first directory is next to post
season = int(re.findall(r'S(.*?)E', all_dirs[0])[0])				# extract season number
episode = int(re.findall(r'E(.*)', all_dirs[0])[0])					# ditto episode


# PRINT DETAILS
print bold_start + 'SEASON ' + str(season) + ', EPISODE ' + str(episode) + bold_end
print '\n' + 'Custom tweet: ' + str(custom_tweet)

# LOAD LIST OF IMAGES, EPISODE TITLE
images = listdir_nohidden('../FinalScreenshotsToPost/' + current_directory)
episode_title = re.findall(r'Episode' + str(episode) + '-(.*?)-', images[0])[0]
episode_title = re.sub('_', ' ', episode_title)
print '\n' + 'Title:    "' + episode_title + '"'


# CREATE TAGS AND SLUG
tags = [ 'Season ' + str(season), 'Episode ' + str(episode), '"' + episode_title + '"' ]

# load firsts list, add if there is a first for the episode
firsts = get_metadata('../AnalysesAndEphemera/FirstsOnTheShow.txt')
if len(firsts) > 0:											# if there are firsts
	for first in firsts:									# iterate...
		tags.append(first.capitalize())			# capitalize and add to list

# ditto notes
notes = get_metadata('../AnalysesAndEphemera/OtherMiscNotes.txt')
if len(notes) > 0:
	for note in notes:
		tags.append(note.capitalize())

# print tags
print 'Tags:    ',
for i, tag in enumerate(tags):
	if i < len(tags) - 1:
		print tag + ', ',
	else:
		print tag


# GET QUOTES, POST!
# post quote with standard Tweet (quote, no citation)
quotes = get_metadata('../AnalysesAndEphemera/Quotes.txt')
if len(quotes) > 0:
	print 'Quotes:   ' + str(quotes)
	for quote in quotes:
		print '\n' + 'Posting quote...'
		response = client.create_quote(blog_address, quote=quote, tags=tags)
		if 'id' in response:
			print '- posting to Tumblr successful!'
			
			# add custom Tweet
			if custom_tweet:
				print '- posting to Twitter...'
				url = blog_address + '/' + str(response['id'])
				if len(quote) > 80:
					quote = quote[:80] + '...'
				try:
					tweet = '"' + quote + '" - ' + url
					status = api.PostUpdate(tweet)
					print '- Tweet successful!'
				except twitter.TwitterError:
					print '- error posting Tweet!'			
		else:
			print '- error uploading post, sorry... :('


# POST IMAGES!
for i, image in enumerate(images):
	print '\n' + 'Posting image...'
	image_path = '../FinalScreenshotsToPost/' + current_directory + '/' + image
	response = client.create_photo(blog_address, data=image_path, tags=tags)

	# successful post...
	if 'id' in response:	
		print '- posting to Tumblr successful!'

		# add custom Tweet
		if custom_tweet:
			print '- posting to Twitter...'
			url = blog_address + '/' + str(response['id'])
			tweet = episode_title + ' (' + str(i+1) + '/' + str(len(images)) + ') - ' + url
			try:
				status = api.PostMedia(status = tweet, media = image_path)
				print '- Tweet successful!'
			except twitter.TwitterError:
				print '- error posting Tweet!'			

	# error posting...
	else:
		print '- error uploading post to Tumblr, sorry... :('
		print response


# MOVE POSTED FOLDER
print '\n' + 'Moving current folder...'
shutil.move('../FinalScreenshotsToPost/' + current_directory, '../PostedEpisodes/' + current_directory)


# DONE!
print '\n' + 'DONE!' + ('\n' * 3)
if run_as_cron:
	exit()
