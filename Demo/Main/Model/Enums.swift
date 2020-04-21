//
//  WeekDay.swift
//  Demo
//
//  Created by Jiwon Nam on 1/21/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

// MARK: - Enum WeekDay
enum WeekDay: Int, Codable {
    case Sun = 1, Mon, Tue, Wed, Thu, Fri, Sat
}
// MARK: - Enum Input Mode
enum InputMode {
    case pad, pin
}

// MARK: - Enum Contents Type
enum ContentsType {
    case profile, scorelist, newGame, camera, calendar, record, graph, analysis, setting
}

// MARK: - Enum Interval Format
enum IntervalFormat {
    case day, month, year
}

// MARK: - Enum ScoreStat
enum ScoreStat: String, Codable {
    case strike = "strike"
    case spare = "spare"
    case open = "open"
    case split = "split"
    case splitMake = "splitMake"
}

// MARK: - Enum Category for graph
enum Category: Int {
    case score = 0, st_sp, numOfPlay
    func toString() -> String {
        switch self {
        case .score: return "Score"
        case .st_sp: return "ST/SP"
        default: return "Played"
        }
    }
}

enum CategoryPeriod: Int {
    case month1 = 0, month3, month6, year
    func toString() -> String {
        switch self {
        case .month1: return "1 Month"
        case .month3: return "3 Month"
        case .month6: return "6 Month"
        default: return "Year"
        }
    }
}

let SPLITCASES: [String] = ["7,10,", "7,9,", "8,10,", "4,6,", "5,7,", "5,10,", "2,6,", "3,4,", "4,9,", "6,8,", "5,7,10,", "3,7,", "2,10,", "2,7,", "3,10,", "2,9,", "3,8,", "2,3,", "8,9,", "2,7,10,", "3,7,10,", "4,7,10,", "6,7,10,", "4,6,7,10,", "4,5,", "5,6,", "7,8,", "9,10,", "4,6,7,8,10,", "4,6,7,9,10,", "3,4,6,7,10,", "2,4,6,7,10,", "2,4,6,7,8,10,", "3,4,6,7,9,10,"]
   

let serverURL = "http://174.23.151.160:2142/api/"
