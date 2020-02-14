//
//  RecordScore.swift
//  Demo
//
//  Created by Jiwon Nam on 2/8/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import Foundation

struct RecordScore: Codable {
    var high: Float?
    var highDate: CalendarData?
    var low: Float?
    var lowDate: CalendarData?
    var avg: Float?
    var numOfGame: Int
    
    var highSeries: Float?
    var highSeriesDate: CalendarData?
    var numOfLower150: Float
    var numOfUpper200: Float
    var numOfUpper250: Float
    var numOfPerfect: Float
    
    mutating func setCompareNums(num: Int) {
        numOfGame += 1
        if num < 150 {
            numOfLower150 += 1
        }
        if num >= 200 {
            numOfUpper200 += 1
        }
        if num >= 250 {
            numOfUpper250 += 1
        }
        if num == 300 {
            numOfPerfect += 1
        }
    }
    
    func toArray() -> [(date: CalendarData?, num: Float?)?] {
        var array: [(date: CalendarData?, num: Float?)?] = []
        array.append((date: highDate, num: high))
        array.append((date: lowDate, num: low))
        array.append((date: nil, num: avg))
        array.append((date: highSeriesDate, num: highSeries))
        array.append((date: nil, num: numOfLower150))
        array.append((date: nil, num: numOfUpper200))
        array.append((date: nil, num: numOfUpper250))
        array.append((date: nil, num: numOfPerfect))
        
        return array
    }
}
