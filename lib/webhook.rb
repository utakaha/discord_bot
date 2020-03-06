require 'discordrb/webhooks'
require 'dotenv/load'
require './lib/movie_crawler'

movie_crawler = MovieCrawler.new
movie_crawler.run!

client = Discordrb::Webhooks::Client.new(url: ENV['WEBHOOK_URL'])
client.execute do |builder|
  builder.content = movie_crawler.defalut_text
end
