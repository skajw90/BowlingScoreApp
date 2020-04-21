//
//  CalendarData.swift
//  Demo
//
//  Created by Jiwon Nam on 1/21/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

struct CalendarData: Codable {
    // MARK: - Properties
    var year: Int?
    var month: Int?
    var day: Int?
    var weekday: WeekDay?
    
    // MARK: - add month to calendar, and get calendar
    func add(month: Int) -> CalendarData {
        var result = self
        if let curMonth = self.month, let curYear = self.year {
            if month >= 0 {
                if curMonth + month > 12 {
                    let diff = curMonth + month - 12
                    result.year = curYear + 1
                    result.month = diff
                }
                else { result.month = curMonth + month }
            }
            else {
                if curMonth + month < 1 {
                    let diff = curMonth + month + 12
                    result.year = curYear - 1
                    result.month = diff
                }
                else { result.month = curMonth + month }
            }
        }
        return result
    }
    
    func add(year: Int) -> CalendarData {
        var result = self
        if let year = self.year {
            result.year = year + 1
        }
        return result
    }
    
    // MARK: - Compare Calendar Data Method with Parameter
    func compareTo(with: CalendarData) -> Int {
        if self.equalTo(with: with) { return 0 }
        else if lessThan(with: with) { return -1 }
        else { return 1 }
    }
    
    // MARK: - Helper Method to compare
    private func lessThan(with: CalendarData) -> Bool {
        if let year = year, let withYear = with.year {
            if let month = month, let withMonth = with.month {
                if let day = day, let withDay = with.day {
                    if year < withYear || (year == withYear && (month < withMonth || (month == withMonth && day < withDay))) { return true }
                }
                else {
                    if year < withYear || (year == withYear && month < withMonth) { return true }
                }
            }
            else {
                if year < withYear { return true }
            }
        }
        return false
    }
    
    private func equalTo(with: CalendarData) -> Bool {
        if let year = year, let withYear = with.year {
            if let month = month, let withMonth = with.month {
                if let day = day, let withDay = with.day {
                    if year == withYear && month == withMonth && day == withDay { return true }
                    else { return false }
                }
                else {
                    if year == withYear && month == withMonth { return true }
                    else { return false }
                }
            }
            else {
                if year == withYear { return true }
                else { return false }
            }
        }
        return false
    }
    
    // MARK: - toString MEthod convert to string type
    func toString() -> String? {
        if let year = year{
            if let month = month {
                if let day = day { return "\(month)월 \(day)일 \(year)년" }
                else {
                    return "\(year)년 \(month)월"
                }
            }
            else {
                return "\(year)년"
            }
        }
        else { return nil }
    }
    
    
    
}
