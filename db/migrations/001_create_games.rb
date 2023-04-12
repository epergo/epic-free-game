Sequel.migration do
  up do
    create_table(:games) do
      primary_key(:id)

      String(:title, null: false)
      String(:product_slug, null: true)
      String(:url_slug, null: true)
      String(:image_url, null: true)
    end
  end

  down do
    drop_table(:games)
  end
end
