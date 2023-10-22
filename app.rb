module Pieces
    attr_accessor :white_king, :white_queen, :white_rooks, :white_bishops, :white_knights, :white_pawns, :white_pieces,
    :black_king, :black_queen, :black_rooks, :black_bishops, :black_knights, :black_pawns, :black_pieces
    
    def create_pieces
        @white_king = ["♔", false]
        @white_queen = ["♕", false]
        @white_rooks = [["♖", false], ["♖", false]]
        @white_bishops = [["♗", false], ["♗", false]]
        @white_knights = [["♘", false], ["♘", false]]
        @white_pawns = []
        @white_pieces = [white_king, white_queen, white_rooks, white_bishops, white_knights, white_pawns]
        
        @black_king = ["♚", false]
        @black_queen = ["♚", false]
        @black_rooks = [["♜", false], ["♜", false]]
        @black_bishops = [["♝", false], ["♝", false]]
        @black_knights = [["♞", false], ["♞", false]]
        @black_pawns = []
        @black_pieces = [black_king, black_queen, black_rooks, black_bishops, black_knights, black_pawns]
        
        populate_pawns()
    end

    def populate_pawns
        (1..8).each do |i|
            white_pawns.push(["♙", false])
            black_pawns.push(["♟", false])
        end
    end
end
  
