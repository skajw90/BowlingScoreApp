//
//  UserFrameStats.swift
//  Demo
//
//  Created by Jiwon Nam on 2/8/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import Foundation

class StatFormat: Codable {
    var num: Int
    var strikeCount: Int
    var openCount: Int
    var spareCount: Int
    var splitCount: Int
    var pinStat: PinStatFormat?
    
    init() {
        num = 0
        strikeCount = 0
        openCount = 0
        spareCount = 0
        splitCount = 0
    }
    
    func setStat(num: Int, strikeCount: Int, openCount: Int, spareCount: Int, splitCount: Int) {
        self.num += num
        self.strikeCount += strikeCount
        self.openCount += openCount
        self.spareCount += spareCount
        self.splitCount += splitCount
    }
}

struct PinStatFormat: Codable {
    var firstRemain: [Int]
    var secondRemain: [Int]
}
