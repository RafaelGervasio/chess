require './app'

describe Board do
    board = Board.new
    board.populate_board
    context 'legal_pawn_movement?' do
        
        board.grid[-3][4] = board.white_rook
        it 'returns false when pawn lands over piece' do 
            expect(board.legal_pawn_movement?([-2, 4], -3, 4)).to be false
        end

        board.grid[-4][5] = board.white_pawn
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

    context "legal" do
end