class Board
    include Pieces
    attr_accessor :grid 

    POSSIBLE_PAWN_MOVES = [-1, 0].freeze
    POSSIBLE_KNIGHT_MOVES = [[1, 2] , [1, -2], [-1, 2], [-1, -2], [2, 1], [2, -1], [-2, 1], [-2, -1]].freeze
    POSSIBLE_BISHOP_MOVES = [[-1, -1], [-2, -2], [-3, -3], [-4, -4], [-5, -5], [-6, -6], [-7, -7], [1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7], [-1, 1], [-2, 2], [-3, 3], [-4, 4], [-5, 5], [-6, 6], [-7, 7], [1, -1], [2, -2], [3, -3], [4, -4], [5, -5], [6, -6], [7, -7]].freeze
    POSSIBLE_ROOK_MOVES = [[-1, 0], [-2, 0], [-3, 0], [-4, 0], [-5, 0], [-6, 0], [-7, 0], [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7]].freeze
    POSSIBLE_QUEEN_MOVES = POSSIBLE_BISHOP_MOVES + POSSIBLE_ROOK_MOVES
    POSSIBLE_KING_MOVES = [ [1,1], [-1, -1], [1, -1], [-1, 1], [1, 0], [0, 1], [-1, 0], [0, -1]].freeze

    #then you have all the moves

    def initialize
        @grid = Array.new(8) {Array.new(8) {'□'}}
        create_pieces()
        populate_board()
        populate_piece_coordinates()
    end

    def populate_board
        (0..7).each do |i|
            grid[-7][i] = black_pawns[i]
        end        
        (0..7).each do |i|
            grid[-2][i] = white_pawns[i]
        end

        grid[0][0] = black_rooks[0]
        grid[0][-1] = black_rooks[1]
        grid[0][2] = black_bishops[0]
        grid[0][-3] = black_bishops[1]
        grid[0][1] = black_knights[0]
        grid[0][-2] = black_knights[1]
        grid[0][3] = black_queen
        grid[0][-4] = black_king
        
        grid[-1][0] = white_rooks[0]
        grid[-1][-1] = white_rooks[1]
        grid[-1][1] = white_knights[0]
        grid[-1][-2] = white_knights[1]
        grid[-1][2] = white_bishops[0]
        grid[-1][-3] = white_bishops[1]
        grid[-1][3] = white_queen
        grid[-1][-4] = white_king
      end
      
    
    def display_board
        grid.each do |row|
            row.each do |piece|
                print piece[0]
                print ' '
            end
            puts ''
        end
    end
    
    def populate_piece_coordinates
        grid.each do |row|
            row.each {|elem| elem == '□' ? '' : find_piece_cordinates(elem) }
        end
    end
    
    def find_piece_cordinates(piece)
        grid.each_with_index do |row, i|
            if row.index(piece).nil?
                next
            else
                j = row.index(piece)
                piece[2] = [i-8, j]
            end
        end
    end

    def get_color(row, collumn)
        piece = grid[row][collumn]
        if piece == white_king || piece == white_queen || white_rooks.include?(piece) || white_bishops.include?(piece) || 
            white_knights.include?(piece) || white_pawns.include?(piece)
            return 'white'
        else    
            return 'black'
        end
    end


    def update_board (piece, piece_position, row, collumn)
        #Here's a problem
        #Piece is hust 'white_pawn', not that speciic array. 
        #So you're deleting the array and moving the pawn forward with just the white_pawn symbol
        #The moved and coordinates in the array are lost
        temp = piece
        grid[piece_position[0]][piece_position[1]] = '□'
        grid[row][collumn] = nil
        grid[row][collumn] = temp
    end

    def outside_board?(row, collumn)
        #works for rr
        check = false
        grid[row].nil? ? check = true : ''
        check == true ? '' : grid[row][collumn].nil? ? check = true : ''
        
        check
    end

    def find_pawn(turn, row, collumn)
        if turn == 'white'
            if white_pawns.none? {|pawn| pawn[2][1] == collumn}
                return false
            else
                piece = white_pawns.find {|pawn| pawn[2][1] == collumn}
            end
        else
            if black_pawns.none? {|pawn| pawn[2][1] == collumn}
                return false
            else
                piece = black_pawns.find {|pawn| pawn[2][1] == collumn}
        end
        return piece
    end

    def find_knight(turn, row, collumn)
        if turn == 'white'
            if legal_knight_movement?(white_knights[0][2], row, collumn, turn)
                piece = white_knights[0]
            elsif legal_knight_movement?(white_knights[1][2], row, collumn, turn)
                piece = white_knights[1]
            else
                return false
            end
        else
            if legal_knight_movement?(black_knights[0][2], row, collumn, turn)
                piece = black_knights[0]
            elsif legal_knight_movement?(black_knights[1][2], row, collumn, turn)
                piece = black_knights[1]
            else
                return false
            end
        end
        return piece
    end

    def find_bishop(turn, row, collumn)
        if turn == 'white'
            if legal_bishop_movement?(white_bishops[0][2], row, collumn, turn)
                piece = white_bishops[0]
            if legal_bishop_movement?(white_bishops[1][2], row, collumn, turn)
                piece = white_bishops[1]
            else
                return false
            end
        else
            if legal_bishop_movement?(black_bishops[0][2], row, collumn, turn)
                piece = black_bishops[0]
            if legal_bishop_movement?(black_bishops[1][2], row, collumn, turn)
                piece = black_bishops[1]
            else
                return false
            end
        end
        return piece
    end

    def find_rook(turn, row, collumn)
        if turn == 'white'
            if legal_rook_movement?(white_rooks[0][2], row, collumn, turn)
                piece = white_rooks[0]
            if legal_rook_movement?(white_rooks[1][2], row, collumn, turn)
                piece = white_rooks[1]
            else
                return false
            end
        else
            if legal_rook_movement?(black_rooks[0][2], row, collumn, turn)
                piece = black_rooks[0]
            if legal_rook_movement?(white_rooks[1][2], row, collumn, turn)
                piece = black_rooks[1]
            else
                return false
            end
        end
        return piece
    end

    def find_piece(piece_letter, turn, row, collumn)
        if piece_letter == 'p'
            piece = find_pawn(turn, row, collumn)
        elsif piece_letter == 'n'
            piece = find_knight(turn, row, collumn)
        elsif piece_letter == 'b'
            piece = find_bishop(turn, row, collumn)
        elsif piece_letter == 'r'
            piece = find_rook(turn, row, collumn)
        elsif piece_letter == 'q'
            turn == 'white' ? piece = white_queen : piece = black_queen
        elsif piece_letter == 'k'
            turn == 'white' ? piece = white_king : piece = black_king
        end
        return piece
    end
    
    def legal_piece_move?(piece, row, collumn, turn)       
        if white_pawns.include?(piece) || black_pawns.include?(piece)
            return legal_pawn_movement?(piece, row, collumn)
        elsif white_knights.include?(piece) || black_knights.include?(piece)
            return legal_knight_movement?(piece, row, collumn)
        elsif white_bishops.include?(piece) || black_bishops.include?(piece)
            return legal_bishop_movement?(piece, row, collumn)
        elsif white_rooks.include?(piece) || black_rooks.include?(piece)
            return legal_rook_movement?(piece, row, collumn)
        elsif piece == white_queen || piece == black_queen
            return legal_queen_movement?(piece, row, collumn)
        elsif piece == white_king || piece == black_king
            return legal_king_movement?(piece, row, collumn)
        else
            return false
        end
    end
    
    def make_movement(piece_letter, turn, row, collumn)
        piece = find_piece(piece_letter, turn, row, collumn)
        unless legal_movement(piece, row, collumn, turn)
            return false
        end
        update_board(piece, piece[2], row, collumn)
        find_piece_cordinates(piece)
    end

    def legal_movement (piece, row, collumn, turn)
        if !outside_board?(row, collumn) && legal_piece_move?(piece, row, collumn, turn) && !move_puts_my_king_in_check?(piece, row, collumn, turn)
            return true
        else
            return false
        end
    end

    def undo_move (piece, origin_square, target_square_content, row, collumn)
        piece[2] = origin_square
        grid[row][collumn] = target_square_content
    end
    
    def move_puts_my_king_in_check?(piece, row, collumn, turn)
        origin_square = piece[2]
        target_square_content = grid[row][collumn]

        update_board(piece, piece[2], row, collumn)
        
        if check?(turn)
            undo_move(piece, origin_square, target_square_content, row, collumn)
            return true
        else
            undo_move(piece, origin_square, target_square_content, row, collumn)
            return false
        end
    end
    
    def landing_on_friendly_piece?(piece_position, row, collumn)
        if grid[piece_position[0]][piece_position[1]] == '□'
            return false
        end
        if get_color(piece_position[0], piece_position[1]) == 'white'
            if get_color(row, collumn) == 'white'
                return true
            else
                return false
            end
        elsif get_color(piece_position[0], piece_position[1]) == 'black'
            if get_color(row, collumn) == 'black'
                return true
            else
                return false
            end
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

    def legal_knight_movement?(piece_position, row, collumn, turn)
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
    
    def generate_all_pawn_moves(turn)
        if turn == 'white'
            legal_moves = []
            white_pawns.each do |pawn|
                POSSIBLE_PAWN_MOVES.map do |combo|
                    if legal_movement(pawn, pawn[2][0] + combo[0], pawn[2][1] + combo[1], turn)
                        legal_moves.push([pawn[2][0] + combo[0], pawn[2][1] + combo[1]])
                    end
                end
            end
        else
            legal_moves = []
            black_pawns.each do |pawn|
                POSSIBLE_PAWN_MOVES.map do |combo|
                    if legal_movement(pawn, pawn[2][0] + combo[0], pawn[2][1] + combo[1], turn)
                        legal_moves.push([pawn[2][0] + combo[0], pawn[2][1] + combo[1]])
                    end
                end
            end
        end
        return legal_moves
    end

    def generate_all_knight_moves(turn)
        if turn == 'white'
            legal_moves = []
            white_knights.each do |knight|
                POSSIBLE_KNIGHT_MOVES.map do |combo|
                    if legal_movement(knight, knight[2][0] + combo[0], knight[2][1] + combo[1], turn)
                        legal_moves.push([knight[2][0] + combo[0], knight[2][1] + combo[1]])
                    end
                end
            end
        else
            legal_moves = []
            black_knights.each do |knight|
                POSSIBLE_KNIGHT_MOVES.map do |combo|
                    if legal_movement(knight, knight[2][0] + combo[0], knight[2][1] + combo[1], turn)
                        legal_moves.push([knight[2][0] + combo[0], knight[2][1] + combo[1]])
                    end
                end
            end
        end
        return legal_moves
    end

    def generate_all_bishop_moves(turn)
        if turn == 'white'
            legal_moves = []
            white_bishops.each do |bishop|
                POSSIBLE_BISHOP_MOVES.map do |combo|
                    if legal_movement(bishop, bishop[2][0] + combo[0], bishop[2][1] + combo[1], turn)
                        legal_moves.push([bishop[2][0] + combo[0], bishop[2][1] + combo[1]])
                    end
                end
            end
        else
            legal_moves = []
            black_bishops.each do |bishop|
                POSSIBLE_BISHOP_MOVES.map do |combo|
                    if legal_movement(bishop, bishop[2][0] + combo[0], bishop[2][1] + combo[1], turn)
                        legal_moves.push([bishop[2][0] + combo[0], bishop[2][1] + combo[1]])
                    end
                end
            end
        end
        return legal_moves
    end

    def generate_all_rook_moves(turn)
        if turn == 'white'
            legal_moves = []
            white_rooks.each do |rook|
                POSSIBLE_ROOK_MOVES.map do |combo|
                    if legal_movement(rook, rook[2][0] + combo[0], rook[2][1] + combo[1], turn)
                        legal_moves.push([rook[2][0] + combo[0], rook[2][1] + combo[1]])
                    end
                end
            end
        else
            legal_moves = []
            black_rooks.each do |rook|
                POSSIBLE_ROOK_MOVES.map do |combo|
                    if legal_movement(rook, rook[2][0] + combo[0], rook[2][1] + combo[1], turn)
                        legal_moves.push([rook[2][0] + combo[0], rook[2][1] + combo[1]])
                    end
                end
            end
        end
        return legal_moves
    end

    def generate_all_queen_moves(turn)
        if turn == 'white'
            legal_moves = []
            POSSIBLE_QUEEN_MOVES.map do |combo|
                if legal_movement(white_queen, white_queen[2][0] + combo[0], white_queen[2][1] + combo[1], turn)
                    legal_moves.push([white_queen[2][0] + combo[0], white_queen[2][1] + combo[1]])
                end
            end
        else
            legal_moves = []
            POSSIBLE_QUEEN_MOVES.map do |combo|
                if legal_movement(black_queen, black_queen[2][0] + combo[0], black_queen[2][1] + combo[1], turn)
                    legal_moves.push([black_queen[2][0] + combo[0], black_queen[2][1] + combo[1]])
                end
            end
        end
        return legal_moves
    end

    def generate_all_king_moves
        if turn == 'white'
            legal_moves = []
            POSSIBLE_KING_MOVES.map do |combo|
                if legal_movement(white_king, white_king[2][0] + combo[0], white_king[2][1] + combo[1], turn)
                    legal_moves.push([white_king[2][0] + combo[0], white_king[2][1] + combo[1]])
                end
            end
        else
            legal_moves = []
            POSSIBLE_KING_MOVES.map do |combo|
                if legal_movement(black_king, black_king[2][0] + combo[0], black_king[2][1] + combo[1], turn)
                    legal_moves.push([black_king[2][0] + combo[0], black_king[2][1] + combo[1]])
                end
            end
        end
        legal_moves
    end
    
    def is_there_a_legal_move?(turn)
        all_legal_moves = [generate_all_pawn_moves(turn) + generate_all_knight_moves(turn) + generate_all_bishop_moves(turn) + generate_all_rook_moves(turn) + generate_all_queen_moves(turn) + generate_all_king_moves(turn)]
        if all_legal_moves.emptyy
            return false
        else
            return true
        end
    end
    
    def check? (turn)
        if turn == 'white'
            target_row = white_king[2][0]
            target_collumn = white_king[2][1]
            if legal_king_movement?([black_king[2][0], black_king[2][1]], target_row, target_collumn) ||
                legal_queen_movement?([black_queen[2][0], black_queen[2][1]], target_row, target_collumn) ||
                legal_rook_movement?([black_rooks[0][2][0], black_rooks[0][2][1]], target_row, target_collumn) ||
                legal_rook_movement?([black_rooks[1][2][0], black_rooks[1][2][1]], target_row, target_collumn) ||
                legal_bishop_movement?([black_bishops[0][2][0], black_bishops[0][2][1]], target_row, target_collumn) ||
                legal_bishop_movement?([black_bishops[1][2][0], black_bishops[1][2][1]], target_row, target_collumn) ||
                legal_knight_movement?([black_knights[0][2][0], black_knights[0][2][1]], target_row, target_collumn) ||
                legal_knight_movement?([black_knights[1][2][0], black_knights[1][2][1]], target_row, target_collumn)
               return true
            end
        else
            target_row = black_king[2][0]
            target_collumn = black_king[2][1]
            if legal_king_movement?([white_king[2][0], white_king[2][1]], target_row, target_collumn) ||
                legal_queen_movement?([white_queen[2][0], white_queen[2][1]], target_row, target_collumn) ||
                legal_rook_movement?([white_rooks[0][2][0], white_rooks[0][2][1]], target_row, target_collumn) ||
                legal_rook_movement?([white_rooks[1][2][0], white_rooks[1][2][1]], target_row, target_collumn) ||
                legal_bishop_movement?([white_bishops[0][2][0], white_bishops[0][2][1]], target_row, target_collumn) ||
                legal_bishop_movement?([white_bishops[1][2][0], white_bishops[1][2][1]], target_row, target_collumn) ||
                legal_knight_movement?([white_knights[0][2][0], white_knights[0][2][1]], target_row, target_collumn) ||
                legal_knight_movement?([white_knights[1][2][0], white_knights[1][2][1]], target_row, target_collumn)
               return true
             end             
        end 
        return false
    end

    def checkmate? (turn, checking_piece)
        if is_there_a_legal_move?(turn)
            false
        else
            true
        end
    end

    def stalemate? (turn)
        if is_there_a_legal_move?(turn)
            false
        else
            true
        end
    end




end

class Players
    attr_reader :piece_color
    def initialize (piece_color)
        @piece_color = piece_color
    end
end

class Game
    attr_reader :p1, :p2
    attr_accessor :turn, :board

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

    def play_round(checking_piece = nil)
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

        unless outside_board?(turn, collumn)
            board.make_movement(piece, turn, row, collumn)
            board.display_board()
            switch()
            if board.check?()
                play_round()
        end
    end
end

