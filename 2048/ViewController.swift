//
//  ViewController.swift
//  2048
//
//  Created by Cheuk Lun Ko on 22/1/2019.
//  Copyright © 2019 Cheuk Lun Ko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var bigView: UIView!
    @IBOutlet var columnViews: [UIView]!
    
    var squares = [[UIView]]()
    var board: Board!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetBoard()
        enableSwiping()
        
        // test
        updateBoard()
        
        /*
        loadImage(ofNumber: .eight, col: 2, row: 2)
        board.squares[board.indexOfSquare(col: 2, row: 2)!] = .eight
        board.checkAdjacentSquares(inDirection: .down, col: 2, row: 0)
 */
    }
    
    func resetBoard() {
        board = Board()
        loadUI()
    }
    
    func loadUI() {
        view.backgroundColor = UIColor(red: 0.97, green: 0.98, blue: 0.94, alpha: 1)
        let gridColour = UIColor(red: 0.73, green: 0.68, blue: 0.63, alpha: 1)
        
        bigView.layer.borderColor = gridColour.cgColor
        bigView.layer.borderWidth = 20
        bigView.layer.cornerRadius = 10
        bigView.backgroundColor = gridColour

        squares.removeAll()
        
        for col in 0 ..< 4 {
            
            squares.append([UIView]())

            for row in 0 ..< 4 {
                let columnView = columnViews[col]
                
                let size = min(columnView.frame.width, columnView.frame.height / 4)
                let square = UIView()
                square.frame = CGRect(x: 0, y: 0, width: size, height: size)
                square.layer.borderWidth = 10
                square.layer.cornerRadius = 10
                square.layer.borderColor = gridColour.cgColor
                square.backgroundColor = UIColor(red:0.80, green:0.75, blue:0.71, alpha:1.0)
                square.center = positionForSquare(col: col, row: row)
                
                columnView.addSubview(square)
                squares[col].append(square)
            }
        }
    }
    
    func positionForSquare(col: Int, row: Int) -> CGPoint {
        let column = columnViews[col]
        let size = min(column.frame.width, column.frame.height / 4)
        
        let yCoord = size / 2 + size * CGFloat(row)
        let position = CGPoint(x: 75, y: yCoord)
        return position
    }

    
    func loadImage(ofNumber number: Number, col: Int, row: Int) {
        let column = squares[col]
        let square = column[row]
        
        if number.rawValue != 0 {
            let processedNumber = pow(2, number.rawValue)
            
            let imageView = UIImageView(image: UIImage(named: "\(String(describing: processedNumber)).png"))
            imageView.frame = CGRect(origin: .zero, size: square.frame.size)
            imageView.layer.cornerRadius = 10
            imageView.clipsToBounds = true
            square.addSubview(imageView)
        }
    }
    
    func enableSwiping() {
        let right = UISwipeGestureRecognizer(target: self, action: #selector(squareSwiped(sender:)))
        let left = UISwipeGestureRecognizer(target: self, action: #selector(squareSwiped(sender:)))
        left.direction = .left
        let up = UISwipeGestureRecognizer(target: self, action: #selector(squareSwiped(sender:)))
        up.direction = .up
        let down =  UISwipeGestureRecognizer(target: self, action: #selector(squareSwiped(sender:)))
        down.direction = .down
        
        bigView.addGestureRecognizer(right)
        bigView.addGestureRecognizer(left)
        bigView.addGestureRecognizer(up)
        bigView.addGestureRecognizer(down)
    }
    
    @objc func squareSwiped(sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .up: print("Swipe up detected")
        case .down: print("swipe down detected")
        case .left: print("swipe down detected")
        case .right: print("Swipe right detected")
        default: break
        }
    }
    
    func updateBoard() {
        for col in 0...3 {
            for row in 0...3 {
                let index = board.indexOfSquare(col: col, row: row)!
                let number = board.squares[index]
                loadImage(ofNumber: number, col: col, row: row)
            }
        }
        
    }

}

