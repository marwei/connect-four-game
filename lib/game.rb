require_relative 'board'
require_relative 'player'

class Game
  attr_reader :name, :board, :num_player, :players, :turn
  def initialize(board, name='Connect Four')
    @name       = name
    @board      = board
    @num_player = 0
    @players    = []
    @turn       = 0
  end

  def add_player(player)
    return false unless player
    return false if @players.include? player
    @players << player
    @num_player += 1
    true
  end

  def clear_board!
    @board.clear!
  end


  # return true when the game can still continue, otherwise false
  # false => win, or tie
  def tick!
    if @num_player < 2
      puts "At least two players are needed to play the game"
      return false
    end

    player = players[@turn % num_player]

    loop do
      puts "#{player.name}: Please enter a column number: (1 to #{@board.num_col})"
      col = (STDIN::gets).to_i - 1
      break if player.drop_tile_at(@board, col) || @board.full?
      puts "Invalid input"
    end

    if @board.has_winner?
      puts "Congratulations, #{player.name}, you win!"
      return false
    end

    if @board.full?
      puts "Game over"
      return false
    end

    @turn += 1

    true
  end
end
