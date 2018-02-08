//
//  UserStrategy.swift
//  9dt
//
//  Created by Kumar, Ranjith (Contractor) on 2/6/18.
//  Copyright © 2018 Kumar, Ranjith (Contractor). All rights reserved.
//

import Foundation

/** A 9dt strategy that allows a person to decide where to put marks on a game board. */
final class UserStrategy: dt9Strategy {
    
    func choosePositionForMark(mark: Mark, onGameBoard gameBoard: GameBoard, completionHandler: @escaping (GameBoard.Position) -> Void) {
        self.reportChosenPositionClosure = completionHandler
    }
    
    
    func reportChosenPosition(position: GameBoard.Position) {
        if let reportChosenPositionClosure = reportChosenPositionClosure {
            self.reportChosenPositionClosure = nil
            reportChosenPositionClosure(position)
        }
    }
    
    var isWaitingToReportChosenPosition: Bool {
        return reportChosenPositionClosure != nil
    }
    
    private var reportChosenPositionClosure: ((GameBoard.Position) -> Void)?
}
