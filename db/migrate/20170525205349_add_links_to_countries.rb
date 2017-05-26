class AddLinksToCountries < ActiveRecord::Migration[5.0]
  def change
    add_column :countries, :country_link, :string
    add_column :countries, :cities_link, :string
  end
end
