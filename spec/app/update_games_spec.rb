RSpec.describe(UpdateGames) do
  let(:adapter) { double("adapter") }
  let(:json_response) { JSON.parse(File.read("spec/fixtures/free_games.json")) }

  subject(:updater) { UpdateGames.new(adapter) }

  before do
    allow(adapter).to receive(:get_free_games).and_return(json_response)
    Timecop.freeze(Date.new(2023, 0o4, 0o6))
  end

  after do
    Timecop.return
  end

  describe "#call" do
    context "when game has both active and upcoming promotions" do
      it "inserts the game and its promotions" do
        updater.call

        game = Game.first(title: "Tunche")

        expect(game.product_slug).to eq("tunche")
        expect(game.url_slug).to eq("astatinegeneralaudience")

        promotions = Promotion.where(game_id: game.id)
        expect(promotions.count).to eq(2)

        expect(promotions.any? { |p| p.discount_type == "PERCENTAGE" && p.discount_percentage == 0 }).to be_truthy
        expect(promotions.any? { |p| p.discount_type == "PERCENTAGE" && p.discount_percentage == 50 }).to be_truthy
      end
    end

    context "when game does not have promotions" do
      it "does not insert the game" do
        updater.call

        game = Game.first(title: "Dishonored - Definitive Edition")
        expect(game).to be_nil
      end
    end
  end

  describe "#fetch_games" do
    it "returns games" do
      games = updater.fetch_games

      expect(games.length).to eq(6)
    end
  end
end
