//
//  CalendarContentsView.swift
//  Demo
//
//  Created by Jiwon Nam on 1/21/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

protocol CalendarContentsViewDelegate {
    func changeCalendar(isPrev: Bool)
    func openEditGame(pos: Int)
}

protocol CalendarContentsViewDataSource {
    func getSelectedCell() -> Int?
    func getCalendarData() -> [Int]
    func hasContent(index: Int) -> Bool
}

class CalendarContentsView: UIView, CalendarGridViewDataSource, CalendarGridViewDelegate {
    // MARK: - Properties
    var dataSource: CalendarContentsViewDataSource?
    var delegate: CalendarContentsViewDelegate?
    
    // MARK: - UI Properties
    lazy var calendarWeekView: CalendarWeekView = {
        let view = CalendarWeekView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    } ()
    lazy var calendarGridView: CalendarGridView = {
        let view = CalendarGridView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.delegate = self
        addSubview(view)
        return view
    } ()
    
    // MARK: - UIView Override Function
    override func layoutSubviews() {
        super.layoutSubviews()
        var rect = bounds
        (calendarWeekView.frame, rect) = rect.divided(atDistance: frame.maxY / 20, from: .minYEdge)
        (calendarGridView.frame, rect) = rect.divided(atDistance: 19 * frame.maxY / 20, from: .minYEdge)
    }
    
    // MARK: - CalendarGridViewDataSource Functions
    func getSelectedCell() -> Int? { return dataSource!.getSelectedCell() }
    func getCalendarData() -> [Int] { return dataSource!.getCalendarData() }
    func hasContent(index: Int) -> Bool { return dataSource!.hasContent(index: index) }
    
    // MARK: - CalendarGridViewDelegate Functions
    func changeCalendar(isPrev: Bool) { delegate!.changeCalendar(isPrev: isPrev) }
    func openEditGames(pos: Int) { delegate!.openEditGame(pos: pos) }
}
