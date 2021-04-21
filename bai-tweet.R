library(httr)
library(rtweet)
library(jsonlite)
library(digest)
# Create Twitter token
baibot_token <- rtweet::create_token(
  app = "findsbot",
  consumer_key =    Sys.getenv("TWITTER_CONSUMER_API_KEY"),
  consumer_secret = Sys.getenv("TWITTER_CONSUMER_API_SECRET"),
  access_token =    Sys.getenv("TWITTER_ACCESS_TOKEN"),
  access_secret =   Sys.getenv("TWITTER_ACCESS_TOKEN_SECRET")
)
hash <- digest(Sys.time(),algo="md5", serialize=TRUE)
search <- paste0('https://collection.beta.fitz.ms/bai?q=*%3A*&rows=1&sort=random_',hash,'%20desc')
randomBAI <- fromJSON(search)
records <- randomBAI$response$docs

url <- unlist(records$flickrURL)
period <- 'Bronze Age'
objectType <- records$objectType
collection <- unlist(records$collection)
project <- unlist(records$project)
imageUrl <- unlist(records$imageURL)
hashtag <- '#prehistory #bronzeage #baibm'
tweet <- paste(period,objectType,collection,url,hashtag, sep=' ')
temp_file <- tempfile()
download.file(imageUrl, temp_file)

rtweet::post_tweet(
  status = tweet,
  media = temp_file,
  token = baibot_token
)
