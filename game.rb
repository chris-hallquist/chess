require_relative "board"
require_relative "human_player"
require 'debugger'

class Game
  attr_accessor :board, :white_player, :black_player

  def initialize(white_player, black_player)
    @board = Board.new
    @board.setup
    @white_player = white_player
    @white_player.color = :white
    @black_player = black_player
    @black_player.color = :black
  end

  def play
    current_player = @white_player
    until game_over?
      @board.display
      begin
        current_player.play_turn(@board)
      rescue InvalidMove => e
        puts e.message
        retry
      end
      if current_player == @white_player
        current_player = @black_player
      else
        current_player = @white_player
      end
    end
  end

  def game_over?
    @board.checkmate?(:white) || @board.checkmate?(:black)
  end

end

if __FILE__ == $PROGRAM_NAME
  TESTG = Game.new(HumanPlayer.new, HumanPlayer.new)
  TESTG.board.move([1, 4], [3, 4])
  TESTG.board.display
  TESTG.board.move([6, 4], [4, 4])
  TESTG.board.display
  TESTG.board.move([0, 5], [3, 2])
  TESTG.board.display
  TESTG.board.move([7, 5], [4, 2])
  TESTG.board.display
  TESTG.board.move([0, 3], [4, 7])
  TESTG.board.display
  TESTG.board.move([7, 1], [5, 2])
  TESTG.board.display
  TESTG.board.move([4, 7], [6, 5])
  TESTG.board.display
  puts "Checkmade!" if TESTG.game_over?
end
