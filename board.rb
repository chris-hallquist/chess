require_relative "pieces"
require "colorize"

class InvalidMove < StandardError
end

class Board
  attr_accessor :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) }
  end

  def setup
    @grid[1].each_with_index do |square, index|
      square = Pawn.new([1,index], self, :white)
    end
    @grid[6].each_with_index do |square, index|
      square = Pawn.new([6,index], self, :black)
    end

    back_row = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
    back_row.each_with_index do |klass, i|
      klass.new([0, i], self, :white)
    end
    back_row = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
    back_row.each_with_index do |klass, i|
      klass.new([7, i], self, :black)
    end
  end

  def occupied?(position)
    !!@grid[position[0]][position[1]]
  end

  def find_king(color)
    each_with_coords do |square, row_index, col_index|
      if square.class == King && square.color == color
        return [row_index, col_index]
      end
    end
    raise "King not found"
  end

  def in_check?(color)
    king_position = find_king(color)

    each_with_coords do |piece, row_index, col_index|
      next if piece == nil || piece.color == color
      return true if piece.moves.include?(king_position)
    end
    false
  end

  def other_color(color)
    color == :white ? :black : :white
  end

  def each_with_coords(&prc)
    @grid.each_with_index do |row, row_index|
      row.each_with_index do |square, col_index|
        prc.call(square, row_index, col_index)
      end
    end
  end

  def move!(start, final)
    piece = @grid[start[0]][start[1]]
    @grid[final[0]][final[1]] = piece
    @grid[start[0]][start[1]] = nil
    piece.position = final
  end

  def move(start, final)
    raise InvalidMove.new ("No piece present") unless occupied?(start)
    piece = @grid[start[0]][start[1]]
    raise InvalidMove.new("Cannot move there") unless piece.valid_move?(final)
    move!(start,final)
  end

  def dup
    new_board = Board.new
    each_with_coords do |square, row_index, col_index|
      if square == nil
        new_board.grid[row_index][col_index] = nil
      else
        new_board.grid[row_index][col_index] = square.dup_to_board(new_board)
      end
    end
    new_board
  end

  def checkmate?(color)
    if in_check?(color)
      return pieces_of_color(color).all? do |piece|
        piece.valid_moves.empty?
      end
    end
    false
  end

  def pieces_of_color(color)
    pieces = []
    each_with_coords do |square, row_index, col_index|
      next if square == nil
      pieces << square if square.color == color
    end
    pieces
  end

  def display
    display = ""
    green_square = false
    @grid.reverse.each do |row|
      row.each do |square|

        if square == nil
          display << "  "
        else
          display << "#{square.to_s} "
        end
        display[-2..-1] = color_square(display[-2..-1], green_square)
        green_square = !green_square
      end
      display << "\n"
      green_square = !green_square
    end
    puts display
  end

  def color_square(square, green_square)
    if green_square
      square = square.black.on_green
    else
      square = square.black.on_white
    end
  end
end

