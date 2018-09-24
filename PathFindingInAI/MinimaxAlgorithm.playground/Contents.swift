/*
 
 Gametree type algorithm Minimax.
 
 */

import UIKit

enum PlayerMark: Int {
    
    case x = 1
    case o = -1
}

extension Array where Element == PlayerMark? {
    
    /// Returns matrix 3 by 3, made from receiver's array, which must consist of 9 elements.
    ///
    /// Original array
    ///
    /// 1 2 3 4 5 6 7 8
    ///
    /// ->
    ///
    /// Matrix
    ///
    /// 1 2 3
    ///
    /// 4 5 6
    ///
    /// 7 8 9
    var rows: [[PlayerMark?]] {
        guard self.count == 9 else { return []}
        
        var newArray = Array<[PlayerMark?]>(repeating: Array<PlayerMark?>(repeating: nil, count: 3), count: 3)
        for (index, element) in self.enumerated() {
            let row = index / 3
            let column = index - row * 3
            newArray[row][column] = element
        }
        
        return newArray
    }
    
    /// Returns matrix 3 by 3, made from receiver's array, which must consist of 9 elements.
    ///
    /// Original array
    ///
    /// 1 2 3 4 5 6 7 8
    ///
    /// ->
    ///
    /// Matrix
    ///
    /// 1 4 7
    ///
    /// 2 5 8
    ///
    /// 3 6 9
    var columns: [[PlayerMark?]] {
        guard self.count == 9 else { return []}

        var newArray = Array<[PlayerMark?]>(repeating: Array<PlayerMark?>(repeating: nil, count: 3), count: 3)
        for (index, element) in self.enumerated() {
            let row = index / 3
            let column = index - row * 3
            newArray[column][row] = element
        }
        
        return newArray
    }
    
    /// Returns 2 diagonal array of matrix constructed from receiver's array.
    var diagonals: [[PlayerMark?]] {
        guard self.count == 9 else { return []}

        var newArray = [[PlayerMark?]]()

        var diagonal = [PlayerMark?]()
        for index in 0...2 {
            diagonal.append(self[index * 4])
        }
        newArray.append(diagonal)
        
        diagonal = []
        for index in 0...2 {
            diagonal.append(self[index * 2 + 2])
        }
        newArray.append(diagonal)
        
        return newArray
    }
}

class Player {
    
    private var playerMark: PlayerMark
    
    init(playerMark: PlayerMark) {
        self.playerMark = playerMark
    }
    
    /// Returns the score of the board, which is a difference between players and opponents possible wins - sum of rows, columns, diagonals.
    func evaluateScore(for state: GameState) -> Int {
        var score = 0
        
        // Check lines.
        
        
        // Check rows.
        
        
        // Check diagonals.
        
        
        // Posible row, column, diagonal sum to win
        return 0
    }
    
    func validMoves(for gameState: GameState) -> [Move] {
        var validMoves = [Move]()
        
        for (index, state) in gameState.board.enumerated() {
            if state == nil {
                let move = Move(playerMark: playerMark, toIndex: index)
                validMoves.append(move)
            }
        }
        
        return validMoves
    }
    
}

class GameState {
    
    /// Board state, describing game.
    private(set) var board: [PlayerMark?]
    
    init(board: [PlayerMark?] = []) {
        self.board = board
    }
    
    func copy() -> GameState {
        return GameState(board: self.board)
    }
    
    func execute(move: Move) {
        board[move.toIndex] = .o
    }
    
    func undo(move: Move) {
        board[move.toIndex] = nil
    }
}

class MoveEvaluator {
    
    private(set) var score: Int
    private(set) var move: Move?

    init(with score: Int) {
        self.score = score
    }
    
    convenience init(move: Move, with score: Int) {
        self.init(with: score)
        self.move = move
    }
}

class Move {
    
    private(set) var toIndex: Int
    private(set) var playerMark: PlayerMark
    
    var debugDescription: String {
        return "To: \(toIndex)"
    }
    
    init(playerMark: PlayerMark, toIndex: Int) {
        self.toIndex = toIndex
        self.playerMark = playerMark
    }
}

/// Defines MAX and MIN and consolidates how they select the best move from perspective.
enum Comparator {
    
    case maxi
    case mini
    
    var scoreRepresentitive: Int {
        switch self {
        case .mini:
            return Int.min
        case .maxi:
            return Int.max
        }
    }
    
    /// The worst score for each of these comparators is returned by this value; the actual value is different for MAX and MIN.
    var initalValue: Comparator {
        return .maxi
    }
    
    /// Swithes between MIN and MAX.
    var opposite: Comparator {
        switch self {
        case .maxi:
            return .mini
        case .mini:
            return .maxi
        }
    }
    
    /// Compares scores based on receivers state.
    func compare(i: Int, j: Int) -> Int {
        switch self {
        case .maxi:
            return i - j
        case .mini:
            return j - i
        }
    }
}

class MinimaxAlgorithm {
    
    /// The depth of game tree. How far to continue the search.
    private var plyDepth: Int
    /// All game states are evaluates from this player perspective.
    private var player: Player!
    /// Game state to be modified during the search.
    private var gameState = GameState()
    
    init(plyDepth: Int) {
        self.plyDepth = plyDepth
    }
    
    func bestMove(gameState: GameState, player: Player, opponent: Player) -> MoveEvaluator {
        self.player = player
        self.gameState = gameState.copy()
        
        let move = search(plyDepth: plyDepth, comparator: Comparator.maxi, player: player, opponent: opponent)
        return move
    }
    
    func search(plyDepth: Int, comparator: Comparator, player: Player, opponent: Player) -> MoveEvaluator {
        let moves = player.validMoves(for: gameState)
        
        // If no allowed moves or a leaf node, return games state score.
        if plyDepth == 0 || moves.isEmpty {
            return MoveEvaluator(with: player.evaluateScore(for: gameState))
        }
        
        // Try to improve on this lower bound (based on selector).
        var best = MoveEvaluator(with: comparator.initalValue.scoreRepresentitive)
        
        // Generate game state that result from all valid moves for this player.
        moves.forEach { move in
            gameState.execute(move: move)
            
            // Recursively evaluate position. Compute Minimax and swap player and opponent, synchronously eith MIN and MAX.
            let newMove = search(plyDepth: plyDepth - 1, comparator: comparator.opposite, player: opponent, opponent: player)
            
            gameState.undo(move: move)
            
            // Select maximum (minimum) of children if we are MAX (MIN).
            if comparator.compare(i: best.score, j: newMove.score) < 0 {
                best = MoveEvaluator(move: move, with: newMove.score)
            }
        }
        
        return best
    }
}

let algorithm = MinimaxAlgorithm(plyDepth: 2)
let emptyBoard = Array<PlayerMark?>(repeating: nil, count: 9)
let gameState = GameState(board: emptyBoard)
let player = Player(playerMark: .x)
let opponent = Player(playerMark: .o)
let bestMove = algorithm.bestMove(gameState: gameState, player: player, opponent: opponent)

print(bestMove.score, bestMove.move.debugDescription)

let testBoard: [PlayerMark?] = [.x, .o, nil, .x, .x, nil, nil, .o, .x]
let testUpdated = testBoard.diagonals
print(testUpdated)

