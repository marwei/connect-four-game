class Player
  attr_reader :name, :symbol
  @@player_count = 1
  @@symbols = []

  def initialize(symbol, name)
    @symbol = symbol
    @name   = name
  end

  def self.new(symbol, name="Player#{@@player_count}")
    return nil if @@symbols.include? symbol
    @@symbols << symbol
    @@player_count += 1
    super(symbol, name)
  end

  def destroy
    @@player_count -= 1
    @@symbols.delete(@symbol)
    @symbol = nil
    @name = nil
    nil
  end

  def drop_tile_at(board, col)
    board.drop_tile_at(col, @symbol)
  end
end