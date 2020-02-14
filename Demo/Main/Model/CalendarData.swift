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
    
    func compareTo(with: CalendarData) -> Int {
        if self.equalTo(with: with) {
            return 0
        }
        else if lessThan(with: with) {
            return -1
        }
        else {
            return 1
        }
    }
    
    func lessThan(with: CalendarData) -> Bool {
        if let year = year, let month = month, let day = day {
            if year < with.year! || (year == with.year! && (month < with.month! || (month == with.month! && day < with.day!))) {
                return true
            }
        }
        
        return false
    }
    
    func toString() -> String? {
        if let year = year, let month = month, let day = day {
            return "\(month)월 \(day)일 \(year)년"
        }
        else {
            return nil
        }
    }
    
    func equalTo(with: CalendarData) -> Bool {
        if year == with.year && month == with.month && day == with.day {
            return true
        }
        else {
            return false
        }
    }
}
