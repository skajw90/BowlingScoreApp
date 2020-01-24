//
//  CalendarView.swift
//  Demo
//
//  Created by Jiwon Nam on 1/16/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

protocol CalendarViewDelegate {
    func setCalendar(index: Int)
}

protocol CalendarViewDataSource {
    func getCalendarData() -> ([Int], [Int]?)
    func getSelectedData() -> (Int, Int)
    func getMonthlyData() -> ScoreFormat
    func getSelectedCell() -> Int?
}

class CalendarView: UIView, CalendarContentsViewDataSource, CalendarTopViewDelegate, CalendarTopViewDataSoucre, CalendarBottomViewDataSource {
    var dataSource: CalendarViewDataSource?
    var delegate: CalendarViewDelegate?
    
    lazy var calendarTopView: CalendarTopView = {
        let view = CalendarTopView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.delegate = self
        addSubview(view)
        return view
    } ()
    
    lazy var calendarContentsView: CalendarContentsView = {
        let view = CalendarContentsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        addSubview(view)
        return view
    } ()
    
    lazy var calendarBottomView: CalendarBottomView = {
        let view = CalendarBottomView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        addSubview(view)
        return view
    } ()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    func updateAll() {
        calendarContentsView.calendarGridView.updateCells(map: dataSource!.getCalendarData().0)
        calendarTopView.updateDateLabel()
        calendarBottomView.setMonthlyScore()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = .orange
        
        var rect = bounds
        
        (calendarTopView.frame, rect) = rect.divided(atDistance: frame.maxY / 10, from: .minYEdge)
        
        (calendarContentsView.frame, rect) = rect.divided(atDistance: 8 * frame.maxY / 10, from: .minYEdge)
        
        (calendarBottomView.frame, rect) = rect.divided(atDistance: frame.maxY / 10, from: .minYEdge)
    }
    
    func getCalendarData() -> [Int] {
        return dataSource!.getCalendarData().0
    }
    
    func getSelectedDate() -> (Int, Int) {
        return dataSource!.getSelectedData()
    }
    
    func setCalendar(index: Int) {
        delegate!.setCalendar(index: index)
    }
    
    func getMonthlyData() -> ScoreFormat {
        
        return dataSource!.getMonthlyData()
    }
    
    func getSelectedCell() -> Int? {
        return dataSource!.getSelectedCell()
    }
}
