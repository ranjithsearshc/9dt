//
//  Game.swift
//  9dt
//
//  Created by Kumar, Ranjith (Contractor) on 2/6/18.
//  Copyright © 2018 Kumar, Ranjith (Contractor). All rights reserved.
//

import Foundation

/**  gameplay between two players. */
public final class Game {
    
    public typealias CompletionHandler = (Outcome) -> Void
    
    public init(gameBoard: GameBoard, blueStrategy: dt9Strategy, redStrategy: dt9Strategy) {
        self.gameBoard = gameBoard
        self.outcomeAnalyst = OutcomeAnalyst(gameBoard: gameBoard)
        self.playerBlue = Player(mark: .blue, gameBoard: gameBoard, strategy: blueStrategy)
        self.playerRed = Player(mark: .red, gameBoard: gameBoard, strategy: redStrategy)
    }
    
    public func startPlayingWithCompletionHandler(completionHandler: @escaping CompletionHandler) {
        assert(self.completionHandler == nil, "Cannot start the same Game twice.")
        self.completionHandler = completionHandler
        currentPlayer = playerBlue
    }
    
    
    
    // MARK: - Non-public stored properties
    
    private var currentPlayer: Player? {
        didSet {
            currentPlayer?.choosePositionWithCompletionHandler(completionHandler: processChosenPosition)
        }
    }
    
    private var completionHandler: CompletionHandler!
    private let gameBoard: GameBoard
    private let outcomeAnalyst: OutcomeAnalyst
    private let playerRed: Player
    private let playerBlue: Player
}



extension Game {
    func processChosenPosition(position: GameBoard.Position) {
        guard let currentPlayer = currentPlayer else {
            assertionFailure("Why was a position chosen if there is no current player?")
            return
        }
        
        gameBoard.putMark(mark: currentPlayer.mark, atPosition: position)
        
        
        if let outcome = outcomeAnalyst.checkForOutcome() {
            finishWithOutcome(outcome: outcome)
        }
        else {
            switchCurrentPlayer()
        }
    }
    
    func getCurrentMark() -> Mark? {

        return currentPlayer?.mark
        
    }
    
    func getCurrentPayerStarategy() -> dt9Strategy? {
        return currentPlayer?.strategy
    }
    
    private func finishWithOutcome(outcome: Outcome) {
        completionHandler(outcome)
        currentPlayer = nil
    }
    
    private func switchCurrentPlayer() {
        let blueIsCurrent = (currentPlayer!.mark == .red)
        currentPlayer = blueIsCurrent ? playerBlue : playerRed
    }
}
