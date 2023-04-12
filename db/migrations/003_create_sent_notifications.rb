Sequel.migration do
  up do
    create_table(:sent_notifications) do
      primary_key(:id)

      foreign_key(:promotion_id, :promotions, null: false)
      DateTime(:sent_at, null: false)
    end
  end

  down do
    drop_table(:sent_notifications)
  end
end
