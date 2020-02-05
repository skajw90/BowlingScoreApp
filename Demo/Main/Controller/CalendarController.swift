//
//  CalendarController.swift
//  Demo
//
//  Created by Jiwon Nam on 1/21/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

protocol CalendarControllerDelegate {
    func openEditGame(date: CalendarData)
    func setMonthlyScores(date: CalendarData)
}

protocol CalendarControllerDataSource {
    func getCurrentDate() -> CalendarData
    func getAverages(date: CalendarData, interval: IntervalFormat) -> ScoreFormat
    func hasContentsInMonth(date: CalendarData) -> [Bool]
}

class CalendarController: CalendarViewDataSource, CalendarViewDelegate {
    var dataSource: CalendarControllerDataSource?
    var delegate: CalendarControllerDelegate?
    var calendarView: CalendarView?
    var currentDate: CalendarData
    var todayCell: Int?
    var curCalendarMap: [Int] = []
    
    init() {
        currentDate = CalendarData()
    }
    
    init(view: CalendarView) {
        currentDate = CalendarData(year: Calendar.current.component(.year, from: Date()), month: Calendar.current.component(.month, from: Date()), day: Calendar.current.component(.day, from: Date()))
        setDaysList(year: currentDate.year!, month: currentDate.month!, day: currentDate.day!)
        
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
    
    func getWeekDay(year: Int, month: Int, day: Int) -> Int {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day

        let calendar = Calendar.current
        let datez = calendar.date(from: dateComponents)
        // change .month into .year to see the days available in the year
        return calendar.dateComponents([.weekday], from: datez!).weekday!
    }
    
    func setDaysList(year: Int, month: Int, day: Int?) {
        curCalendarMap = []
        let numOfDays = getNumOfDays(year: year, month: month)
        var prevNumOfDays = getNumOfDays(year: year, month: month - 1)
        if month == 1 {
            prevNumOfDays = getNumOfDays(year: year - 1, month: 12)
        }
        let firstDayPos = getWeekDay(year: year, month: month, day: 1) - 1
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
                if year == Calendar.current.component(.year, from: Date()) && month == Calendar.current.component(.month, from: Date()) && day == Calendar.current.component(.day, from: Date()) {
                    if monthCount == day && !isPrevMonth && i < firstDayPos + numOfDays  {
                        todayCell = i
                    }
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
        (currentDate.month!, currentDate.year!) = getMonthAndYear(index: index)
        
        var day: Int?
        if currentDate.year! == Calendar.current.component(.year, from: Date()) && currentDate.month! == Calendar.current.component(.month, from: Date()) {
            day = Calendar.current.component(.day, from: Date())
        }
        setDaysList(year: currentDate.year!, month: currentDate.month!, day: day)
        delegate!.setMonthlyScores(date: currentDate)
        calendarView!.updateAll()
    }
    
    func getMonthAndYear(index: Int) -> (Int, Int) {
        var curMonth = currentDate.month! + index
        var curYear = currentDate.year!
        if curMonth > 12 {
            curMonth = 1
            curYear += index
        }
        else if curMonth < 1 {
            curMonth = 12
            curYear += index
        }
        return (curMonth, curYear)
    }
    
    func getCalendar() -> [Int] {
        return curCalendarMap
    }
    
    func getCurrentDate() -> CalendarData {
        return currentDate
    }
    
    func getAverages(interval: IntervalFormat) -> ScoreFormat {
        dataSource!.getAverages(date: dataSource!.getCurrentDate(), interval: interval)
    }
    
    func hasContent(index: Int) -> Bool {
        return dataSource!.hasContentsInMonth(date: currentDate)[index]
    }
    
    func getSelectedCell() -> Int? {
        return todayCell
    }
    
    func openEditGame(pos: Int) {
        var monthAndYear = (currentDate.month!, currentDate.year!)
        if pos < 7 && curCalendarMap[pos] > 20 {
            monthAndYear = getMonthAndYear(index: -1)
        }
        else if pos > 30 && curCalendarMap[pos] < 10 {
            monthAndYear = getMonthAndYear(index: 1)
        }
        
        let selectedDate = CalendarData(year: monthAndYear.1, month: monthAndYear.0, day: curCalendarMap[pos], weekday: WeekDay(rawValue: getWeekDay(year: monthAndYear.1, month: monthAndYear.0, day: curCalendarMap[pos])))
        delegate!.openEditGame(date: selectedDate)
    }
}
