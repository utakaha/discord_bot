# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'
require './lib/movie'

class MovieCrawler
  BASE_URL = 'https://eiga.com'

  def initialize
    @lists = []
  end

  attr_reader :lists

  def run!
    movie_urls.each do |url|
      sleep 1
      doc = Nokogiri::HTML(URI.open(url))

      p movie = Movie.new(
        title: title(doc), description: description(doc),
        image_url: image_url(doc), official_site_url: official_site_url(doc)
      )
      lists.push(movie)
    end
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
    doc.xpath('//div[@class="hero-img"]/img').attr('data-src').value
  end

  def official_site_url(doc)
    sleep 1

    jump_url = doc
               .xpath('//div[@class="movie-details"]'\
                      '/section[@class="txt-block"]'\
                      '/a[contains(@class, "official")]')
               .attr('href')
               .value

    Nokogiri::HTML(URI.open(BASE_URL + jump_url))
            .xpath('//div[@class="jump-link"]/a')
            .attr('href').value
  end
end
