//
//  9dtStrategy.swift
//  9dt
//
//  Created by Kumar, Ranjith (Contractor) on 2/6/18.
//  Copyright © 2018 Kumar, Ranjith (Contractor). All rights reserved.
//

import Foundation
import UIKit


/** Describes an object capable of deciding where to put the next mark on a GameBoard. */
public protocol dt9Strategy {
    func choosePositionForMark(mark: Mark, onGameBoard gameBoard: GameBoard, completionHandler: @escaping (GameBoard.Position) -> Void)
}
