//
//  Swipe.swift
//  2048
//
//  Created by Cheuk Lun Ko on 25/1/2019.
//  Copyright © 2019 Cheuk Lun Ko. All rights reserved.
//

import UIKit

class Swipe: NSObject {
    var direction: Direction
    var moves: [Move]
    
    init(direction: Direction, moves: [Move]) {
        self.direction = direction
        self.moves = moves
    }
}
