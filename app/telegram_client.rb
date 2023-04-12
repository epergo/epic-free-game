class TelegramClient
  class << self
    def client
      @client ||= Telegram::Bot::Client.new(token)
    end

    private

    def token
      @tokeh ||= begin
        token = Settings.telegram.token
        if token.nil? || token == ""
          raise ArgumentError, "Invalid telegram api token"
        end

        token
      end
    end
  end
end
