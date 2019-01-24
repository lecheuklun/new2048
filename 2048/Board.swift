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
        
        /*
        updateSquare(withNumber: .two, inColumn: 0, row: 0)
        updateSquare(withNumber: .four, inColumn: 0, row: 3)
        updateSquare(withNumber: .four, inColumn: 3, row: 3)
        moveSquare(inDirection: .up, col: 0, row: 3)
 */
 
        //proceedGame()
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
    
    func indexOfSquareInDirection(_ direction: Direction, col: Int, row: Int, byOffset offset: Int) -> Int? {
        switch direction {
        case .up:
            return indexOfSquare(col: col, row: row - offset)
        case .down:
            return indexOfSquare(col: col, row: row + offset)
        case .left:
            return indexOfSquare(col: col - offset, row: row)
        case .right:
            return indexOfSquare(col: col + offset, row: row)
        }
    }
    
    func checkAdjacentSquares(inDirection direction: Direction, col: Int, row: Int) -> [Number] {
        var results = [Number]()
        
        for i in 1...3 {
            if let index = indexOfSquareInDirection(direction, col: col, row: row, byOffset: i) {
                results.append(squares[index])
            }
        }
        return results
    }
    
    func proceedGame() { //player swipes, this is called
        let emptySquares = squares.filter { $0 == .empty }.count
        switch emptySquares {
        case 0: break //no squares generated
        case 1 ..< 3: generateSquares(howMany: 1)
        case 3 ..< 4: generateSquares(howMany: 2)
        default: generateSquares(howMany: 3)
        }
        
        // move / merge
        
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
    

    
    func isGameOver() -> Bool {
        return false
    }
    
    func isWin() -> Bool {
        return false
    }
    
    func moveSquare(inDirection direction: Direction, col: Int, row: Int) {
        let squaresAhead = checkAdjacentSquares(inDirection: direction, col: col, row: row)
        let movingSquareIndex = indexOfSquare(col: col, row: row)!
        let movingSquare = squares[movingSquareIndex]
        
        var offset = 0
        
        for square in squaresAhead {
            if square != .empty && square == movingSquare { // then can merge
                // merge moving square and square
                print("merge!")
                return
            } else if square != .empty { // then something in way
                continue
            } else { //then this square is empty
                offset += 1
            }
        }
        
        let destinationIndex = indexOfSquareInDirection(direction, col: col, row: row, byOffset: offset)!
        squares[movingSquareIndex] = .empty
        squares[destinationIndex] = movingSquare
        print(squares)
    }
    
    func merge(_ movingSquareIndex: Int, withSquare squareIndex: Int) {
        
    }
    
    // problems: if 2248, make it impossible to merge all
    
    
}
