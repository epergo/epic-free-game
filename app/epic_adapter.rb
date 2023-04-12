# HTTP Adapter that creates a Faraday connection to the Epic Games Store API
# It configures the connection in the constructor and exposes a method to make
# requests to the API
class EpicAdapter
  def initialize(base_url)
    raise ArgumentError, "Invalid URL" if base_url.nil? || base_url == ""

    @connection = Faraday.new(
      url: base_url,
      headers: {"Content-Type": "application/json"},
      request: {timeout: 15}
    )
  end

  def get_free_games
    response = @connection.get("/freeGamesPromotions")
    JSON.parse(response.body)
  end
end
