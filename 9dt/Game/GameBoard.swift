//
//  GameBoard.swift
//  9dt
//
//  Created by Kumar, Ranjith (Contractor) on 2/6/18.
//  Copyright © 2018 Kumar, Ranjith (Contractor). All rights reserved.
//

import Foundation
import UIKit


/** The possible states for a position on a GameBoard. */
public enum Mark {
    case blue, red
    
    func opponentMark() -> Mark {
        switch self {
        case .blue: return .red
        case .red: return .blue
        }
    }
    
    func colorForMark() -> UIColor {
        switch self {
        case .blue: return .blue
        case .red: return .red
        }
    }
    
}


/**
 Represents the state of a 9dt game.
 */
public final class GameBoard {
    
    public typealias Position = (row: Int, column: Int)
    
    public enum Diagonal {
        case TopLeftToBottomRight, BottomLeftToTopRight
        
        static func allValues() -> [Diagonal] {
            return [.TopLeftToBottomRight, .BottomLeftToTopRight]
        }
    }
    
    public convenience init(delegate:ReceiveDelegate ,dimension: Int = 4) {
        assert(dimension >= 4)
        
        let
        emptyRow = [Mark?](repeating: nil, count: dimension),
        allMarks = [[Mark?]](repeating: emptyRow, count: dimension)
        
        self.init(dimension: dimension, marks: allMarks,delegate:delegate)
    }
    
    private init(dimension: Int, marks: [[Mark?]],delegate:ReceiveDelegate) {
        self.dimension = dimension
        self.dimensionIndexes = [Int](0..<dimension)
        self.marks = marks
        self.flowMarks = [Int]()
        self.delegate = delegate
    }
    
    public let dimension: Int
    
    public var emptyPositions: [Position] {
        return positions.filter(isEmptyAtPosition)
    }

    public var marksAndPositions: [(mark: Mark, position: Position)] {
        return positions.flatMap { position in
            if let mark = markAtPosition(position: position) {
                return (mark, position)
            }
            else {
                return nil
            }
        }
    }
    
    // Mark: - delagate
    
    weak var delegate:ReceiveDelegate?
    
    // MARK: - Non-public stored properties
    
    internal let dimensionIndexes: [Int]
    
    internal var marks: [[Mark?]]
    
    internal var flowMarks:[Int]
    
    private lazy var positions: [Position] = {
        self.dimensionIndexes.flatMap { row -> [Position] in
            let
            rows = [Int](repeating: row, count: self.dimension),
            cols = self.dimensionIndexes
            return Array(zip(rows, cols))
        }
    }()
}

// MARK: - Internal methods

internal extension GameBoard {
    
    func isEmptyAtPosition(position: Position) -> Bool {
        return markAtPosition(position: position) == nil
    }
    
    func isEmptyPostionisValid(position:Position) -> Bool {
        let row = position.row + 1
        let column = position.column
        if row < constants.gridSize {
            return markAtPosition(position: (row:row,column:column)) != nil
        } else {
            return true
        }
    }
    
    func marksInRow(row: Int) -> [Mark?] {
        return positionsForRow(row: row).map(markAtPosition)
    }
    
    func marksInColumn(column: Int) -> [Mark?] {
        return positionsForColumn(column: column).map(markAtPosition)
    }
    
    func marksInDiagonal(diagonal: Diagonal) -> [Mark?] {
        return positionsForDiagonal(diagonal: diagonal).map(markAtPosition)
    }
    
    func positionsForRow(row: Int) -> [Position] {
        return dimensionIndexes.map { (row: row, column: $0) }
    }
    
    func positionsForColumn(column: Int) -> [Position] {
        return dimensionIndexes.map { (row: $0, column: column) }
    }
    
    func getPostionTofillForColumn(column:Int) -> Position? {
        for row in stride(from: constants.gridSize-1, to: -1, by: -1) {
            if isEmptyAtPosition(position: (row:row,column:column)) {
                return (row:row,column:column)
            }
        }
        
        return nil
    }
    
    func flowColums() -> [Int] {
        return flowMarks
    }
    
    func positionsForDiagonal(diagonal: Diagonal) -> [Position] {
        let rows = dimensionIndexes, columns = dimensionIndexes
        switch diagonal {
        case .TopLeftToBottomRight: return Array(zip(rows, columns))
        case .BottomLeftToTopRight: return Array(zip(rows.reversed(), columns))
        }
    }
    
    func putMark(mark: Mark, atPosition position: Position) {
        assertPosition(position: position)
        assert(isEmptyAtPosition(position: position))
        marks[position.row][position.column] = mark
        flowMarks.append(position.column)
        delegate?.updateOnView(position: position)
    }
}



// MARK: - Private methods

private extension GameBoard {
    func assertIndex(index: Int) {
        assert(-1 < index && index < dimension)
    }
    
    func assertPosition(position: Position) {
        assertIndex(index: position.row)
        assertIndex(index: position.column)
    }
    
    func markAtPosition(position: Position) -> Mark? {
        assertPosition(position: position)
        return marks[position.row][position.column]
    }
}
