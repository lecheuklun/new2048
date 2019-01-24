//
//  Board.swift
//  2048
//
//  Created by Cheuk Lun Ko on 23/1/2019.
//  Copyright © 2019 Cheuk Lun Ko. All rights reserved.
//

import UIKit

enum Number: Int {
    case empty = 0
    case two
    case four
    case eight
    case sixteen
    case thirtyTwo
    case sixtyFour
    case oneTwentyEight
    case twoFiftySix
    case fiveTwelve
    case tenTwentyFour
    case twentyFortyEight
}

enum Direction {
    case up, down, left, right
}

class Board: NSObject {
    static var width = 4
    static var height = 4
    
    var squares = [Number]()
    
    override init() {
        super.init()
        
        resetBoard()
        proceedGame()
    }
    
    func indexOfSquare(col: Int, row: Int) -> Int? {
        let result = 4 * row + col
        if (0...15).contains(result) && (0...3).contains(col) && (0...3).contains(row) {
            return result
        } else {
            return nil
        }
    }
    
    func resetBoard() {
        squares = [Number]()
        
        for _ in 0 ..< 16 {
            squares.append(.empty)
        }
    }
    
    func updateSquare(withNumber number: Number, inColumn col: Int, row: Int) {
        /*
         1  2  3  4         row 0
         5  6  7  8
         9  10 11 12
         13 14 15 16        row 3
         */
        
        squares[indexOfSquare(col: col, row: row)!] = number
    }
    
    func number(inColumn column: Int, row: Int) -> Number {
        return squares[indexOfSquare(col: column, row: row)!]
    }
    
    func checkAdjacentSquares(inDirection direction: Direction, col: Int, row: Int) -> [Number] {
        var results = [Number]()
        switch direction {
        case .up:
            for i in 1...3 {
                if let index = indexOfSquare(col: col, row: row - i) {
                    results.append(squares[index])
                }
            }
        case .down:
            for i in 1...3 {
                if let index = indexOfSquare(col: col, row: row + i) {
                    results.append(squares[index])
                }
            }
        case .left:
            for i in 1...3 {
                if let index = indexOfSquare(col: col - i, row: row) {
                    results.append(squares[index])
                }
            }
        case .right:
            for i in 1...3 {
                if let index = indexOfSquare(col: col + i, row: row) {
                    results.append(squares[index])
                }
            }
        }
        return results
    }
    
    func proceedGame() { //player swipes, this is called, then merge
        let emptySquares = squares.filter { $0 == .empty }.count
        switch emptySquares {
        case 0: break //no squares generated
        case 1 ..< 3: generateSquares(howMany: 1)
        case 3 ..< 4: generateSquares(howMany: 2)
        default: generateSquares(howMany: 3)
        }
        
        performMerging()
        
        if isWin() {
            // show win ac
            
        } else if isGameOver() {
            // show game over ac
        }
    }
    
    func generateSquares(howMany: Int) {
        var indexArray = [Int]()
        for (index, square) in squares.enumerated() {
            if square == .empty {
                indexArray.append(index)
            }
        }
        indexArray.shuffle()
        
        for occurence in 0 ..< howMany {
            let index = indexArray[occurence]
            switch Int.random(in: 0...2) {
            case 0, 1: squares[index] = .two
            case 2: squares[index] = .four
            default: break
            }
        }
        print(squares)
    }
    
    func performMerging() {
        
    }
    
    func isGameOver() -> Bool {
        return false
    }
    
    func isWin() -> Bool {
        return false
    }
    
    
    
}
