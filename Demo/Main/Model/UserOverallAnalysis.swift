//
//  UserFrameStats.swift
//  Demo
//
//  Created by Jiwon Nam on 2/8/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import Foundation

class StatFormat: Codable {
    // MARK: - Properties
    var num: Int
    var strikeCount: Int
    var openCount: Int
    var spareCount: Int
    var splitCount: Int
    var splitMakeCount: Int
    
    // MARK: - Initialize properties default
    init() {
        num = 0
        strikeCount = 0
        openCount = 0
        spareCount = 0
        splitCount = 0
        splitMakeCount = 0
    }
    
    // MARK: - set all properties
    func setStat(num: Int, strikeCount: Int, openCount: Int, spareCount: Int, splitCount: Int, splitMakeCount: Int) {
        self.num += num
        self.strikeCount += strikeCount
        self.openCount += openCount
        self.spareCount += spareCount
        self.splitCount += splitCount
        self.splitMakeCount += splitMakeCount
    }
}

struct PinStatFormat: Codable {
    var leftPins: [[Int]?]
}

struct PinStatInfo {
    var num: Int
    var spareCount: Int
    var PinSet: [Int]
}
