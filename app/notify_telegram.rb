class NotifyTelegram
  def call
    promotions = Promotion
      .eager(:game)
      .left_join(:sent_notifications, promotion_id: :id)
      .where(
        Sequel.lit(
          "promotions.start_date <= :now
          AND promotions.end_date >= :now
          AND promotions.discount_percentage = :discount
          AND sent_notifications.id IS NULL",
          now: Time.now.utc,
          discount: 0
        )
      )
      .select_all(:promotions)
      .all

    if promotions.empty?
      puts "No promotions to notify"
      return
    end

    promotions.each do |promotion|
      game = promotion.game
      puts "Sending notification for #{game.title}"

      text = message_for(game, promotion)

      TelegramClient
        .client
        .api
        .send_message(chat_id: Settings.telegram.chat_id, text:)

      SentNotification.create(promotion_id: promotion.id, sent_at: Time.now.utc)
    end
  end

  private

  def message_for(game, promotion)
    "Free game: #{game.title} (Until #{promotion.end_date})\n#{game.store_url}"
  end
end
