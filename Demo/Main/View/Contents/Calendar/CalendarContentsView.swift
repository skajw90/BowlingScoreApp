//
//  CalendarContentsView.swift
//  Demo
//
//  Created by Jiwon Nam on 1/21/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

protocol CalendarContentsViewDataSource {
    func getSelectedCell() -> Int?
    func getCalendarData() -> [Int]
}

class CalendarContentsView: UIView, CalendarGridViewDataSource {
    var dataSource: CalendarContentsViewDataSource?
    
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
}
