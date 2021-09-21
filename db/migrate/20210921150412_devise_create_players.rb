# frozen_string_literal: true

class DeviseCreatePlayers < ActiveRecord::Migration[6.1]
  def change
    create_table :players do |t|
      ## Database authenticatable
      t.string :username,           null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Rememberable
      t.datetime :remember_created_at

      t.integer :win_count, null: false, default: 0
      t.integer :draw_count, null: false, default: 0
      t.integer :loss_count, null: false, default: 0
      t.integer :total_games_count, null: false, default: 0

      t.boolean :guest, null: false, default: true

      t.timestamps null: false
    end

    add_index :players, :username,             unique: true
  end
end
