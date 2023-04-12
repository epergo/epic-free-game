Sequel.migration do
  up do
    create_table(:promotions) do
      primary_key(:id)

      foreign_key(:game_id, :games, null: false)
      DateTime(:start_date, null: false)
      DateTime(:end_date, null: false)
      String(:discount_type, null: false)
      Integer(:discount_percentage, null: false)
    end
  end

  down do
    drop_table(:promotions)
  end
end
