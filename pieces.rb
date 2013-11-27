require_relative "board"

class Piece
  attr_accessor :position, :board, :color

  def initialize(position, board, color)
    @position = position
    @board = board
    board.grid[position[0]][position[1]] = self
    @color = color
  end

  def on_board?(coords=position)
    !(coords.min < 0 || coords.max > 7)
  end

  def move_into_check?(position)
  end
end