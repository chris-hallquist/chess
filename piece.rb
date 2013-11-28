# -*- coding: utf-8 -*-
require_relative "pieces"

class Piece
  attr_accessor :position, :board, :color

  UNICODE_WHITE = {
    :King =>  "♔",
    :Queen => "♕",
    :Rook => "♖",
    :Bishop => "♗",
    :Knight => "♘",
    :Pawn => "♙"
  }
  UNICODE_BLACK = {
    :King => "♚",
    :Queen => "♛",
    :Rook => "♜",
    :Bishop => "♝",
    :Knight => "♞",
    :Pawn => "♟"
  }

  def initialize(position, board, color)
    @position = position
    @board = board
    board.grid[position[0]][position[1]] = self
    @color = color
  end

  def dup_to_board(new_board)
    self.class.new(@position.dup, new_board, @color)
  end

  def on_board?(coords=position)
    !(coords.min < 0 || coords.max > 7)
  end

  def move_into_check?(new_position)
    duped_board = @board.dup
    duped_board.move!(@position, new_position)
    duped_board.in_check?(@color)
  end

  def valid_moves
    valid_moves = moves
    valid_moves.delete_if do |move|
      (board.occupied?(move) && board.grid[move[0]][move[1]].color == @color)
    end
    valid_moves.delete_if do |move|
      move_into_check?(move)
    end
    valid_moves
  end

  def valid_move?(move)
    valid_moves.include?(move)
  end

  def to_s
    if @color == :white
      UNICODE_WHITE[self.class.to_s.to_sym]
    else
      UNICODE_BLACK[self.class.to_s.to_sym]
    end
  end
end