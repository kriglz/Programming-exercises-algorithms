import UIKit

/// Vertex state types defines by color.
enum VertexStateColor {
    
    /// Vertex has not been visited yet.
    case white
    /// Vertex has been visited, but it may have adjacent vertex that has been not.
    case gray
    /// Vertex has been visited and so all its adjacent vertices.
    case black
}

/// A node object which contains properties to define its position and state in node system.
class Vertex {
    
    /// The index of the previous in line vertex node.
    var predecessorIndex = -1
    /// The index of current vertex node.
    var index: Int
    /// The state defined by color of current vertex node.
    var stateColor = VertexStateColor.white
    
    /// Returns a vertex node.
    ///
    /// - Parameters:
    ///     - index: Unique index for the vertex node.
    init(index: Int) {
        self.index = index
    }
}

/// Direction type to the new vertex.
///
/// List of possible directions:
/// - up
/// - down
/// - left
/// - right
enum Direction: Int {

    case up = 1
    case down = 2
    case left = 3
    case right = 4
    
    /// Returns a random direction from all possible directions.
    static var random: Direction {
        let randomInt = (Int(arc4random_uniform(4)) + 1);
        return Direction.init(rawValue: randomInt) ?? .up
    }
}

/// A maze object generated by Depth-first search algorithm.
class Maze {
    
    // MARK: - Properties
    
    var vertexList = [Vertex]()
    
    var columns: Int
    var rows: Int
    
    // MARK: - Initialization
    
    /// Returns a maze object.
    ///
    /// - Parameters:
    ///     - columns: Column number for the maze.
    ///     - rows: Row number for the maze.
    init(columns: Int, rows: Int) {
        self.columns = columns
        self.rows = rows
        
        setupRawVertexList(columns: columns, rows: rows)
        fillUpVertexList()
    }
    
    // MARK: - Vertex list set up
    
    /// Initialized empty matrix of size: columns x rows.
    ///
    /// - Parameters:
    ///     - columns: Column number for the maze.
    ///     - rows: Row number for the maze.
    private func setupRawVertexList(columns: Int, rows: Int) {
        let maxIndex = columns * rows
        
        for index in 0..<maxIndex {
            let vertex = Vertex(index: index)
            vertexList.append(vertex)
        }
    }
    
    /// Runs Depth-first search algorithm to setup Vertex list for maze.
    private func fillUpVertexList() {
        updateVertex(for: 0)
    }
    
    // MARK: - Vertex list item management
    
    /// Udpdates vertex properties based on position in vertex node system.
    ///
    /// - Parameters:
    ///     - index: Index of specified vertex.
    private func updateVertex(for index: Int) {
        guard vertexList[index].stateColor != .black else { return }
        
        if vertexList[index].stateColor == .white {
            vertexList[index].stateColor = .gray
        }
        
        var randomDirections = [Direction]()
        func randomDirectionVertex() -> Vertex? {
            let direction = Direction.random

            if randomDirections.contains(direction) {
                return randomDirectionVertex()
            }

            randomDirections.append(direction)

            let newVertex = nextVertex(for: index, towards: direction)

            if newVertex == nil, randomDirections.count >= 4 {
                return nil
            }

            if newVertex == nil, randomDirections.count < 4 {
                return randomDirectionVertex()
            }

            if newVertex != nil, newVertex!.stateColor != .white, randomDirections.count < 4  {
                return randomDirectionVertex()
            }

            if newVertex != nil, newVertex!.stateColor == .white {
                return newVertex
            }

            return nil
        }
        
        if let newVertex = randomDirectionVertex() {
            newVertex.predecessorIndex = index
            updateVertex(for: newVertex.index)
        } else {
            vertexList[index].stateColor = .black
            
            let predecessorIndex = vertexList[index].predecessorIndex
            if predecessorIndex > -1 {
                updateVertex(for: predecessorIndex)
            }
        }
    }
    
    /// Returns next in line vertex node for specified direction.
    ///
    /// - Parameters:
    ///     - currentVertexIndex: Index of current vertex.
    ///     - direction: Next in line vertex direction.
    private func nextVertex(for currentVertexIndex: Int, towards direction: Direction) -> Vertex? {
        var index = currentVertexIndex

        switch direction {
        case .left:
            // Return nil for left most current vertex.
            if currentVertexIndex == 0 || currentVertexIndex % columns == 0 {
                return nil
            }
            index -= 1
        case .right:
            // Return nil for right most current vertex.
            if currentVertexIndex + 1 >= columns, (currentVertexIndex + 1) % columns == 0 {
                return nil
            }
            index += 1
        case .up:
            index += columns
        case .down:
            index -= columns
        }
        
        guard index < vertexList.count, index >= 0 else { return nil }
        
        return vertexList[index]
    }
}

let maze = Maze(columns: 4, rows: 2)

for i in maze.vertexList {
    print(i.index, i.predecessorIndex)
}

// 4 5 6 7
// 0 1 2 3
