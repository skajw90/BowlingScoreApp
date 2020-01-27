//
//  GameScore.swift
//  Demo
//
//  Created by Jiwon Nam on 1/24/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

enum FrameStat {
    case strike
    case spare
    case split
    case miss
}

struct GameScore {
    var frames: [frameInfo]?
}

struct frameInfo {
    var frameNum: Int?
    var firstShot: Int?
    var secondShot: Int?
    var frameStat: FrameStat?
}
