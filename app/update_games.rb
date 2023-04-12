# Fetch Epic Games Store free games and update the database
class UpdateGames
  GameData = Data.define(:title, :product_slug, :url_slug, :image_url, :promotions)
  PromotionData = Data.define(
    :start_date,
    :end_date,
    :discount_type,
    :discount_percentage
  )

  def initialize(epic_adapter)
    @epic_adapter = epic_adapter
  end

  # Fetch games, filter those that are active and free
  # Insert games into the database
  def call
    fetch_games
      .then { |games_data| build_games(games_data) }
      .each do |game_data|
      next if game_data.promotions.empty?

      insert_game(game_data)
        .then { |game| insert_promotions(game, game_data.promotions) }
    end
  end

  # Fetch games from the Epic Games Store
  def fetch_games
    json_response = @epic_adapter.get_free_games
    json_response["data"]["Catalog"]["searchStore"]["elements"] || []
  end

  private

  def build_games(games_data)
    games_data
      .map do |game|
        active_promotions = build_promotions(game.dig("promotions", "promotionalOffers") || [])
        upcoming_promotions = build_promotions(game.dig("promotions", "upcomingPromotionalOffers") || [])
        thumbnail_image = game["keyImages"].find { |image| image["type"] == "Thumbnail" }

        url_slug = game.dig("catalogNs", "mappings")&.first&.[]("pageSlug") || game["urlSlug"]
        GameData.new(
          title: game["title"],
          product_slug: game["productSlug"],
          url_slug:,
          image_url: thumbnail_image&.fetch("url", nil),
          promotions: active_promotions + upcoming_promotions
        )
      end
  end

  def build_promotions(promotional_offers)
    promotions = []
    promotional_offers.each do |offer|
      offer["promotionalOffers"].each do |promotional_offer|
        promotions << PromotionData.new(
          start_date: Time.parse(promotional_offer["startDate"]),
          end_date: Time.parse(promotional_offer["endDate"]),
          discount_type: promotional_offer["discountSetting"]["discountType"],
          discount_percentage: promotional_offer["discountSetting"]["discountPercentage"]
        )
      end
    end

    promotions
  end

  def insert_game(game_data)
    Game.update_or_create(title: game_data.title) do |game|
      game.product_slug = game_data.product_slug
      game.url_slug = game_data.url_slug
      game.image_url = game_data.image_url
    end
  end

  def insert_promotions(game, promotions_data)
    promotions_data.each do |promotion_data|
      Promotion.update_or_create(
        game_id: game.id,
        start_date: promotion_data.start_date,
        end_date: promotion_data.end_date,
        discount_type: promotion_data.discount_type,
        discount_percentage: promotion_data.discount_percentage
      )
    end
  end
end
