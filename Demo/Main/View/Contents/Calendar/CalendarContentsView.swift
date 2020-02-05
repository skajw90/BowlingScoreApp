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
    var dataSource: CalendarContentsViewDataSource?
    var delegate: CalendarContentsViewDelegate?
    
    lazy var calendarWeekView: CalendarWeekView = {
        let view = CalendarWeekView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    } ()
    
    lazy var calendarGridView: CalendarGridView = {
        let view = CalendarGridView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.delegate = self
        addSubview(view)
        return view
    } ()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var rect = bounds
        (calendarWeekView.frame, rect) = rect.divided(atDistance: frame.maxY / 20, from: .minYEdge)
        (calendarGridView.frame, rect) = rect.divided(atDistance: 19 * frame.maxY / 20, from: .minYEdge)
    }
    
    func getCalendarData() -> [Int] {
        return dataSource!.getCalendarData()
    }
    
    func getSelectedCell() -> Int? {
        return dataSource!.getSelectedCell()
    }
    
    func changeCalendar(isPrev: Bool) {
        delegate!.changeCalendar(isPrev: isPrev)
    }
    
    func openEditGames(pos: Int) {
        delegate!.openEditGame(pos: pos)
    }
    
    func hasContent(index: Int) -> Bool {
        return dataSource!.hasContent(index: index)
    }
}
