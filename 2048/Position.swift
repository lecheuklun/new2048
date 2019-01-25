//
//  Position.swift
//  2048
//
//  Created by Cheuk Lun Ko on 25/1/2019.
//  Copyright © 2019 Cheuk Lun Ko. All rights reserved.
//

import Foundation

struct Position {
    let col: Int
    let row: Int
    let index: Int
    
    init(col: Int, row: Int) {
        self.col = col
        self.row = row
        
        let index = 4 * row + col
        self.index = index
    }
}
