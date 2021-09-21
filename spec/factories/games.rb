# == Schema Information
#
# Table name: games
#
#  id                  :bigint           not null, primary key
#  moves               :string           default([]), is an Array
#  result              :integer          default("not_applicable"), not null
#  slug                :string           default(""), not null
#  status              :integer          default("invitation_pending"), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  player_one_id       :bigint
#  player_two_id       :bigint
#  player_with_turn_id :bigint
#
# Indexes
#
#  index_games_on_player_one_id        (player_one_id)
#  index_games_on_player_two_id        (player_two_id)
#  index_games_on_player_with_turn_id  (player_with_turn_id)
#  index_games_on_slug                 (slug)
#
# Foreign Keys
#
#  fk_rails_...  (player_one_id => players.id)
#  fk_rails_...  (player_two_id => players.id)
#  fk_rails_...  (player_with_turn_id => players.id)
#
FactoryBot.define do
  factory :game do
    player_one { create(:player) }
    player_two { create(:player) }
    player_with_turn { nil }
    moves { [] }
    status { 0 }
    result { 0 }
  end
end
