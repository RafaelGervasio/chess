class Board
    attr_accessor :grid, :white_king, :white_queen, :white_rook, :white_bishop, :white_knight, :white_pawn, :black_king, :black_queen, :black_rook, :black_bishop, :black_knight, :black_pawn

    def initialize
        @grid = Array.new(8) {Array.new(8) {'□'}}
        @white_king = "♔"
        @white_queen = "♕"
        @white_rook = "♖"
        @white_bishop = "♗"
        @white_knight = "♘"
        @white_pawn = "♙"
        @black_king = "♚"
        @black_queen = "♛"
        @black_rook = "♜"
        @black_bishop = "♝"
        @black_knight = "♞"
        @black_pawn = "♟" 
        populate_board()
    end
    def populate_board
        grid[1] = grid[-1].map { |elem| elem = black_pawn }
        grid[0][0] = black_rook
        grid[0][-1] = black_rook
        grid[0][1] = black_knight
        grid[0][-2] = black_knight
        grid[0][2] = black_bishop
        grid[0][-3] = black_bishop
        grid[0][3] = black_queen
        grid[0][-4] = black_king

        grid[-2] = grid[-1].map { |elem| elem = white_pawn }
        grid[-1][0] = white_rook
        grid[-1][-1] = white_rook
        grid[-1][1] = white_knight
        grid[-1][-2] = white_knight
        grid[-1][2] = white_bishop
        grid[-1][-3] = white_bishop
        grid[-1][3] = white_queen
        grid[-1][-4] = white_king
      end
      
    
    def display_board
        grid.each do |row|
            puts row.join(' ')
        end
    end

end

class Players
    def initialize (piece_color, name)
        @piece_color = piece_color
        @name = name
    end
end

class Game
    def initialize
        @board = Board.new
        @p1 = Players.new('white', set_player_name(1))
        @p2 = Players.new('black', set_player_name(2))
    end

    def set_player_name(number)
        puts "Player #{number}, what's your name?"
        gets.chomp
    end
end


b = Board.new
b.display_board