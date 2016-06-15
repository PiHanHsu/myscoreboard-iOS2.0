//
//  Match.swift
//  myscoreboard2.0
//
//  Created by PiHan Hsu on 6/15/16.
//  Copyright © 2016 PiHan Hsu. All rights reserved.
//

import UIKit

struct Match {
    var pair1 = Pair()
    var pair2 = Pair()
    var mWeight: Int = 0
}

struct Pair {
    var player1 = Player()
    var player2 = Player()
    var pWeight: Int = 0
}