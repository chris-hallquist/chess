require_relative "pieces"

class SlidingPiece < Piece
  DIAG_STEPS = [
    [-1,-1],
    [-1, 1],
    [1, -1],
    [1, 1]
  ]
  HV_STEPS = [
    [1, 0],
    [-1, 0],
    [0,1],
    [0, -1]
  ]

  # Returns moves, without considering check or
  # color of piece in square being moved to
  def moves
    moves = []

    if move_dirs[:diagonal] && move_dirs[:horz_vert]
      steps = DIAG_STEPS + HV_STEPS
    elsif move_dirs[:diagonal]
      steps = DIAG_STEPS
    elsif move_dirs[:horz_vert]
      steps = HV_STEPS
    end

    steps.each do |step|
      current_pos = [@position[0]+step[0], @position[1]+step[1]]
      while on_board?(current_pos)
        moves << current_pos
        break if @board.occupied?(current_pos)
        # Break stops moving past other pieces.
        # Includes captures, even "capturing" own pieces!
        current_pos = [current_pos[0]+step[0], current_pos[1]+step[1]]
      end
    end

    moves
  end

end

class Bishop < SlidingPiece
  def move_dirs
    {diagonal: true, horz_vert: false}
  end
end

class Rook < SlidingPiece
  def move_dirs
    {diagonal: false, horz_vert: true}
  end
end

class Queen < SlidingPiece
  def move_dirs
    {diagonal: true, horz_vert: true}
  end
end