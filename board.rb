require_relative "pieces"
require_relative "sliding_pieces"
require_relative "stepping_pieces"
require_relative "pawn"

class Board
  attr_accessor :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) }
  end

  def occupied?(position)
    return true if @grid[position[0]][position[1]]
    false
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

    each_with_coords do |square, row_index, col_index|
      next if square == nil || square.color == color
      return true if square.moves.include?(king_position)
    end
    false
  end

  def each_with_coords(&prc)
    @grid.each_with_index do |row, row_index|
      row.each_with_index do |square, col_index|
        prc.call(square, row_index, col_index)
      end
    end
  end

  def move(start, final)
    raise "No piece present" unless occupied?(start)
    piece = @grid[start[0]][start[1]]
    raise "Can't move there" unless piece.moves.include?(final)
    @grid[final[0]][final[1]] = piece
    @grid[start[0]][start[1]] = nil
    piece.position = final
  end

  def dup_piece(piece, new_board)
    piece.class.new(piece.position.dup, new_board, piece.color)
  end

  def dup
    new_board = Board.new
    each_with_coords do |square, row_index, col_index|
      if square == nil
        new_board.grid[row_index][col_index] = nil
      else
        new_board.grid[row_index][col_index] = dup_piece(square, new_board)
      end
    end
    new_board
  end




end

