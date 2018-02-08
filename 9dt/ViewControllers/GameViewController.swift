//
//  GameViewController.swift
//  9dt
//
//  Created by Kumar, Ranjith (Contractor) on 2/6/18.
//  Copyright © 2018 Kumar, Ranjith (Contractor). All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    private var game: Game?
    private var gameBoard:GameBoard?
    private var userStrategyBlue: dt9Strategy?
    private var userStrategyRed: dt9Strategy?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func resetAction(_ sender: Any) {
        resetPlayingGame()
        winnerLabel.isHidden = true
        resetButton.setTitle("Reset", for: .normal) 
    }
    
    @IBAction func ButtonAction(_ sender: UIButton) {
        if let _ = gameBoard, let _ = game  {
            buttonTappmed(sender)
        } else {
            startPlayingGame()
        }
    }
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var winnerLabel: UILabel!
    
    var player1Description = ""
    var player2Description = ""
    

}


//MARK: - Button Methods

extension GameViewController {
    func buttonTappmed(_ sender:UIButton) {
        //let row = sender.tag / gridSize
        let column = sender.tag % constants.gridSize
        
        //var position = (row: row, column: column)
        let position1 = gameBoard!.getPostionTofillForColumn(column: column)
        guard let position = position1 else {
           Utility.showAlert("Error", constants.errorMessage, viewController: self)
           return
        }
        if gameBoard!.isEmptyAtPosition(position: position) && gameBoard!.isEmptyPostionisValid(position: position){
            tappedEmptyButtonPosition(position: position)
        } else {
            if !(gameBoard!.isEmptyPostionisValid(position: position)) {
                Utility.showAlert("Error", constants.errorMessage, viewController: self)
            } else {
                print("Button already used")
            }
        }
    }
    
    func updatButtonMark(_ sender:UIButton) {
        let mark = game?.getCurrentMark()
        if let mark = mark {
            sender.backgroundColor  = mark.colorForMark()
        }
    }
}


// MARK: - Gameplay

private extension GameViewController {
    func startPlayingGame() {
        
        let alertController = UIAlertController.init(title: title, message: constants.startMessge, preferredStyle: UIAlertControllerStyle.alert)
        let human = UIAlertAction(title: "Human", style: .default) { [weak self] action in
            UI {
                self?.stratGame(player1Strategy: UserStrategy(), player2Strategy: NetworkServiceStrategy())
                self?.player1Description = "Human"
                self?.player2Description = "Network Service"
            }
        }
        let networkService = UIAlertAction(title: "Network Service", style: .default) { [weak self] action in
            UI {
                self?.stratGame(player1Strategy: NetworkServiceStrategy(), player2Strategy: UserStrategy())
                self?.player1Description = "Network Service"
                self?.player2Description = "Human"
            }
        }
        alertController.addAction(human)
        alertController.addAction(networkService)
        self.present(alertController, animated: true)
        
    }
    
    func stratGame(player1Strategy:dt9Strategy,player2Strategy:dt9Strategy) {
        gameBoard = GameBoard(delegate: self)
        
        userStrategyBlue = player1Strategy
        userStrategyRed =  player2Strategy
        
        let
        blueStrategy = userStrategyBlue!,
        redStrategy = userStrategyRed!
        
        game = Game(gameBoard: gameBoard!, blueStrategy: blueStrategy, redStrategy: redStrategy)
        game!.startPlayingWithCompletionHandler { [weak self] outcome in
            print(outcome)
            var winningDes:String!
            if let winner = outcome.winner {
                switch winner {
                case .bluePlayer:
                    winningDes =  "\(String(describing: (self?.player1Description)!)) Won"
                case .redPlayer:
                    winningDes =  "\(String(describing: (self?.player2Description)!)) Won"
                }
            } else {
                winningDes = " Game Draw"
            }
            UI {
                self?.winnerLabel.isHidden = false
                self?.winnerLabel.text = winningDes
                self?.resetButton.setTitle("Play again", for: .normal)
                Utility.showAlert("Result", winningDes, viewController: self)
            }
        }
    }
    
    
    
    
    func resetPlayingGame() {

        for stackview in view.subviews[0].subviews[0].subviews {
            for button in stackview.subviews {
                if button is UIButton {
                    button.backgroundColor = constants.defaultGridColor
                }
            }
        }
        startPlayingGame()
    }
    
    func tappedEmptyButtonPosition(position: GameBoard.Position) {

        _ = reportChosenPosition(position: position, forUserStrategy: game?.getCurrentPayerStarategy() as? UserStrategy)
    }
    
    func reportChosenPosition(position: GameBoard.Position, forUserStrategy userStrategy: UserStrategy?) -> Bool {
        guard let userStrategy = userStrategy, userStrategy.isWaitingToReportChosenPosition else {
            return false
        }
        
        userStrategy.reportChosenPosition(position: position)
        return true
    }
}

extension GameViewController:ReceiveDelegate {
    func updateOnView(position: (row: Int, column: Int)) {
        //
        let mark = game?.getCurrentMark()
        let buttonTag = (constants.gridSize * position.row ) + position.column
                for stackview in view.subviews[0].subviews[0].subviews {
            for button in stackview.subviews {
                if button is UIButton && button.tag == buttonTag {
                    button.backgroundColor = mark?.colorForMark()
                }
            }
        }
    }
}
