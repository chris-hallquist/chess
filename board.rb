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

    @grid[0][0] = Rook.new([0,0], self, :white)
    @grid[0][7] = Rook.new([0,7], self, :white)
    @grid[7][0] = Rook.new([7,0], self, :black)
    @grid[7][7] = Rook.new([7,7], self, :black)

    @grid[0][1] = Knight.new([0,1], self, :white)
    @grid[0][6] = Knight.new([0,6], self, :white)
    @grid[7][1] = Knight.new([7,1], self, :black)
    @grid[7][6] = Knight.new([7,6], self, :black)

    @grid[0][2] = Bishop.new([0,2], self, :white)
    @grid[0][5] = Bishop.new([0,5], self, :white)
    @grid[7][2] = Bishop.new([7,2], self, :black)
    @grid[7][5] = Bishop.new([7,5], self, :black)

    @grid[0][3] = Queen.new([0,3], self, :white)
    @grid[7][3] = Queen.new([7,3], self, :black)

    @grid[0][4] = King.new([0,4], self, :white)
    @grid[7][4] = King.new([7,4], self, :black)
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
    @grid.reverse.each do |row|
      row.each do |square|
        if square == nil
          display << "_"
        else
          display << square.to_s
        end
        display << "|"
      end
      display << "\n"
    end
    puts display
  end
end

