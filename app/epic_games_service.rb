class EpicGamesService
  def initialize(adapter)
    @adapter = adapter
  end

  def fetch_data_for(game_title)
    response = @adapter.search(game_title)
    game_data = response.dig("data", "Catalog", "searchStore", "elements").first
    offer_id = game_data["offerId"]
    sandbox_id = game_data["sandboxId"]

    game_data_response = @adapter.game_data(offer_id, sandbox_id)
    raw_data = game_data_response.dig("data", "Catalog", "catalogOffer")
    images = raw_data.dig("keyImages") || []

    thumbnail = images.find { |image| image["type"] == "Thumbnail" } || {}

    {
      product_slug: raw_data["productSlug"],
      url_slug: raw_data["urlSlug"],
      image_url: thumbnail["url"]
    }
  rescue => st
    puts "Failed to fetch data for #{game_title}. Error: #{st}"
    {}
  end
end
