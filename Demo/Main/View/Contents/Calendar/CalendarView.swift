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
    func openEditGame(pos: Int)
}

protocol CalendarViewDataSource {
    func getCalendar() -> [Int]
    func getCurrentDate() -> CalendarData
    func getAverages(interval: IntervalFormat) -> ScoreOverallFormat
    func getSelectedCell() -> Int?
    func hasContent(index: Int) -> Bool
}

class CalendarView: UIView, CalendarContentsViewDataSource, CalendarContentsViewDelegate, CalendarTopViewDelegate, CalendarTopViewDataSoucre, CalendarBottomViewDataSource {
    // MARK: - Properties
    var dataSource: CalendarViewDataSource?
    var delegate: CalendarViewDelegate?
    
    // MARK: - UI Properties
    lazy var calendarTopView: CalendarTopView = {
        let view = CalendarTopView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.delegate = self
        view.isCalendar = true
        addSubview(view)
        return view
    } ()
    lazy var calendarContentsView: CalendarContentsView = {
        let view = CalendarContentsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.delegate = self
        addSubview(view)
        return view
    } ()
    lazy var calendarBottomView: CalendarBottomView = {
        let view = CalendarBottomView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.isCalendar = true
        addSubview(view)
        return view
    } ()
    
    // MARK: - UIView Override Functions
    override func layoutSubviews() {
        super.layoutSubviews()
        var rect = bounds
        (calendarTopView.frame, rect) = rect.divided(atDistance: frame.maxY / 10, from: .minYEdge)
        (calendarContentsView.frame, rect) = rect.divided(atDistance: 8 * frame.maxY / 10, from: .minYEdge)
        (calendarBottomView.frame, rect) = rect.divided(atDistance: frame.maxY / 10, from: .minYEdge)
    }
    
    // MARK: - Update All data method
    func updateAll() {
        calendarContentsView.calendarGridView.updateCells(map: dataSource!.getCalendar())
        calendarTopView.updateDateLabel()
        calendarBottomView.updateDateLabel()
    }
    
    // MARK: - CalendarTopViewDataSource Function
    func getCurrentDate() -> CalendarData { return dataSource!.getCurrentDate() }
    
    // MARK: - CalendaraTopViewDelegate Function
    func setCalendar(index: Int) { delegate!.setCalendar(index: index) }
    
    // MARK: - CalendarBottomViewDataSource Function
    func getAverages(interval: IntervalFormat) -> ScoreOverallFormat { return dataSource!.getAverages(interval: interval) }
    
    // MARK: - CalendarContentsViewDataSoruce Functions
    func getSelectedCell() -> Int? { return dataSource!.getSelectedCell() }
    func getCalendarData() -> [Int] { return dataSource!.getCalendar() }
    func hasContent(index: Int) -> Bool { dataSource!.hasContent(index: index) }
    
    // MARK: - CalendarContentsViewDelegate Functions
    func changeCalendar(isPrev: Bool) { delegate!.setCalendar(index: isPrev ? -1 : 1) }
    func openEditGame(pos: Int) { delegate!.openEditGame(pos: pos) }
}
