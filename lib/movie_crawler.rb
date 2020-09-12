# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'
require './lib/movie'
require 'dotenv/load'
require 'discordrb/webhooks'

class MovieCrawler
  BASE_URL = 'https://eiga.com'
  CLIENT = Discordrb::Webhooks::Client.new(url: ENV['WEBHOOK_URL'])
  DEBUG_CLIENT = Discordrb::Webhooks::Client.new(url: ENV['DEBUG_WEBHOOK_URL'])

  def run!
    lists = movie_urls.map do |url|
      sleep 1
      doc = Nokogiri::HTML(URI.open(url))

      p Movie.new(
        title: title(doc),
        description: description(doc),
        image_url: image_url(doc),
        official_site_url: official_site_url(doc)
      )
    end

    if lists.empty?
      CLIENT.execute { |b| b.content = '今週公開する映画はありませんでした🥺' }
    else
      CLIENT.execute { |b| b.content = '今週公開する映画はこちらです😊' }

      lists.each_slice(10) do |movies|
        CLIENT.execute do |builder|
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
  rescue StandardError => e
    DEBUG_CLIENT.execute { |b| b.content = "```#{e.message}\n#{e.backtrace}```" }
  end

  private

  def movie_urls
    Nokogiri::HTML(URI.open("#{BASE_URL}/upcoming"))
            .xpath('//div[@class="content-main"]/section//h3/a')
            .map { |item| BASE_URL + item[:href] }
  end

  def title(doc)
    doc.xpath('//h1[@class="page-title"]').text
  end

  def description(doc)
    doc.xpath('//div[@class="movie-details"]//p[@itemprop="description"]').text
  end

  def image_url(doc)
    attr = doc.xpath('//div[@class="hero-img"]/img').attr('data-src') ||
           doc.xpath('//div[contains(@class, "hero-img") and contains(@class, "not-size")]/img').attr('data-src')
    attr.value
  end

  def official_site_url(doc)
    sleep 1

    jump_url = doc
               .xpath('//div[@class="movie-details"]'\
                        '/section[@class="txt-block"]'\
                        '/a[contains(@class, "official")]')
               .attr('href')&.value

    if jump_url
      Nokogiri::HTML(URI.open(BASE_URL + jump_url))
              .xpath('//div[@class="jump-link"]/a').attr('href').value
    end
  end
end
