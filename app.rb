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
    def update_board (piece, piece_position, row, collumn)
        temp = piece
        grid[piece_position[0]][piece_position[1]] = '□'
        grid[row][collumn] = temp
    end

    def legal_move?(piece, piece_position, row, collumn)
        if outside_board?(row, collumn) || legal_piece_movement?(piece, piece_position, row, collumn) == false || find_piece(piece) == false 
            false
        else
            true
        end
    end
        
    def outside_board?(row, collumn)
        check = true
        grid[row].nil? ? check = false : ''
        check == false ? '' : grid[row][collumn].nil? ? check = false : ''
        check
    end

    def get_piece(piece, turn)
        if piece == 'p'
            turn == 'white' ? piece = white_pawn : piece = black_pawn
        elsif piece == 'n'
            turn == 'white' ? piece = white_knight : piece = black_knight
        elsif piece == 'r'
            turn == 'white' ? piece = white_rook : piece = black_rook
        elsif piece == 'b'
            turn == 'white' ? piece = white_bishop : piece = black_bishop
        elsif piece == 'q'
            turn == 'white' ? piece = white_queen : piece = black_queen
        elsif piece == 'k'
            turn == 'white' ? piece = white_king : piece = black_king
        end
        piece
    end

    def legal_piece_movement? (piece, piece_position, row, collumn)
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
        
    def find_piece (piece)
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

    def legal_knight_movement?(piece_position, row, collumn)
        POSSIBLE_KNIGHT_MOVES.each do |combo|
            if piece_position[0] + combo[0] == row && piece_position[1] + combo[1] == collumn
                return true
            end
        end
        false
    end

    def legal_pawn_movement?(piece_position, row, collumn)
        unless piece_position[0] + 1 == row
            false
        end
        true
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
        
        puts "Choose piece (k, q, r, b, n, p): "
        piece = gets.chomp
        puts "Choose row: "
        row = -(gets.chomp.to_i)
        puts "Choose collumn: "
        collumn = gets.chomp.to_i - 1
        
        puts "-------"
        puts "-------"
        
        piece = board.get_piece(piece, turn)
        piece_position = board.find_piece(piece)

        if board.legal_move?(piece, piece_position, row, collumn)
            puts 'Invalid move'
            return
        end
    
        board.update_board(piece, piece_position, row, collumn)        
        board.display_board()
    end
end


g = Game.new
g.play_round
# g.board.display_board