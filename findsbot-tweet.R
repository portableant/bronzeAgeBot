library(httr)
library(rtweet)
library(jsonlite)
library(digest)
# Create Twitter token
findsbot_token <- rtweet::rtweet_bot(
  api_key =    Sys.getenv("TWITTER_CONSUMER_API_KEY"),
  api_secret = Sys.getenv("TWITTER_CONSUMER_API_SECRET"),
  access_token =    Sys.getenv("TWITTER_ACCESS_TOKEN"),
  access_secret =   Sys.getenv("TWITTER_ACCESS_TOKEN_SECRET")
)
hash <- digest(Sys.time(),algo="md5", serialize=TRUE)
search <- paste0('https://finds.org.uk/database/search/results/broadperiod/BRONZE+AGE/sort/random_', hash,'/show/1/thumbnail/1/format/json')
randomFinds <- fromJSON(search)
id <- randomFinds$results$old_findID
url <- paste0('https://bronze-age-index.micropasts.org/records/', id)
period <- randomFinds$results$broadperiod
objectType <- randomFinds$results$objecttype
county <- randomFinds$results$county
imagedir <- randomFinds$results$imagedir
image <- randomFinds$results$filename
imageUrl <- paste0('https://finds.org.uk/', imagedir, URLencode(image))
hashtag <- '#prehistory #bronzeage #findsorguk'
tweet <- paste(period,objectType,'from',county,id,url,hashtag, sep=' ')
temp_file <- tempfile(fileext = ".jpeg")
download.file(imageUrl, temp_file)

rtweet::post_tweet(
  status = tweet,
  media = temp_file,
  token = findsbot_token,
  media_alt_text = tweet
)
