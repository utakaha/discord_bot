require 'open-uri'
require 'nokogiri'

class MovieCrawler
  BASE_URL = 'https://eiga.com'.freeze

  def initialize
    @lists = {}
  end

  attr_reader :lists

  def run!
    doc = Nokogiri::HTML(URI.open("#{BASE_URL}/upcoming"))

    doc.xpath('//div[@class="content-main"]/section//h3/a').each do |item|
      @lists[item.text] = { link: BASE_URL + item[:href] }
    end
  end

  def defalut_text
    list_text = @lists.map do |key, value|
      "#{key}: #{value[:link]}"
    end.join("\n")

    "今週公開する映画はこちらです😊\n#{list_text}"
  end
end
