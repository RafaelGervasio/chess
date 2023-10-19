class Board
    attr_accessor :grid, :white_king, :white_queen, :white_rook, :white_bishop, :white_knight, :white_pawn, :black_king, :black_queen, :black_rook, :black_bishop, :black_knight, :black_pawn

    POSSIBLE_KNIGHT_MOVES = [[1, 2] , [1, -2], [-1, 2], [-1, -2], [2, 1], [2, -1], [-2, 1], [-2, -1]].freeze
    POSSIBLE_BISHOP_MOVES = [[-1, -1] [-2, -2], [-3, -3], [-4, -4], [-5, -5], [-6, -6], [-7, -7] [1, 1] [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7]].freeze
    POSSIBLE_KING_MOVES = [ [1,1], [-1, -1], [1, -1], [-1, 1], [1, 0], [0, 1], [-1, 0], [0, -1]].freeze
    

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
    def update_board (piece, piece_position, row, collumn)
        temp = piece
        grid[piece_position[0]][piece_position[1]] = '□'
        grid[row][collumn] = temp
    end

    def legal_move?(piece, piece_position, row, collumn)
        #works for rr
        if outside_board?(row, collumn) || find_piece(piece, row, collumn) == false || legal_piece_movement?(piece, piece_position, row, collumn) == false
            false
        else
            true
        end
    end
        
    def outside_board?(row, collumn)
        #works for rr
        check = false
        grid[row].nil? ? check = true : ''
        check == true ? '' : grid[row][collumn].nil? ? check = true : ''
        
        check
    end

    def get_piece(piece, turn, row, collumn)
        #works for rr
        if piece == 'p'
            turn == 'white' ? piece = white_pawn : piece = black_pawn
        elsif piece == 'n'
            p 'NNN'
            turn == 'white' ? piece = white_knight : piece = black_knight
        elsif piece == 'b'
            turn == 'white' ? piece = white_bishop : piece = black_bishop

        elsif piece == 'r'
            turn == 'white' ? piece = white_rook : piece = black_rook
        
        #These ones are easy, there's only one of them (unless there's two queens on the board!)
        elsif piece == 'q'
            turn == 'white' ? piece = white_queen : piece = black_queen
        
        elsif piece == 'k'
            turn == 'white' ? piece = white_king : piece = black_king
        end
        piece
    end

    def legal_piece_movement? (piece, piece_position, row, collumn)
        #works for rr
        if piece == white_pawn || piece == black_pawn
            legal_pawn_movement?(piece_position, row, collumn)
        elsif piece == white_knight || piece == black_knight
            legal_knight_movement?(piece_position, row, collumn)
        elsif piece == white_bishop || piece == black_bishop
            legal_bishop_movement?(piece_position, row, collumn)
        elsif piece == white_rook || piece == black_rook
            legal_rook_movement?(piece_position, row, collumn)
        elsif piece == white_queen || piece == black_queen
            legal_queen_movement?(piece_position, row, collumn)
        elsif piece = white_king || piece == black_king
            legal_king_movement?(piece_position, row, collumn)
        end
    end
        
    def find_piece (piece, row, collumn)
        #works for rr
        if piece == white_pawn || piece == black_pawn
            if grid[row + 1][collumn] == piece
                return [row + 1, collumn]
            end
        else
            grid.each_with_index do |row, i|
                if row.index(piece).nil?
                    next
                else
                    j = row.index(piece)
                    return [i-8, j]
                end
            end
        end
        return false
    end

    def legal_pawn_movement?(piece_position, row, collumn)
        #works for rr

        unless piece_position[0] - 1 == row
            return false
        end
        if grid[row][collumn] != '□'
            return false
        end
        return true
    end

    def legal_knight_movement?(piece_position, row, collumn)
        #works for rr
        POSSIBLE_KNIGHT_MOVES.each do |combo|
            if piece_position[0] - combo[0] == row && piece_position[1] + combo[1] == collumn
                return true
            end
        end
        false
    end

    def bishop_jumped_over_piece?(piece_position, row, collumn)
        #works for rr
        diff = row - piece_position[0]
        squares_between_start_end = diff - 1
        if squares_between_start_end > 0
            i = 1
            until i > squares_between_start_end
                if grid[piece_position[0]-i][piece_position[1]+i] != '□'
                    return false
                end
                i+=1
            end
        else
            i = -1
            until i < squares_between_start_end
                if grid[piece_position[0]+i][piece_position[1]-i] != '□'
                    return false
                end
                i-=1
            end
        end
        true
    end

    def legal_bishop_movement?(piece_position, row, collumn)
        #works for rr
        unless bishop_jumped_over_piece?(piece_position, row, collumn)
            POSSIBLE_BISHOP_MOVES.each do |combo|
                if piece_position[0] - combo[0] == row && piece_position[1] + combo[1] == collumn
                    return true
                end
            end
            false
        end
    end

    def rook_jumped_over_piece?(piece_position, row, collumn)
        #works for rr
        if piece_position[0] - row != 0 
            diff = row + piece_position[0]
            squares_between_start_end = diff - 1
            if squares_between_start_end > 0
                i = 1
                until i > squares_between_start_end
                    if grid[piece_position[0]-i][collumn] != '□'
                        return false
                    end
                    i+=1
                end
            else
                i = -1
                until i < squares_between_start_end
                    if grid[piece_position[0]+i][collumn] != '□'
                        return false
                    end
                    i-=1
                end
            end
        elsif piece_position[1] - collumn != 0 
            diff = collumn - piece_position[1]
            squares_between_start_end = diff - 1
            if squares_between_start_end > 0
                i = 1
                until i > squares_between_start_end
                    if grid[row][piece_position[1]-i] != '□'
                        return false
                    end
                    i+=1
                end
            else
                i = -1
                until i < squares_between_start_end
                    if grid[row][piece_position[1]+i] != '□'
                        return false
                    end
                    i-=1
                end
            end
        end
        true
    end
    def legal_rook_movement?(piece_position, row, collumn)
        #works for rr

        #it needs to be Not 0 in one and 0 in the other
        unless rook_jumped_over_piece?(piece_position, row, collumn)
            if row - piece_position[0] == 0 && collumn - piece_position[1] != 0
                return true
            elsif row - piece_position[0] != 0 && collumn - piece_position[1] == 0
                return true
            elsif row - piece_position[0] != 0 && collumn - piece_position[1] != 0
                return true
            else
                return false
            end
        end
    end

    def legal_queen_movement?(piece_position, row, collumn)
        #works for rr
        unless bishop_jumped_over_piece?(piece_position, row, collumn) || rook_jumped_over_piece?(piece_position, row, collumn)
            if legal_rook_movement?(piece_position, row, collumn) || legal_bishop_movement?(piece_position, row, collumn)
                return true
            else
                return false
            end
        end
    end

    def legal_king_movement?(piece_position, row, collumn)
        #works for rr
        POSSIBLE_KING_MOVES.each do |combo|
            if piece_position[0] - combo[0] == row && piece_position[1] + combo[1] == collumn
                return true
            end
        end
        false
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


        puts "It's #{turn}'s turn. Make a move"
        puts "-------"
        puts "-------"
        
        puts "Choose piece (k, q, r, b, n, p)"
        piece = gets.chomp
        puts "Choose row: "
        row = -(gets.chomp.to_i)
        puts "Choose collumn: "
        collumn = gets.chomp.to_i - 1

        
        puts "-------"
        puts "-------"

        piece = board.get_piece(piece, turn, row, collumn)
        piece_position = board.find_piece(piece, row, collumn)

        unless board.legal_move?(piece, piece_position, row, collumn)
            puts 'Invalid move'
            return
        end
    
        board.update_board(piece, piece_position, row, collumn)        
        board.display_board()
    end
end

