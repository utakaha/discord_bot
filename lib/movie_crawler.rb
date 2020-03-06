require 'open-uri'
require 'nokogiri'

class MovieCrawler
  BASE_URL = 'https://eiga.com'.freeze

  def initialize
    @lists = {}
  end

  attr_reader :lists

  def run
    doc = Nokogiri::HTML(URI.open("#{BASE_URL}/upcoming"))

    doc.xpath('//div[@class="content-main"]/section//h3/a').each do |item|
      @lists[item.text] = { link: BASE_URL + item[:href] }
    end
  end
end
