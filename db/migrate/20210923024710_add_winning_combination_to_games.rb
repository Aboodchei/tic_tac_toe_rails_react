class AddWinningCombinationToGames < ActiveRecord::Migration[6.1]
  def change
    add_column :games, :winning_combination, :string, array: true, default: []
  end
end
