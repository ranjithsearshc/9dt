//
//  ReceiveDelegate.swift
//  9dt
//
//  Created by Kumar, Ranjith (Contractor) on 2/7/18.
//  Copyright © 2018 Kumar, Ranjith (Contractor). All rights reserved.
//

import Foundation

public protocol ReceiveDelegate:class {
 
    func updateOnView(position:(row: Int, column: Int))
}
