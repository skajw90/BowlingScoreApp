//
//  CalendarData.swift
//  Demo
//
//  Created by Jiwon Nam on 1/21/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

struct CalendarData: Codable {
    var year: Int?
    var month: Int?
    var day: Int?
    var weekday: WeekDay?
    
    enum CodingKeys: String, CodingKey {
        case year = "year"
        case month = "month"
        case day = "day"
        case weekday = "weekday"
    }
    
    func toString() -> String? {
        if let year = year, let month = month, let day = day, let weekday = weekday {
            return "\(month)월 \(day)일 \(weekday)요일, \(year)년"
        }
        else {
            return nil
        }
    }
}
