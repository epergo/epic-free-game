class Game < Sequel::Model
  one_to_many :promotions

  def small_image_url
    "#{image_url}?w=360&h=480&quality=medium&resize=1"
  end

  def store_url
    "https://store.epicgames.com/en-US/p/#{url_slug}"
  end
end
