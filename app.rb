class Board
    attr_accessor :grid, :white, :black, :white_king, :white_queen, :white_rook, :white_bishop, :white_knight, :white_pawn, :black_king, :black_queen, :black_rook, :black_bishop, :black_knight, :black_pawn

    POSSIBLE_KNIGHT_MOVES = [[1, 2] , [1, -2], [-1, 2], [-1, -2], [2, 1], [2, -1], [-2, 1], [-2, -1]].freeze
    POSSIBLE_BISHOP_MOVES = [[-1, -1], [-2, -2], [-3, -3], [-4, -4], [-5, -5], [-6, -6], [-7, -7], [1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7], [-1, 1], [-2, 2], [-3, 3], [-4, 4], [-5, 5], [-6, 6], [-7, 7], [1, -1], [2, -2], [3, -3], [4, -4], [5, -5], [6, -6], [7, -7]].freeze
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
        @white = [white_king, white_queen, white_rook, white_bishop, white_knight, white_pawn]
        @black = [black_king, black_queen, black_rook, black_bishop, black_knight, black_pawn]
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

    def landing_on_friendly_piece?(piece_position, row, collumn)
        if white.include?(grid[piece_position[0]][piece_position[1]])
            if white.include?(grid[row][collumn])
                return true
            end
            #if black include, you're taking a piece
        elsif black.include?(grid[piece_position[0]][piece_position[1]])
            if black.include?(grid[row][collumn])
                return true
            end
            #if white include, you're taking a piece
        end
        false
    end
    def legal_pawn_movement?(piece_position, row, collumn)
        #works for rr
        if piece_position[1] != collumn || grid[row][collumn] != '□' || row >= piece_position[0] || piece_position[0] - 1 != row
            return false
        end
        return true
    end

    def legal_knight_movement?(piece_position, row, collumn)
        #works for rr
        unless landing_on_friendly_piece?(piece_position, row, collumn)
            POSSIBLE_KNIGHT_MOVES.each do |combo|
                if piece_position[0] - combo[0] == row && piece_position[1] + combo[1] == collumn
                    return true
                end
            end
        end
        false
    end

    def bishop_jumped_over_piece?(piece_position, row, collumn)
        #works for rr
        #You could just make 4 if statements to account for the collumns.
        elem_between_row = []
        if piece_position[0] > row
            i = piece_position[0] - 1
            until i == row
                elem_between_row.push(i)
                i -= 1
            end
        else 
            i = piece_position[0] + 1
            until i == row
                elem_between_row.push(i)
                i += 1
            end
        end

        elem_between_col = []
        if piece_position[1] > collumn
            i = piece_position[1] - 1
            until i == collumn
                elem_between_col.push(i)
                i -= 1
            end
        else 
            i = piece_position[1] + 1
            until i == collumn
                elem_between_col.push(i)
                i += 1
            end
        end
        
        unless elem_between_col.length == elem_between_row.length
            return true
        end

        i = 0
        until i == elem_between_row.length
            unless grid[elem_between_row[i]][elem_between_col[i]] == '□'
                return true
            end
            i+=1
        end
        false
    end

    def legal_bishop_movement?(piece_position, row, collumn)
        #works for rr
        unless bishop_jumped_over_piece?(piece_position, row, collumn) || landing_on_friendly_piece?(piece_position, row, collumn)
            POSSIBLE_BISHOP_MOVES.each do |combo|
                if piece_position[0] + combo[0] == row && piece_position[1] + combo[1] == collumn
                    return true
                end
            end
        end
        false
    end

    def rook_jumped_over_piece?(piece_position, row, collumn)
        #works for rr
        if piece_position[0] < row 
            i = piece_position[0] + 1
            until i == row
                unless grid[i][collumn] == '□'
                    return true
                end
                i+=1
            end
        elsif piece_position[0] < row 
            i = piece_position[0] - 1
            until i == row
                unless grid[i][collumn] == '□'
                    return true
                end
                i-=1
            end
        
        elsif piece_position[1] < collumn
            i = piece_position[1] + 1
            until i == collumn
                unless grid[row][i] == '□'
                    return true
                end
                i+=1
            end
        elsif piece_position[1] > collumn
            i = piece_position[1] - 1
            until i == collumn
                unless grid[row][i] == '□'
                    return true
                end
                i-=1
            end
        end
        false
    end
    def legal_rook_movement?(piece_position, row, collumn)
        #works for rr

        #it needs to be Not 0 in one and 0 in the other
        unless rook_jumped_over_piece?(piece_position, row, collumn) || landing_on_friendly_piece?(piece_position, row, collumn)
            if row - piece_position[0] == 0 && collumn - piece_position[1] != 0
                return true
            elsif row - piece_position[0] != 0 && collumn - piece_position[1] == 0
                return true
            else
                return false
            end
        end
        return false
    end

    def legal_queen_movement?(piece_position, row, collumn)
        #works for rr
        if row - piece_position[0] == 0 && collumn - piece_position[1] != 0 || row - piece_position[0] != 0 && collumn - piece_position[1] == 0
            ilegal_check = rook_jumped_over_piece?(piece_position, row, collumn)
        else
            ilegal_check = bishop_jumped_over_piece?(piece_position, row, collumn)
        end
        
        unless ilegal_check || landing_on_friendly_piece?(piece_position, row, collumn)
            if legal_rook_movement?(piece_position, row, collumn) || legal_bishop_movement?(piece_position, row, collumn)
                return true
            else
                return false
            end
        end
        false
    end

    def legal_king_movement?(piece_position, row, collumn)
        #works for rr
        unless landing_on_friendly_piece?(piece_position, row, collumn)
            POSSIBLE_KING_MOVES.each do |combo|
                if piece_position[0] - combo[0] == row && piece_position[1] + combo[1] == collumn
                    return true
                end
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


board = Board.new
board.legal_queen_movement?([-3, 4], -6, 4)