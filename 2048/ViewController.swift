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
        updateBoard()
        
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
        
        for col in squares {
            for row in col {
                row.removeFromSuperview()
            }
        }
    
        squares.removeAll()
        
        for col in 0...3 {
            
            squares.append([UIView]())

            for row in 0...3 {
                let columnView = columnViews[col]
                
                let size = min(columnView.frame.width, columnView.frame.height / 4)
                let square = UIView()
                square.frame = CGRect(x: 0, y: 0, width: size, height: size)
                square.layer.borderWidth = 10
                square.layer.cornerRadius = 10
                square.layer.borderColor = gridColour.cgColor
                square.backgroundColor = UIColor(red:0.80, green:0.75, blue:0.71, alpha:1.0)
                square.center = coordForSquare(col: col, row: row)
                
                columnView.addSubview(square)
                squares[col].append(square)
            }
        }
    }
    
    func coordForSquare(col: Int, row: Int) -> CGPoint {
        let column = columnViews[col]
        let size = min(column.frame.width, column.frame.height / 4)
        
        let yCoord = size / 2 + size * CGFloat(row)
        let cgPosition = CGPoint(x: 75, y: yCoord)
        return cgPosition
    }
    
    func squareForPosition(col: Int, row: Int) -> UIView {
        let column = squares[col]
        return column[row]
    }

    func loadImage(ofNumber number: Number, col: Int, row: Int) {
        let square = squareForPosition(col: col, row: row)
        square.subviews.forEach { $0.removeFromSuperview() }
        
        if number != .empty {
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
        let direction = sender.direction
        
        switch direction {
        case .up:
            board.proceedGame(swipedDirection: Direction.up)
        case .down:
            board.proceedGame(swipedDirection: Direction.down)
        case .left:
            board.proceedGame(swipedDirection: Direction.left)
        case .right:
            board.proceedGame(swipedDirection: Direction.right)
        default: break
        }
        
        animate()
        updateBoard()
    }
    
    func updateBoard() {
        if board.canShowWinAlert {
            let ac = UIAlertController(title: "You win!", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Play again", style: .destructive) { [unowned self] _ in
                self.resetBoard()
                self.updateBoard()
            })
            ac.addAction(UIAlertAction(title: "Continue", style: .default))
            present(ac, animated: true)
        } else if board.gameOver {
            let ac = UIAlertController(title: "Game over!", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Play again", style: .default) { [unowned self] _ in
                self.resetBoard()
                self.updateBoard()
            })
            present(ac, animated: true)
        }
        
        for col in 0...3 {
            for row in 0...3 {
                let index = Position(col: col, row: row).index
                let number = board.squares[index]
                loadImage(ofNumber: number, col: col, row: row)
            }
        }
    }
    
    func animate() {
        if board.currentSwipe != nil {  // exists
            for move in board.currentSwipe!.moves {
                let finishedPosition = move.after
                
                let finishedSquare = squareForPosition(col: finishedPosition.col, row: finishedPosition.row)
                
                let xAmount: CGFloat = (CGFloat(move.before.col) - CGFloat(move.after.col)) * 150
                let yAmount: CGFloat = (CGFloat(move.before.row) - CGFloat(move.after.row)) * 150
                
                let column = columnViews[finishedPosition.col]
                if yAmount != 0 {
                    column.bringSubviewToFront(finishedSquare)
                } else if xAmount != 0 {
                    let stackView = column.superview
                    stackView!.bringSubviewToFront(column)
                }
                
                finishedSquare.transform = CGAffineTransform(translationX: xAmount, y: yAmount)
                
                UIView.animate(withDuration: 0.2, animations: {
                    finishedSquare.transform = CGAffineTransform.identity
                }) 
            }
            
        }
    }
    
 

}

