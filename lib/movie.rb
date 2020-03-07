# frozen_string_literal: true

class Movie
  def initialize(title:, description:, image_url: nil, official_site_url: nil)
    @title = title
    @description = description
    @image_url = image_url
    @official_site_url = official_site_url
  end

  attr_reader :title, :description, :image_url, :official_site_url
end
