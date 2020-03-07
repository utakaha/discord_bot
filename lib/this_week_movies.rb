# frozen_string_literal: true

require 'discordrb/webhooks'
require 'dotenv/load'
require './lib/movie_crawler'

movie_crawler = MovieCrawler.new
movie_crawler.run!

client = Discordrb::Webhooks::Client.new(url: ENV['WEBHOOK_URL'])
client.execute do |builder|
  builder.content = '今週公開する映画はこちらです😊'

  movie_crawler.lists.each do |movie|
    builder.add_embed do |embed|
      embed.title = movie.title
      embed.description = movie.description
      embed.url = movie.official_site_url
      embed.image = Discordrb::Webhooks::EmbedImage.new(url: movie.image_url)
      embed.timestamp = Time.now
    end
  end
end
