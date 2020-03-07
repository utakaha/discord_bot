require 'open-uri'
require 'nokogiri'
require './lib/movie'

class MovieCrawler
  BASE_URL = 'https://eiga.com'.freeze

  def initialize
    @lists = []
  end

  attr_reader :lists

  def run!
    main_doc = Nokogiri::HTML(URI.open("#{BASE_URL}/upcoming"))
    movie_urls = main_doc.xpath('//div[@class="content-main"]/section//h3/a').map { |item| BASE_URL + item[:href] }

    movie_urls.each do |url|
      doc = Nokogiri::HTML(URI.open("#{url}"))

      movie = Movie.new(
        title: doc.xpath('//h1[@class="page-title"]').text,
        description: doc.xpath('//div[@class="movie-details"]//p[@itemprop="description"]').text,
        image_url: doc.xpath('//div[@class="hero-img"]/img').attr('data-src').value,
        official_site_url: official_site_url(doc),
      )
      lists.push(movie)

      p movie
      sleep 1
    end
  end

  private

  def official_site_url(doc)
    sleep 1

    jump_url = doc
                 .xpath('//div[@class="movie-details"]/section[@class="txt-block"]/a[contains(@class, "official")]')
                 .attr('href')
                 .value

    Nokogiri::HTML(URI.open(BASE_URL + jump_url)).xpath('//div[@class="jump-link"]/a').attr('href').value
  end
end
