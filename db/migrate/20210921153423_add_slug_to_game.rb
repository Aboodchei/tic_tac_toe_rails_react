class AddSlugToGame < ActiveRecord::Migration[6.1]
  def change
    add_column :games, :slug, :string, default: "", null: false
    add_index :games, :slug
  end
end
