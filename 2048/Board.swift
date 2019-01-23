//
//  Board.swift
//  2048
//
//  Created by Cheuk Lun Ko on 23/1/2019.
//  Copyright © 2019 Cheuk Lun Ko. All rights reserved.
//

import UIKit

class Board: NSObject {
    static var width = 4
    static var height = 4
    
    var squares = [Square]()
    
    override init() {
        super.init()
        
        resetBoard()
    }
    
    func resetBoard() {
        squares = [Square]()
        
        for _ in 0 ..< 16 {
            squares.append(Square(value: .none))
        }
    }
    
    func updateSquare(withNumber number: ValidNumber, inColumn column: Int, row: Int) {
        /*
         1  2  3  4
         5  6  7  8
         9  10 11 12
         13 14 15 16
         */
        
        let index = 4 * (row - 1) + column
        squares[index] = Square(value: number)
    }
}
