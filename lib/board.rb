class Board
  attr_reader :num_col, :num_row, :board
  def initialize(num_row=6, num_col=7)
    @num_col   = num_col
    @num_row   = num_row
    @board     = Array.new(num_row) { Array.new(num_col, nil) }
    @num_empty = num_row * num_col

    # keeping track of unfilled row in each column
    @columns = Array.new(num_col) { [].tap { |c| num_row.times { |r| c << r } } }
  end

  def drop_tile_at(col, symbol)
    return false if !col.between?(0, @num_col-1) || @columns[col].empty?
    row = @columns[col].last
    @board[row][col] = symbol
    @columns[col].pop
    @num_empty -= 1
    true
  end

  def has_winner?
    check_row || check_col || check_diag
  end

  def full?
    @num_empty.zero?
  end

  def display
    puts "-" + "-" * @num_col * 4
    @num_row.times do |row|
      print "|"
      @num_col.times do |col|
        content = @board[row][col].nil? ? ' ' : @board[row][col]
        print " #{content} |"
      end
      puts "\n-" + "-" * @num_col * 4
    end
  end

  def clear!
    @board = Array.new(@num_row) { Array.new(@num_col, nil) }
    self
  end

  private
    # TODO: DRY the following two functions
    # and potentially with the four diag functions
    def check_row
      @num_row.times do |row|
        consecutive = 0
        curr_tile = @board[row][0]
        @num_col.times do |col|
          if curr_tile == @board[row][col]
            next unless @board[row][col]  #skip over empty tiles before the first non-empty
            consecutive += 1
            return true if consecutive == 4
          else
            curr_tile = @board[row][col]
            consecutive = 1
          end
        end
      end
      false
    end

    def check_col
      @num_col.times do |col|
        consecutive = 0
        curr_tile = @board[0][col]
        @num_row.times do |row|
          if curr_tile == @board[row][col]
            next unless @board[row][col]
            consecutive += 1
            return true if consecutive == 4
          else
            curr_tile = @board[row][col]
            consecutive = 1
          end
        end
      end
      false
    end

    def check_diag
      return false if @num_col < 4 || @num_row < 4
      check_diag_ne || check_diag_sw || check_diag_nw || check_diag_se
    end

    # TODO: DRY the following four functions
    def check_diag_ne
      0.upto(@num_col - 4) do |col|
        consecutive = 0
        curr_tile = @board[0][col]
        @num_row.times do |row|
          break if col + row == @num_col
          next unless @board[row][col+row]
          if curr_tile == @board[row][col+row]
            consecutive += 1
            return true if consecutive == 4
          else
            curr_tile = @board[row][col+row]
            consecutive = 1
          end
        end
      end
      false
    end

    def check_diag_sw
      1.upto(@num_row - 4) do |row|
        consecutive = 0
        curr_tile = @board[row][0]
        @num_col.times do |col|
          break if row + col == @num_row
          next unless @board[row+col][col]
          if curr_tile == @board[row+col][col]
            consecutive += 1
            return true if consecutive == 4
          else
            curr_tile = @board[row+col][col]
            consecutive = 1
          end
        end
      end
      false
    end

    # logic mirrors check_diag_ne
    def check_diag_nw
      0.upto(@num_col - 4) do |col|
        consecutive = 0
        curr_tile = @board[0][@num_col-1-col]
        @num_row.times do |row|
          break if col + row == @num_col
          next unless @board[row][@num_col-1-col-row]
          if curr_tile == @board[row][@num_col-1-col-row]
            consecutive += 1
            return true if consecutive == 4
          else
            curr_tile = @board[row][@num_col-1-col-row]
            consecutive = 1
          end
        end
      end
      false
    end

    # logic mirrors check_diag_sw
    def check_diag_se
      1.upto(@num_row - 4) do |row|
        consecutive = 0
        curr_tile = @board[row][@num_col-1]
        @num_col.times do |col|
          break if row + col == @num_row
          next unless @board[row+col][@num_col-1-col]
          if curr_tile == @board[row+col][@num_col-1-col]
            consecutive += 1
            return true if consecutive == 4
          else
            curr_tile = @board[row+col][@num_col-1-col]
            consecutive = 1
          end
        end
      end
      false
    end
end