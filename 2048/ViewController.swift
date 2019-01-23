//
//  ViewController.swift
//  2048
//
//  Created by Cheuk Lun Ko on 22/1/2019.
//  Copyright © 2019 Cheuk Lun Ko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var columnViews: [UIView]!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var bigView: UIView!
    
    
    var squareViews = [[UIView]]()
    var board: Board!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetBoard()
    }
    
    func resetBoard() {
        board = Board()
        squareViews = [[UIView]]()
        updateUI()
    }
    
    func updateUI() {
        view.backgroundColor = UIColor(red: 0.97, green: 0.98, blue: 0.94, alpha: 1)
        
        bigView.layer.borderColor = UIColor(red: 0.73, green: 0.68, blue: 0.63, alpha: 1).cgColor
        bigView.layer.borderWidth = 20
        bigView.layer.cornerRadius = 10
        bigView.backgroundColor = UIColor(red: 0.73, green: 0.68, blue: 0.63, alpha: 1)
        
        for col in 0 ..< 4 {
            for row in 0 ..< 4 {
                let frame = columnViews[col].frame
                let size = min(frame.width, frame.height / 4)
                
                let square = UIView()
                square.frame = CGRect(x: 0, y: 0, width: size, height: size)
                square.layer.borderWidth = 10
                square.layer.cornerRadius = 10
                square.layer.borderColor = UIColor(red: 0.73, green: 0.68, blue: 0.63, alpha: 1).cgColor
                square.backgroundColor = UIColor(red:0.80, green:0.75, blue:0.71, alpha:1.0)
                square.center = positionForSquare(col: col, row: row)
                stackView.addSubview(square)
            }
        }

    }
    
    func positionForSquare(col: Int, row: Int) -> CGPoint {
        let column = columnViews[col]
        let size = min(column.frame.width, column.frame.height / 4)
        let xCoord = column.frame.midX
        var yCoord = column.frame.maxY - size / 2
        yCoord -= size * CGFloat(row)
        let position = CGPoint(x: xCoord, y: yCoord)
        print(position)
        return position
    }

    
    
    


}

