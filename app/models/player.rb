# == Schema Information
#
# Table name: players
#
#  id                  :bigint           not null, primary key
#  draw_count          :integer          default(0), not null
#  encrypted_password  :string           default(""), not null
#  guest               :boolean          default(TRUE), not null
#  loss_count          :integer          default(0), not null
#  remember_created_at :datetime
#  total_games_count   :integer          default(0), not null
#  username            :string           default(""), not null
#  win_count           :integer          default(0), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_players_on_username  (username) UNIQUE
#
class Player < ApplicationRecord
  devise :database_authenticatable, :registerable, :rememberable
end
