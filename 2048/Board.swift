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
    case fortyNinetySix
    case eightyOneNinetyTwo
}

enum Direction {
    case up, down, left, right
}

class Board: NSObject {
    static var width = 4
    static var height = 4
    
    var squares = [Number]()
    
    var newSquares = [Int]()
    
    var testing = false
    
    override init() {
        super.init()
        
        resetBoard()
        
        if !testing {
            generateSquares(howMany: 3)
        }
        
        if testing {
            updateSquare(withNumber: .two, inColumn: 1, row: 0)
            updateSquare(withNumber: .two, inColumn: 2, row: 0)
            updateSquare(withNumber: .four, inColumn: 3, row: 0)
            
        }
        
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
    
    func proceedGame(swipedDirection: Direction) { //player swipes, this is called
        newSquares.removeAll()
        
        if !testing {
            let emptySquares = squares.filter { $0 == .empty }.count
            switch emptySquares {
            case 0: break //no squares generated
            case 1 ..< 3: generateSquares(howMany: 1)
            case 3 ..< 4: generateSquares(howMany: 2)
            default: generateSquares(howMany: 3)
            }
        }

        let order = (0...3)
        
        switch swipedDirection {
        case .up:
            for row in order {
                for col in order {
                    moveSquare(inDirection: .up, col: col, row: row)
                }
            }
        case .down:
            for row in order.reversed() {
                for col in order {
                    moveSquare(inDirection: .down, col: col, row: row)
                }
            }
        case .left:
            for col in order {
                for row in order {
                    moveSquare(inDirection: .left, col: col, row: row)
                }
            }
        case .right:
            for col in order.reversed() {
                for row in order {
                    moveSquare(inDirection: .right, col: col, row: row)
                }
            }
        }
        
        // handle animations
        
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
            case 0, 1:
                squares[index] = .two
            case 2:
                squares[index] = .four
            default: break
            }
            newSquares.append(index)
        }
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
        
        var squaresToMove = 0
        
        for square in squaresAhead {
            if square != .empty && square == movingSquare { // then can merge
                
                let targetSquareIndex = indexOfSquareInDirection(direction, col: col, row: row, byOffset: squaresToMove + 1)!
                
                if !newSquares.contains(targetSquareIndex) {
                    merge(movingSquareIndex, withSquare: targetSquareIndex)
                    return
                } else {
                    break
                }
            } else if square != .empty { // then something in way
                break
            } else { //then this square is empty
                squaresToMove += 1
            }
        }
        
        let destinationIndex = indexOfSquareInDirection(direction, col: col, row: row, byOffset: squaresToMove)!
        squares[movingSquareIndex] = .empty
        squares[destinationIndex] = movingSquare
    }
    
    func merge(_ movingSquareIndex: Int, withSquare squareIndex: Int) {
        if squares[movingSquareIndex] == squares[squareIndex] {
            squares[movingSquareIndex] = .empty
            let doubled = squares[squareIndex].rawValue + 1
            squares[squareIndex] = Number.init(rawValue: doubled)!
            newSquares.append(squareIndex)
        }
    }
    
    
    
}
