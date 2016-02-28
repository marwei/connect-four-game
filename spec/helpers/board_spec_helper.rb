module BoardSpecHelper
  def fill_board_with_input(board, input)
    (input.size-1).downto(0) do |i|
      board.num_col.times { |j| board.drop_tile_at(j, input[i][j]) }
    end
  end
end