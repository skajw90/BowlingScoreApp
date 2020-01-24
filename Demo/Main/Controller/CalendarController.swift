//
//  CalendarController.swift
//  Demo
//
//  Created by Jiwon Nam on 1/21/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

protocol CalendarControllerDataSource {
    func getUserData(year: Int, month: Int, day: Int) -> ScoreFormat
    func getUserData(from: Int, to: Int, format: IntervalFormat) -> ScoreFormat
}

class CalendarController: CalendarViewDataSource, CalendarViewDelegate {
    
    var dataSource: CalendarControllerDataSource?
    var calendarView: CalendarView?
    var curDate: (Int, Int, Int, Int)
    var todayCell: Int?
    var curCalendarMap: [Int] = []
    
    init(view: CalendarView, selectedDate: Date) {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: selectedDate)
        let month = calendar.component(.month, from: selectedDate)
        let day = calendar.component(.day, from: selectedDate)
        let weekday = calendar.component(.weekday, from: selectedDate)
        curDate = (year, month, day, weekday)
        setDaysList(year: year, month: month, day: day)
        
        view.delegate = self
        view.dataSource = self
        calendarView = view
    }
    
    func getNumOfDays(year: Int, month: Int) -> Int {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month

        let calendar = Calendar.current
        let datez = calendar.date(from: dateComponents)
        // change .month into .year to see the days available in the year
        let interval = calendar.dateInterval(of: .month, for: datez!)!

        return calendar.dateComponents([.day], from: interval.start, to: interval.end).day!
    }
    
    func getFirstDayPos(year: Int, month: Int) -> Int {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month

        let calendar = Calendar.current
        let datez = calendar.date(from: dateComponents)
        // change .month into .year to see the days available in the year
        let interval = calendar.dateInterval(of: .month, for: datez!)!
        
        return calendar.dateComponents([.weekday], from: interval.start).weekday!
    }
    
    func setDaysList(year: Int, month: Int, day: Int?) {
        curCalendarMap = []
        let numOfDays = getNumOfDays(year: year, month: month)
        var prevNumOfDays = getNumOfDays(year: year, month: month - 1)
        if month == 1 {
            prevNumOfDays = getNumOfDays(year: year - 1, month: 12)
        }
        let firstDayPos = getFirstDayPos(year: year, month: month) - 1
        
        var isPrevMonth = true
        var monthCount: Int = prevNumOfDays - (firstDayPos - 1)
        for i in 0 ..< 42 {
            if monthCount > prevNumOfDays && isPrevMonth {
                monthCount = 1
                isPrevMonth = false
            }
            else if monthCount > numOfDays && !isPrevMonth {
                monthCount = 1
            }
            if let day = day {
                if monthCount == day && !isPrevMonth {
                    todayCell = i
                }
            }
            else {
                todayCell = nil
            }
    
            curCalendarMap.append(monthCount)
            monthCount += 1
        }
    }
    
    func setCalendar(index: Int) {
        
        curDate.1 += index
        if curDate.1 > 12 {
            curDate.1 = 1
            curDate.0 += 1
        }
        else if curDate.1 < 1 {
            curDate.1 = 12
            curDate.0 -= 1
        }
        var day: Int?
        if curDate.0 == Calendar.current.component(.year, from: Date()) && curDate.1 == Calendar.current.component(.month, from: Date()) {
            day = Calendar.current.component(.day, from: Date())
        }
        setDaysList(year: curDate.0, month: curDate.1, day: day)
        calendarView!.updateAll()
    }
    
    func getCalendarData() -> ([Int], [Int]?) {
        return (curCalendarMap, nil)
    }
    
    func getSelectedData() -> (Int, Int) {
        return (curDate.0, curDate.1)
    }
    
    func getMonthlyData() -> ScoreFormat {
        return dataSource!.getUserData(from: curDate.1, to: curDate.1, format: .month)
    }
    
    func getSelectedCell() -> Int? {
        
        return todayCell
    }
}
