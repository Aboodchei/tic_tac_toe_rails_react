class CreateGames < ActiveRecord::Migration[6.1]
  def change
    create_table :games do |t|
      t.references :player_one, foreign_key: { to_table: :players }
      t.references :player_two, foreign_key: { to_table: :players }
      t.references :player_with_turn, foreign_key: { to_table: :players }
      t.string :moves, array: true, default: []
      t.integer :status, null: false, default: 0
      t.integer :result, null: false, default: 0

      t.timestamps
    end
  end
end
