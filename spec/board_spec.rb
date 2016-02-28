require 'spec_helper'
require_relative '../lib/board.rb'

describe Board do
  context "#new" do
    it "creates a 6 by 7 board by default" do
      board = Board.new
      expect(board.num_row).to eq(6)
      expect(board.num_col).to eq(7)
    end
    it "creates custome sized board with arguments" do
      board = Board.new(4, 5)
      expect(board.num_row).to eq(4)
      expect(board.num_col).to eq(5)
    end
  end

  context "#drop_tile_at" do
    subject(:board) { Board.new }
    it "returns true with valid input" do
      expect(subject.drop_tile_at(2, 'X')).to be true
    end
    it "drops tile to the bottom" do
      subject.drop_tile_at(2, 'X')
      expect(subject.board[-1][2]).to eq('X')
    end
    it "piles on existing tile" do
      subject.drop_tile_at(2, 'X')
      subject.drop_tile_at(2, 'X')
      expect(subject.board[board.num_row-2][2]).to eq('X')
    end
    it "returns false when the column is full" do
      board.num_row.times { subject.drop_tile_at(2, 'X') }
      expect(subject.drop_tile_at(2, 'X')).to be false
    end
    it "returns false when the column is not on the board" do
      expect(subject.drop_tile_at(-1, 'X')).to be false
      expect(subject.drop_tile_at(board.num_col, 'X')).to be false
    end
  end

  context "#has_winner?" do
    subject(:board) { Board.new }

    it "returns false with empty board" do
      expect(subject.has_winner?).to be false
    end
    context "check horizontally" do
      it "returns false with less than four consecutive tile" do
        3.times { |i| subject.drop_tile_at(i, 'X') }
        expect(subject.has_winner?).to be false
      end
      it "returns false with four consecutive but different tiles" do
        4.times { |i| subject.drop_tile_at(i, i.to_s) }
        expect(subject.has_winner?).to be false
      end
      it "returns false with less_than_four + gap + less_than_four" do
        7.times { |i| next if i == 3; subject.drop_tile_at(i, 'X') }
        expect(subject.has_winner?).to be false
      end
      it "returns true with four consecutive tiles" do
        4.times { |i| subject.drop_tile_at(i, 'X') }
        expect(subject.has_winner?).to be true
      end
      it "returns true with more than four consecutive tiles" do
        6.times { |i| subject.drop_tile_at(i, 'X') }
        expect(subject.has_winner?).to be true
      end
    end
    context "check vertically" do
      it "returns false with less than four consecutive tile" do
        3.times { subject.drop_tile_at(1, 'X') }
        expect(subject.has_winner?).to be false
      end
      it "returns false with four consecutive but different tiles" do
        4.times { |i| subject.drop_tile_at(1, i.to_s) }
        expect(subject.has_winner?).to be false
      end
      it "returns false with less_than_four + gap + less_than_four" do
        6.times { |i| subject.drop_tile_at(1, (i == 3) ? 'O' : 'X') }
        expect(subject.has_winner?).to be false
      end
      it "returns true with four consecutive tiles" do
        4.times { subject.drop_tile_at(1, 'X') }
        expect(subject.has_winner?).to be true
      end
      it "returns true with mroe than four consecutive tiles" do
        6.times { subject.drop_tile_at(1, 'X') }
        expect(subject.has_winner?).to be true
      end
    end
    context "check diagonally" do
      it "returns false with less than four consecutive tile" do
        input = [
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          ['X', nil, nil, nil, nil, nil, nil],
          ['X', 'X', nil, nil, nil, nil, nil],
          ['X', 'X', 'X', nil, nil, nil, nil],
        ]
        fill_board_with_input(subject, input)
        expect(subject.has_winner?).to be false
        input = [
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, 'X', nil, nil, nil, nil],
          [nil, 'X', 'X', nil, nil, nil, nil],
          ['X', 'X', 'X', nil, nil, nil, nil],
        ]
        subject = Board.new
        fill_board_with_input(subject, input)
        expect(subject.has_winner?).to be false
      end
      it "returns false with four consecutive but different tiles" do
        input = [
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          ['O', nil, nil, nil, nil, nil, nil],
          ['X', 'X', nil, nil, nil, nil, nil],
          ['X', 'X', 'X', nil, nil, nil, nil],
          ['X', 'O', 'X', 'X', nil, nil, nil],
        ]
        fill_board_with_input(subject, input)
        expect(subject.has_winner?).to be false

        input = [
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, 'O', nil, nil, nil],
          [nil, nil, 'X', 'X', nil, nil, nil],
          [nil, 'X', 'X', 'X', nil, nil, nil],
          ['X', 'X', 'O', 'X', nil, nil, nil],
        ]
        subject = Board.new
        fill_board_with_input(subject, input)
        expect(subject.has_winner?).to be false
      end
      it "returns false with less_than_four + gap + less_than_four" do
        input = [
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          ['O', nil, nil, nil, nil, nil, nil],
          ['X', nil, nil, nil, nil, nil, nil],
          ['X', 'X', 'O', nil, nil, nil, nil],
          ['X', 'X', 'X', 'O', nil, nil, nil],
        ]
        fill_board_with_input(subject, input)
        expect(subject.has_winner?).to be false
        input = [
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, 'O', nil, nil, nil],
          [nil, nil, nil, 'X', nil, nil, nil],
          [nil, 'O', 'X', 'X', nil, nil, nil],
          ['O', 'X', 'X', 'X', nil, nil, nil],
        ]
        subject = Board.new
        fill_board_with_input(subject, input)
        expect(subject.has_winner?).to be false
      end
      it "returns true with four consecutive tiles" do
        input = [
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          ['O', nil, nil, nil, nil, nil, nil],
          ['X', 'O', nil, nil, nil, nil, nil],
          ['X', 'X', 'O', nil, nil, nil, nil],
          ['X', 'X', 'X', 'O', nil, nil, nil],
        ]
        fill_board_with_input(subject, input)
        expect(subject.has_winner?).to be true
        input = [
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, 'O', nil, nil, nil],
          [nil, nil, 'O', 'X', nil, nil, nil],
          [nil, 'O', 'X', 'X', nil, nil, nil],
          ['O', 'X', 'X', 'X', nil, nil, nil],
        ]
        subject = Board.new
        fill_board_with_input(subject, input)
        expect(subject.has_winner?).to be true
      end
      it "returns true with mroe than four consecutive tiles" do
        input = [
          [nil, nil, nil, nil, nil, nil, nil],
          ['O', nil, nil, nil, nil, nil, nil],
          ['O', 'O', nil, nil, nil, nil, nil],
          ['X', 'X', 'O', nil, nil, nil, nil],
          ['X', 'X', 'O', 'O', nil, nil, nil],
          ['X', 'X', 'X', 'O', 'O', nil, nil],
        ]
        fill_board_with_input(subject, input)
        expect(subject.has_winner?).to be true
        input = [
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, 'O', nil, nil],
          [nil, nil, nil, 'O', 'O', nil, nil],
          [nil, nil, 'O', 'X', 'X', nil, nil],
          [nil, 'O', 'O', 'X', 'X', nil, nil],
          ['O', 'O', 'X', 'X', 'X', nil, nil],
        ]
        subject = Board.new
        fill_board_with_input(subject, input)
        expect(subject.has_winner?).to be true
      end
    end
  end

  context "#clear!" do
    subject(:board) { Board.new }
    it "clears the board" do
      clear_board = Array.new(subject.num_row) { Array.new(subject.num_col, nil) }
      input = [
          [nil, nil, nil, nil, nil, nil, nil],
          ['O', nil, nil, nil, nil, nil, nil],
          ['O', 'O', nil, nil, nil, nil, nil],
          ['X', 'X', 'O', nil, nil, nil, nil],
          ['X', 'X', 'O', 'O', nil, nil, nil],
          ['X', 'X', 'X', 'O', 'O', nil, nil],
        ]
      fill_board_with_input(subject, input)
      expect(subject.clear!.board).to eq(clear_board)
    end
  end
end