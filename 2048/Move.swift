//
//  Move.swift
//  2048
//
//  Created by Cheuk Lun Ko on 25/1/2019.
//  Copyright © 2019 Cheuk Lun Ko. All rights reserved.
//

import UIKit

class Move: NSObject {
    let before: Position
    let after: Position
    let mergeOccured: Bool
    
    init(before: Position, after: Position, mergeOccured: Bool) {
        self.before = before
        self.after = after
        self.mergeOccured = mergeOccured
    }
}
