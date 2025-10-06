class EpicFreeGames < Sinatra::Application
  set(:views, settings.root + "/views")

  get "/" do
    @promotions = Promotion.eager(:game).where { (start_date <= Time.now) & (end_date >= Time.now) & Sequel[{discount_percentage: 0}] }.all
    @upcoming_promotions = Promotion.eager(:game).where { (start_date > Time.now) & Sequel[{discount_percentage: 0}] }.all
    @past_promotions = Promotion.eager(:game).where { (end_date < Time.now) & Sequel[{discount_percentage: 0}] }.reverse(:start_date).all

    erb(:"promotions/index")
  end

  get "/status" do
    content_type(:json)
    {status: "ok"}.to_json
  end
end
