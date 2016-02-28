require 'spec_helper'
require_relative '../lib/player.rb'
require_relative '../lib/board.rb'

describe Player do
  context "#new" do
    it "creates players with name: 'Player[n]' by default" do
      players = []
      10.times do |i|
        player = Player.new(i.to_s)
        players << player
        expect(player.name).to eq("Player#{i+1}")
      end
      players.map(&:destroy)
    end
    it "creates player with custom name" do
      player = Player.new('X', "John")
      expect(player.name).to eq("John")
      player.destroy
    end
    it "only creates one player per unique symbol" do
      players = []
      10.times { players << Player.new('X') }
      expect(players.compact!.count).to eq(1)
      players[0].destroy
    end
  end

  context "#drop_tile_at" do
    let(:board) { Board.new }
    let(:player1) { Player.new('X') }

    after { player1.destroy }  # ensure unique symbol

    it "returns true with valid move" do
      expect(player1.drop_tile_at(board, 0)).to be true
    end
    it "returns false with invalid move" do
      expect(player1.drop_tile_at(board, 100)).to be false
    end
    it "adds tile to the bottom of the board" do
      player1.drop_tile_at(board, 0)
      expect(board.board[-1][0]).to eq(player1.symbol)
    end
    it "adds different tile to the board for different players" do
      player2 = Player.new('O')
      player1.drop_tile_at(board, 0)
      player2.drop_tile_at(board, 1)
      expect(board.board[-1][0]).to eq(player1.symbol)
      expect(board.board[-1][1]).to eq(player2.symbol)
      player2.destroy
    end
  end

  context "#destroy" do
    it "removes current player's symbol from memory" do
      Player.new('X').destroy
      player = Player.new('X')
      expect(player).not_to be_nil
      player.destroy
    end
    it "decrease players count by 1" do
      Player.new('X').destroy
      player = Player.new('X')
      expect(player.name).to eq('Player1')
      player.destroy
    end
  end
end