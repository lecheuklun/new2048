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

enum AnimationType {
    case move, merge
}

class Board: NSObject {
    static var width = 4
    static var height = 4
    
    var squares = [Number]()
    var newSquares = [Int]()
    
    var testing = true
    
    var currentSwipe: Swipe?
    var moves = [Move]()
    
    override init() {
        super.init()
        
        currentSwipe = nil
        
        resetBoard()
        
        if !testing {
            generateSquares(howMany: 3)
        }
        
        if testing {
            updateSquare(withNumber: .two, position: Position(col: 0, row: 0))
            
        }
        
    }
    
    func resetBoard() {
        squares = [Number]()
        
        for _ in 0 ..< 16 {
            squares.append(.empty)
        }
    }
    
    func updateSquare(withNumber number: Number, position: Position) {
        /*
         1  2  3  4         row 0
         5  6  7  8
         9  10 11 12
         13 14 15 16        row 3
         */
        squares[position.index] = number
    }
    
    func number(inPosition position: Position) -> Number {
        return squares[position.index]
    }
    
    func positionOfSquareInDirection(_ direction: Direction, position: Position, byOffset offset: Int) -> Position {
        
        switch direction {
        case .up:
            return Position(col: position.col, row: position.row - offset)
        case .down:
            return Position(col: position.col, row: position.row + offset)
        case .left:
            return Position(col: position.col - offset, row: position.row)
        case .right:
            return Position(col: position.col + offset, row: position.row)
        }
    }
    
    func checkAdjacentSquares(inDirection direction: Direction, position: Position) -> [Number] {
        var results = [Number]()
        
        for i in 1...3 {
            let position = positionOfSquareInDirection(direction, position: position, byOffset: i)
            
            let index = position.index
            if (0...15).contains(index) && (0...3).contains(position.col) && (0...3).contains(position.row) {
                results.append(squares[index])
            }
        }
        return results
    }
    
    func proceedGame(swipedDirection: Direction) { //player swipes, this is called
        newSquares.removeAll()
        moves.removeAll()
        
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
                    moveSquare(inDirection: .up, position: Position(col: col, row: row))
                }
            }
        case .down:
            for row in order.reversed() {
                for col in order {
                    moveSquare(inDirection: .down, position: Position(col: col, row: row))
                }
            }
        case .left:
            for col in order {
                for row in order {
                    moveSquare(inDirection: .left, position: Position(col: col, row: row))
                }
            }
        case .right:
            for col in order.reversed() {
                for row in order {
                    moveSquare(inDirection: .right, position: Position(col: col, row: row))
                }
            }
        }
        
        currentSwipe = Swipe(direction: swipedDirection, moves: moves)
        
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
    
    func moveSquare(inDirection direction: Direction, position: Position) {
        let squaresAhead = checkAdjacentSquares(inDirection: direction, position: position)
        let movingSquare = squares[position.index]
        
        var squaresToMove = 0
        
        for square in squaresAhead {
            if square != .empty && square == movingSquare { // then can merge
                
                let targetSquarePosition = positionOfSquareInDirection(direction, position: position, byOffset: squaresToMove + 1)
                
                if !newSquares.contains(targetSquarePosition.index) {
                    merge(movingSquarePosition: position, withSquare: targetSquarePosition)
                    
                    let move = Move(before: position, after: targetSquarePosition, mergeOccured: true)
                    moves.append(move)
                    
                    return
                } else {
                    break
                }
            } else if square != .empty { // then something in way
                break
            } else if movingSquare != .empty { //then this square is empty
                squaresToMove += 1
            }
        }
        
        if squaresToMove != 0 {
            let destinationPosition = positionOfSquareInDirection(direction, position: position, byOffset: squaresToMove)
            squares[position.index] = .empty
            squares[destinationPosition.index] = movingSquare
            
            let move = Move(before: position, after: destinationPosition, mergeOccured: false)
            moves.append(move)
        }
    }
    
    func merge(movingSquarePosition position: Position, withSquare targetPosition: Position) {
        if squares[position.index] == squares[targetPosition.index] {
            squares[position.index] = .empty
            let doubled = squares[targetPosition.index].rawValue + 1
            squares[targetPosition.index] = Number.init(rawValue: doubled)!
            newSquares.append(targetPosition.index)
        }
    }
    
    
    
}
