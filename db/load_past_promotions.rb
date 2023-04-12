class LoadPastPromotions
  def initialize(file, api_url)
    @file = file
    adapter = EpicGraphqlAdapter.new(api_url)
    @epic_service = EpicGamesService.new(adapter)
  end

  def call
    File.readlines(@file).each_with_index do |line, index|
      next if index < 2

      promotion_dates = line.split(":")[0]
      titles = line.split(":")[1..].join(":")

      if date_match = /(\w+ \d{1,2}, \d{4}) - (\w+ \d{1,2}, \d{4})/.match(promotion_dates)
        start_date = DateTime.parse("#{$1} 15:00 UTC")
        end_date = DateTime.parse("#{$2} 15:00 UTC")
      elsif date_match = /(\w+ \d{1,2})\s+-\s+(\w+ \d{1,2})\s*,\s*(\d{4})/ =~ promotion_dates
        start_date = DateTime.parse("#{$1} #{$3} 15:00 UTC")
        end_date = DateTime.parse("#{$2} #{$3} 15:00 UTC")
      elsif date_match = /(\w+ \d{1,2}), (\d{4})/ =~ promotion_dates
        start_date = DateTime.parse("#{$1} #{$2} 15:00 UTC")
        end_date = start_date + 1 # Next day
      end

      raise "Invalid date format" if date_match.nil?

      titles.split(",").each do |title|
        puts "Processing #{title}"
        game = Game.find_or_new(title: title.strip)
        if game.image_url.nil? || game.product_slug.nil? || game.url_slug.nil?
          game_data = @epic_service.fetch_data_for(title)
          game.image_url = game_data[:image_url]
          game.product_slug = game_data[:product_slug]
          game.url_slug = game_data[:url_slug]

          game.save

          Promotion.update_or_create(
            game_id: game.id,
            start_date: start_date,
            end_date: end_date,
            discount_type: "PERCENTAGE",
            discount_percentage: 0
          )
          puts "Game updated: #{game.title}"
        else
          puts "Game doesn't have missing data, skip: #{game.title}"
          next
        end
      end
    rescue => st
      puts "Invalid line: #{line}. Error: #{st}"
    end
  end
end
