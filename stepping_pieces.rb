require_relative "pieces"

class SteppingPiece < Piece
  def moves
    moves = []
    shifts.each do |shift|
      current_pos = [@position[0] + shift[0], @position[1] + shift[1]]
      moves << current_pos if on_board?(current_pos)
    end
    moves
  end
end

class Knight < SteppingPiece
  def shifts
            [
    [-2, -1],
    [-2, 1],
    [-1, -2],
    [-1, 2],
    [1, -2],
    [1, 2],
    [2, -1],
    [2, 1],
  ]
  end
end

class King < SteppingPiece
  def shifts
            [
    [-1, -1],
    [-1, 0],
    [-1, 1],
    [0, -1],
    [0, 1],
    [1, -1],
    [1, 0],
    [1, 1],
  ]
  end

end

if __FILE__ == $PROGRAM_NAME
  board = Board.new
  white_king = King.new([1,4], board, :white)
  black_pawn = Pawn.new([4,3], board, :black)
  p white_pawn.moves
end