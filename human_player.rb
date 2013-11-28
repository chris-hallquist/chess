class InvalidMove < StandardError
end

class HumanPlayer
  attr_accessor :color

  def play_turn(board)
    puts "Select square to move from in the format \"row, column\""
    start = gets.chomp.gsub(/\s/, '').split(',').map(&:to_i)
    puts "Select square to move to in the format \"row, column\""
    finish = gets.chomp.gsub(/\s/, '').split(',').map(&:to_i)
    if board.occupied?(start) && color_match?(start, board)
      board.move(start, finish)
    else
      raise InvalidMove.new("You don't have a piece at that position.")
    end
  end

  def color_match?(pos,board)
    board.grid[pos[0]][pos[1]].color == @color
  end

end