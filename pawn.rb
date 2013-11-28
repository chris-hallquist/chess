class Pawn < Piece
  attr_reader :direction

  def initialize(position, board, color)
    super(position, board, color)
    if @color == :white
      @direction = 1
    elsif @color == :black
      @direction = -1
    end
  end

  def moves
    moves = []

    if !board.occupied?([position[0] + @direction, position[1]])
      moves << [position[0] + @direction, position[1]]

      if @color == :white && position[0] == 1 &&
        !board.occupied?([3, position[1]])
        moves << [3, position[1]]
      end

      if @color == :black && position[0] == 6 &&
        !board.occupied?([4, position[1]])
        moves << [4, position[1]]
      end
    end

    possible_captures = [
      [position[0] + @direction, position[1] - 1],
      [position[0] + @direction, position[1] + 1]
    ]

    possible_captures.each { |move| moves << move if board.occupied?(move) }

    moves
  end

end