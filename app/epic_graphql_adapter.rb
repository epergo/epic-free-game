# HTTP Adapter for Graphql endpoints
# It configures the connection in the constructor and exposes a method to make
# requests to the API
class EpicGraphqlAdapter
  def initialize(base_url)
    raise ArgumentError, "Invalid URL" if base_url.nil? || base_url == ""

    @connection = Faraday.new(
      url: base_url,
      request: {timeout: 15}
    )
  end

  def search(term)
    response = @connection.get(
      "/graphql",
      {
        operationName: "primarySearchAutocomplete",
        variables: {
          allowCountries: "FR",
          category: "games/edition/base|bundles/games|editors|software/edition/base",
          count: 4,
          country: "FR",
          keywords: term,
          locale: "en-US",
          sortBy: nil,
          sortDir: "DESC"
        }.to_json,
        extensions: {
          persistedQuery: {
            version: 1,
            sha256Hash: "531ca97218358754b2a3dade40dbbfc62e280d0173dcaf53305b3b3f3c393580"
          }
        }.to_json
      }
    )
    JSON.parse(response.body)
  end

  def game_data(offer_id, sandbox_id)
    response = @connection.get(
      "/graphql",
      {
        operationName: "getCatalogOffer",
        variables: {
          country: "FR",
          locale: "en-US",
          offerId: offer_id,
          sandboxId: sandbox_id
        }.to_json,
        extensions: {
          persistedQuery: {
            version: 1,
            sha256Hash: "6797fe39bfac0e6ea1c5fce0ecbff58684157595fee77e446b4254ec45ee2dcb"
          }
        }.to_json
      }
    )
    JSON.parse(response.body)
  end
end
