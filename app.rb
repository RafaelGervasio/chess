class Board
    attr_reader :grid

    def initialize
        @grid = Array.new(8) {Array.new(8) {'empty'}}
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



    
# b = Board.new
# b.display_board