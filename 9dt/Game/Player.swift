//
//  Player.swift
//  9dt
//
//  Created by Kumar, Ranjith (Contractor) on 2/6/18.
//  Copyright © 2018 Kumar, Ranjith (Contractor). All rights reserved.
//

import Foundation


/** Represents a 9dt contestant, either human or computer. */
internal final class Player {
    
    init(mark: Mark, gameBoard: GameBoard, strategy: dt9Strategy) {
        self.mark = mark
        self.gameBoard = gameBoard
        self.strategy = strategy
    }
    
    let mark: Mark
    
    func choosePositionWithCompletionHandler(completionHandler: @escaping (GameBoard.Position) -> Void) {
        strategy.choosePositionForMark(mark: mark, onGameBoard: gameBoard, completionHandler: completionHandler)
    }
    
    private let gameBoard: GameBoard
    let strategy: dt9Strategy
}
