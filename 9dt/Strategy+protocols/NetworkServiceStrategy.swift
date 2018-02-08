//
//  NetworkServiceStrategy.swift
//  9dt
//
//  Created by Kumar, Ranjith (Contractor) on 2/7/18.
//  Copyright © 2018 Kumar, Ranjith (Contractor). All rights reserved.
//

import Foundation


/** A 9dt strategy that allows a network to decide where to put marks on a game board. */
final class NetworkServiceStrategy: dt9Strategy {
    
    func choosePositionForMark(mark: Mark, onGameBoard gameBoard: GameBoard, completionHandler: @escaping (GameBoard.Position) -> Void) {
        //
        let previousEndpoints = gameBoard.flowColums()
        NetworkService.sharedInstance().getServiceEndpoints(points: previousEndpoints) { (endPoints, error) in
            guard let endPoints = endPoints else {
                //errorx
                UI {
                    Utility.showAlert("Eror", constants.nerWorkError, viewController: nil)
                }
                return
            }
            if endPoints.count > previousEndpoints.count {
                UI {
                    let position = gameBoard.getPostionTofillForColumn(column: endPoints[endPoints.count-1])
                    if let position = position {
                       completionHandler(position)
                    } else {
                        Utility.showAlert("Eror", constants.nerWorkError, viewController: nil)
                    }
                }
            }
        }
    }
    

}
