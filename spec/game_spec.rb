require 'spec_helper'
require_relative '../lib/game'
require_relative '../lib/board'
require_relative '../lib/player'

describe Game do
  before { allow(STDOUT).to receive(:puts) { '' } }
  after do 
    allow(STDIN).to receive(:gets) { STDIN.gets }
    allow(STDOUT).to receive(:puts) { STDOUT.puts }
  end
  context "#new" do
    it "creates game with default name 'Connect Four'" do
      expect(Game.new(Board.new).name).to eq("Connect Four")
    end
    it "creates game with custom name" do
      expect(Game.new(Board.new, "Two Can Play This Game").name).to eq("Two Can Play This Game")
    end
  end

  context "#add_player" do
    subject(:game) { Game.new(Board.new) }
    let(:player) { Player.new('X') }
    after { player.destroy }

    context "with valid player" do
      it "returns true" do
        expect(game.add_player(player)).to be true
      end
      it "increment num_player by 1 for each additional player" do
        expect { game.add_player(player) }.to change { game.num_player }.from(0).to(1)
      end
      it "adds the player to players" do
        game.add_player(player)
        expect(game.players).to contain_exactly(player)
      end
    end

    context "with invalid player" do
      it "returns false" do
        fail_player = Player.new(player.symbol)
        expect(game.add_player(fail_player)).to be false
      end
      it "doesn't add the player if the player fails to initialize" do
        fail_player = Player.new(player.symbol)
        expect { game.add_player(fail_player) }.not_to change { game.num_player }
        expect { game.add_player(fail_player) }.not_to change { game.players }
      end
      it "doesn't add the same player more than once" do
        game.add_player(player)
        expect { game.add_player(player) }.not_to change { game.num_player }
        expect { game.add_player(player) }.not_to change { game.players }
      end
    end
  end

  context "#clear_board!" do
    subject(:game) { Game.new(Board.new) }
    let(:player1) { Player.new('X') }
    let(:player2) { Player.new('O') }
    before do
      game.add_player(player1)
      game.add_player(player2)
    end
    after { [player1, player2].map(&:destroy) }

    it "clears the game board" do
      clean_board = Board.new
      game.board.num_col.times do |col|
        allow(STDIN).to receive(:gets) { "#{col+1}\n" }
        game.tick!
      end
      game.clear_board!
      expect(game.board.board).to eq(clean_board.board)
    end
  end

  context "#tick!" do
    subject(:game) { Game.new(Board.new) }
    let(:player1) { Player.new('X') }
    let(:player2) { Player.new('O') }

    after { [player1, player2].map(&:destroy) }
    it "returns false with less than two players" do
      expect(game.tick!).to be false
    end

    context "with more than two players" do
      before do
        game.add_player(player1)
        game.add_player(player2)
      end
      it "returns true with valid input" do
        allow(STDIN).to receive(:gets) { "1\n" }
        expect(game.tick!).to be true
      end
      it "returns false when there's a winner" do
        6.times do |col|
          allow(STDIN).to receive(:gets) { "#{(col/2)+1}\n" }
          game.tick!
        end
        allow(STDIN).to receive(:gets) { "4\n" }
        expect(game.tick!).to be false
      end
      it "returns false when the board is full" do
        player3 = Player.new('Y')
        game.add_player(player3)
        41.times do |num|
          col = num % 7 + 1
          allow(STDIN).to receive(:gets) { "#{col}\n" }
          game.tick!
        end
        allow(STDIN).to receive(:gets) { "7\n" }
        expect(game.tick!).to be false
        player3.destroy
      end
    end
  end
end