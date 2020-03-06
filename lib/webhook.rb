require 'discordrb/webhooks'
require 'dotenv/load'
require './lib/movie_crawler'

movie_crawler = MovieCrawler.new
movie_crawler.run

text = movie_crawler.lists.map do |key, value|
  "#{key}: #{value[:link]}"
end.join("\n")

client = Discordrb::Webhooks::Client.new(url: ENV['WEBHOOK_URL'])
client.execute do |builder|
  builder.content = <<~TEXT
    今週公開する映画はこちらです😊
    #{text}
  TEXT
end
