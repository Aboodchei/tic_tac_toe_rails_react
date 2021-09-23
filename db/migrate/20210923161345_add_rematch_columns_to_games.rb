class AddRematchColumnsToGames < ActiveRecord::Migration[6.1]
  def change
    add_column :games, :rematch_status, :integer, default: 0
    add_column :games, :rematch_slug, :string
    add_reference :games, :rematch_requester, foreign_key: { to_table: :players }
  end
end
