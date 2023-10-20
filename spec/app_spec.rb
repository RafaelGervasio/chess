require './app'

describe Board do
    board = Board.new
    context 'legal_pawn_movement?' do
        it 'returns false when pawn lands over piece' do 
            board.grid[-3][4] = board.white_rooks[0]
            expect(board.legal_pawn_movement?([-2, 4], -3, 4)).to be false
        end

        board.grid[-4][5] = board.white_pawns[0]
        it 'returns false when pawn lands over piece' do 
            expect(board.legal_pawn_movement?([-3, 5], -4, 5)).to be false
        end

        it 'returns false when trying to move 2 squares at a time' do
            expect(board.legal_pawn_movement?([-5, 5], -7, 5)).to be false
        end

        it 'returns false when trying to move across collumns' do
            expect(board.legal_pawn_movement?([-5, 5], -6, 6)).to be false
        end

        it 'returns false when trying to move backwards' do
            expect(board.legal_pawn_movement?([-4, 1], -3, 1)).to be false
        end
        it 'returns true when moving 1 square up with nothing in front of it' do
            expect(board.legal_pawn_movement?([-5, 5], -6, 5)).to be true
        end

        it 'returns true when moving 1 square up with nothing in front of it' do
            expect(board.legal_pawn_movement?([-3, 1], -4, 1)).to be true
        end
    end
    
    context "legal_knight_movement?" do
        it 'returns true when making a legal move' do
            expect(board.legal_knight_movement?([-1, 6], -3, 7)).to be true
        end

        it 'returns true when making a legal movement' do
            expect(board.legal_knight_movement?([-3, 6], -4, 4)).to be true
        end
        
        it 'returns false when just going forward' do
            expect(board.legal_knight_movement?([-3, 6], -5, 6)).to be false
        end

        it 'returns flase when just going left' do
            expect(board.legal_knight_movement?([-3, 6], -3, 4)).to be false
        end

        it 'returns false when landing on a friendly piece' do
            expect(board.legal_knight_movement?([-1, 6], -2, 4)).to be false
        end

        it 'returns false if mov is not in combo' do
            expect(board.legal_knight_movement?([-3, 6], -5, 8)).to be false
        end
    end

    context "legal_bishop_movement?" do
        it 'returns true when making a legal bishop move' do
            expect(board.legal_bishop_movement?([-3, 2], -5, 4)).to be true
        end

        it 'returns true when making a legal bishop move' do
            expect(board.legal_bishop_movement?([-6, 7], -4, 5)).to be true
        end

        it 'returns true when making a legal bishop move' do
            expect(board.legal_bishop_movement?([-3, 7], -6, 4)).to be true
        end

        it 'returns false when making a non-diag move' do
            expect(board.legal_bishop_movement?([-4, 7], -6, 4)).to be false
        end

        it 'returns false when landing on a friendly piece' do
            expect(board.legal_bishop_movement?([-1, 2], -2, 3)).to be false
        end

        it 'returns false when jumping over a piece' do
            board.grid[-4][3] = board.black_rooks[0]
            expect(board.legal_bishop_movement?([-3, 2], -6, 5)).to be false
        end
    end

    context "legal_rook_movement?" do
        br = Board.new
        it 'returns true when making a legal rook move' do
            expect(br.legal_rook_movement?([-3, 2], -3, 6)).to be true
        end

        it 'returns true when making a legal rook move' do 
            expect(br.legal_rook_movement?([-3, 6], -3, 2)).to be true
        end

        it 'returns true when making a legal rook move' do
            expect(br.legal_rook_movement?([-3, 4], -6, 4)).to be true
        end

        it 'returns true when making a legal rook move' do
            expect(br.legal_rook_movement?([-6, 4], -3, 4)).to be true
        end
        
        it 'returns false when maing an ilegal rook move' do
            expect(br.legal_rook_movement?([-4, 7], -3, 2)).to be false
        end

        it 'returns false when rook jumps over piece' do
            br.grid[-4][3] = board.black_pawns[0]
            expect(br.legal_rook_movement?([-6, 3], -1, 3)).to be false
        end

        it 'returns false when rook lands on friendly piece' do
            br.grid[-6][4] = board.white_rooks[0]
            expect(br.legal_rook_movement?([-6, 4], -2, 4)).to be false
        end
    end

    context 'legal_queen_movement?' do
        brd = Board.new
        it 'returns true when queen makes a legal move diagonally' do
            expect(brd.legal_queen_movement?([-3, 4], -5, 2)).to be true
        end

        it 'returns true when it makes a legal move vertically' do
            expect(brd.legal_queen_movement?([-3, 4], -6, 4)).to be true
        end

        it 'returns true when it a legal horiz move is made' do
            expect(brd.legal_queen_movement?([-3, 1], -3, 7)).to be true
        end

        it 'returns false making an ilegal move' do
            expect(brd.legal_queen_movement?([-3, 4], -6, 3)).to be false
        end
        
        it 'returns false when landing on a friendly piece' do
            brd.grid[-4][4] = board.white_queen
            expect(brd.legal_queen_movement?([-4, 4], -2, 4)).to be false
        end

        it ' returns true when taking a piece' do
            brd.legal_queen_movement?([-4, 4], -6, 4)
        end
    end

    context 'legal_king_movement?' do
        board_2 = Board.new
        it 'returns true when making a legal vertical king move' do
            expect(board_2.legal_king_movement?([-3, 4], -4, 4)).to be true
        end
        it 'returns true when making a legal vertical king move' do
            expect(board_2.legal_king_movement?([-4, 4], -3, 4)).to be true
        end
        it 'returns true when making a legal hor move' do
            expect(board_2.legal_king_movement?([-4, 4], -4, 3)).to be true
        end
        it "returns true when making a legal hor move" do
            expect(board_2.legal_king_movement?([-4, 3], -4, 4)).to be true
        end
        it 'returns true when making a diag move' do
            expect(board_2.legal_king_movement?([-4, 4], -3, 3)).to be true
        end
        it 'returns false when making an ilegal move' do
            expect(board_2.legal_king_movement?([-4, 3], -4, 5)).to be false
        end
    end

    context 'update_board' do
        board_3 = Board.new
        board_3.grid[-3][4] = board_3.white_rooks[0]
        board_3.grid[-5][4] = board_3.black_pawns[0]
        board_3.update_board(board_3.white_rooks[0], [-3, 4], -5, 4)
        it 'expect place where previously was black pawn to now be occpied by a white rook' do
            expect(board_3.grid[-5][4] == board_3.white_rooks[0]).to be true
        end
    end
end