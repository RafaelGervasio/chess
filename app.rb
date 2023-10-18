class Board
    attr_accessor :grid, :white_king, :white_queen, :white_rook, :white_bishop, :white_knight, :white_pawn, :black_king, :black_queen, :black_rook, :black_bishop, :black_knight, :black_pawn

    POSSIBLE_KNIGHT_MOVES = [[1, 2] , [1, -2], [-1, 2], [-1, -2], [2, 1], [2, -1], [-2, 1], [-2, -1]].freeze

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
    def update_board(piece, row, collumn, turn)
        turn == 'white' ? piece = white_knight : piece = black_knight
        current_position = find_knight(turn)
        grid[row][collumn] = piece
        grid[current_position[0]][current_position[1]] = '□'
        display_board()
    end

    def legal_move?(piece, row, collumn, turn)
        if piece == 'n'
            unless check_knight(row, collumn, turn)
               return false
            end
        elsif piece == 'p'
        end
        end


        check = true
        #check univeral rules, if they don't pass, return false and stop function
        
        grid[row].nil? ? check = false : ''
        check == false ? '' : grid[row][collumn].nil? ? check = false : ''
        
        #- You can’t make a move that results in you being in check next turn
            # - A pinned knight
            # - A king in check - you can’t move another pice unless it gets you out of check
        # You can’t go trough a piece (unless if you’re a knight)

        #check piece based rules, if they don't pass, return false and stop function


        #return true
        check
    end

    def check_knight(row, collumn, turn)
        knight_pos = find_knight(turn)
        if knight_pos == false
            return false
        end

        POSSIBLE_KNIGHT_MOVES.each do |combo|
            if knight_pos[0] + combo[0] == row && knight_pos[1] + combo[1] == collumn
                return true
            end
        end
        false
    end
    def find_knight(turn)
        turn == 'white' ? piece = white_knight : piece = black_knight
        grid.each_with_index do |row, i|
            if row.index(piece).nil?
                next
            else
                j = row.index(piece)
                return [i, j]
            end
        end
        return false
    end


    def take_piece?
        #check if a player is taking a piece
    end

end

class Players
    attr_reader :piece_color, :name 
    def initialize (piece_color)
        @piece_color = piece_color
    end
end

class Game
    attr_reader :p1, :p2, :board
    attr_accessor :turn

    def initialize
        @board = Board.new
        @p1 = Players.new('white')
        @p2 = Players.new('black')
        @turn = p1.piece_color
    end

    def switch
        turn == p1.piece_color ? turn = p2.piece_color : turn = p1.piece_color
    end

    def play_game
        setup()
        #until game_over?
            play_round()
    end

    def setup
        #intro message
        #create create players
    end

    def play_round
        board.display_board
        puts "-------"
        puts "-------"
        puts "-------"

        puts "It's #{turn}'s turn. Make a move"
        puts "-------"
        puts "-------"
        
        puts "Choose piece (k, q, r, b, n, p): "
        piece = gets.chomp
        puts "Choose row: "
        row = 7 - gets.chomp.to_i
        puts "Choose collumn: "
        collumn = gets.chomp.to_i
        
        puts "-------"
        puts "-------"

        if board.legal_move?(piece, row, collumn, turn)
            board.update_board(piece, row, collumn, turn)
            turn.switch
        end


        #If board.legal_move?(piece, row, collumn, turn)
            #Make the move, aka, update the borard
            #If take piece, update the board too.
        #If not, display move not allowed error, and recall playround
        #Change the turn
    end
end


g = Game.new
g.play_round
g.play_round
# g.board.display_board