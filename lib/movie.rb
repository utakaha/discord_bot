class Movie
  def initialize(title, description, official_site_url, image)
    @title = title
    @description = description
    @official_site_url = official_site_url
    @image = image
  end

  attr_reader :title, :description, :official_site_url, :image
end
