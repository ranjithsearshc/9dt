//
//  Config.swift
//  9dt
//
//  Created by Kumar, Ranjith (Contractor) on 2/6/18.
//  Copyright © 2018 Kumar, Ranjith (Contractor). All rights reserved.
//

import Foundation
import UIKit
struct constants {
    static let baseurl = "https://w0ayb2ph1k.execute-api.us-west-2.amazonaws.com/production?moves=["
    static let gridSize = 4
    static let defaultGridColor = UIColor.white
    static let errorMessage = "A token is dropped along a column (labeled 0-3) and said token goes to the lowest unoccupied row of the board"
    static let nerWorkError = "Cannot complete the Game. Due t network error or work set of data. Go and reset the Game play again"
    static let startMessge = "Whom you want to start with"
}


class Utility {
    class func topMostViewController() -> UIViewController? {
        var topController: UIViewController? = nil
        
        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = rootController.presentedViewController {
                topController = presentedViewController
            }
            
            if topController == nil {
                topController = rootController
            }
        }
        
        return topController
    }
    
    
    class func showAlert(_ title:String,_ message:String,viewController:UIViewController?) {
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { action in
            // ...
        }
        alertController.addAction(OKAction)
        
        if let _ = viewController {
            viewController!.present(alertController, animated: true) {
                // ...
            }
        } else {
            topMostViewController()?.present(alertController, animated: true)
        }
        
    }

}

func UI(_ block: @escaping ()->Void) {
    DispatchQueue.main.async(execute: block)
}


