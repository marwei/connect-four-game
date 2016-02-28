Dir[File.join(File.dirname(__FILE__), 'lib/*')].each { |f| require f }

game = Game.new(Board.new)

game.add_player(Player.new('X'))
game.add_player(Player.new('O'))

loop do
  game.board.display
  break unless game.tick!
end

puts "Final Board"
game.board.display