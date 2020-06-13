# frozen_string_literal: true

require 'discordrb/webhooks'
require 'dotenv/load'
require './lib/movie_crawler'

movie_crawler = MovieCrawler.new
movie_crawler.run!

client = Discordrb::Webhooks::Client.new(url: ENV['WEBHOOK_URL'])

if movie_crawler.lists.empty?
  client.execute { |b| b.content = '今週公開する映画はありませんでした🥺' }
else
  client.execute { |b| b.content = '今週公開する映画はこちらです😊' }

  movie_crawler.lists.each_slice(10) do |movies|
    client.execute do |builder|
      movies.each do |movie|
        builder.add_embed do |embed|
          embed.title = movie.title
          embed.description = movie.description
          embed.url = movie.official_site_url
          embed.image = Discordrb::Webhooks::EmbedImage.new(url: movie.image_url)
          embed.timestamp = Time.now
        end
      end
    end
  end
end
