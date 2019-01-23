//
//  Number.swift
//  2048
//
//  Created by Cheuk Lun Ko on 23/1/2019.
//  Copyright © 2019 Cheuk Lun Ko. All rights reserved.
//

import UIKit


enum SwipeDirection {
    case left, right, up, down
}

enum ValidNumber: Int {
    case two = 0
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
    case none // rawValue = 12
}

class Square: NSObject {
    var value: ValidNumber
    
    init(value: ValidNumber) {
        self.value = value
    }
}
