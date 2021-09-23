# == Schema Information
#
# Table name: games
#
#  id                   :bigint           not null, primary key
#  moves                :string           default([]), is an Array
#  rematch_slug         :string
#  rematch_status       :integer          default(0)
#  result               :integer          default("not_applicable"), not null
#  slug                 :string           default(""), not null
#  status               :integer          default("invitation_pending"), not null
#  winning_combination  :string           default([]), is an Array
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  player_one_id        :bigint
#  player_two_id        :bigint
#  player_with_turn_id  :bigint
#  rematch_requester_id :bigint
#
# Indexes
#
#  index_games_on_player_one_id         (player_one_id)
#  index_games_on_player_two_id         (player_two_id)
#  index_games_on_player_with_turn_id   (player_with_turn_id)
#  index_games_on_rematch_requester_id  (rematch_requester_id)
#  index_games_on_slug                  (slug)
#
# Foreign Keys
#
#  fk_rails_...  (player_one_id => players.id)
#  fk_rails_...  (player_two_id => players.id)
#  fk_rails_...  (player_with_turn_id => players.id)
#  fk_rails_...  (rematch_requester_id => players.id)
#
require 'rails_helper'

RSpec.describe Game, type: :model do
  describe 'correctly plays out' do
    let(:player_one) { create(:player) }
    let(:player_two) { create(:player) }
    let(:game) { create(:game, player_one: player_one).tap{|g| g.accept_invitation(player_two) }.reload }

    it 'in case of a draw' do
      # X X O
      # O O ?
      # X X O
      ['1','3','2','4','7','5','8','9'].each{|move| game.play(move)}
      game.play('6')
      expect(game.status).to eq('completed')
      expect(game.result).to eq('draw')
      expect(game.player_with_turn_id).to eq(nil)
    end

    it 'in case of a win (player one win)' do
      # X O X
      # O X O
      # ?
      ['1', '2', '3', '4', '5', '6'].each{|move| game.play(move)}
      game.play('7')
      expect(game.status).to eq('completed')
      expect(game.result).to eq('player_one_win')
      expect(game.player_with_turn_id).to eq(nil)
    end

    it 'in case of a loss (player two win)' do
      # X O X
      #   O
      #   ? X
      ['1', '5', '3', '2', '9'].each{|move| game.play(move)}
      game.play('8')
      expect(game.status).to eq('completed')
      expect(game.result).to eq('player_two_win')
      expect(game.player_with_turn_id).to eq(nil)
    end

    it 'correctly assigns player turns' do
      # X O X
      # O X O
      # X
      expect(game.player_with_turn_id).to eq(player_one.id)
      expect(game.status).to eq('in_progress')
      expect(game.result).to eq('not_applicable')
      game.play('1')
      expect(game.status).to eq('in_progress')
      expect(game.result).to eq('not_applicable')
      expect(game.player_with_turn_id).to eq(player_two.id)
      game.play('2')
      expect(game.status).to eq('in_progress')
      expect(game.result).to eq('not_applicable')
      expect(game.player_with_turn_id).to eq(player_one.id)
      game.play('3')
      expect(game.status).to eq('in_progress')
      expect(game.result).to eq('not_applicable')
      expect(game.player_with_turn_id).to eq(player_two.id)
      game.play('4')
      expect(game.status).to eq('in_progress')
      expect(game.result).to eq('not_applicable')
      expect(game.player_with_turn_id).to eq(player_one.id)
      game.play('5')
      expect(game.status).to eq('in_progress')
      expect(game.result).to eq('not_applicable')
      expect(game.player_with_turn_id).to eq(player_two.id)
      game.play('6')
      expect(game.status).to eq('in_progress')
      expect(game.result).to eq('not_applicable')
      expect(game.player_with_turn_id).to eq(player_one.id)
      game.play('7')
      expect(game.status).to eq('completed')
      expect(game.result).to eq('player_one_win')
      expect(game.player_with_turn_id).to eq(nil)
      game.play('8')
      expect(game.moves).to eq(["1", "2", "3", "4", "5", "6", "7"])
      expect(game.status).to eq('completed')
      expect(game.result).to eq('player_one_win')
      expect(game.player_with_turn_id).to eq(nil)
    end
  end
end
