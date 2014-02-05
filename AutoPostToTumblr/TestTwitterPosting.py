
from OAuthSettings import settings
import twitter

consumer_key = settings['twitter_consumer_key']
consumer_secret = settings['twitter_consumer_secret']
access_token_key = settings['twitter_oauth_token']
access_token_secret = settings['twitter_oauth_secret']

def post_tweet(tweet):
	print 'Posting to Twitter...'
	try:
		api = twitter.Api(consumer_key = consumer_key, consumer_secret = consumer_secret, access_token_key = access_token_key, access_token_secret = access_token_secret)
		
		#image = '/Users/JeffThompson/Documents/ComputersOnLawAndOrder/AutoPostToTumblr/Test.png'
		#status = api.PostMedia(status = tweet, media = image)
		status = api.PostUpdate(tweet)
		print '- Tweet successful!'
	except twitter.TwitterError:
		print '- error posting Tweet!'

tweet = 'Testing auto-poster, please ignore!'
post_tweet(tweet)