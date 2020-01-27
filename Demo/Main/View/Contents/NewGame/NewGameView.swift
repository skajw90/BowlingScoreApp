//
//  newGameView.swift
//  Demo
//
//  Created by Jiwon Nam on 1/16/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

protocol NewGameViewDelegate {
    func setCalendar(index: Int)
}

protocol NewGameViewDataSource {
    func getCurrentDate() -> CalendarData
    func getScores() -> [GameScore]
}

class NewGameView: UIView, CalendarTopViewDelegate, CalendarTopViewDataSoucre, CalendarBottomViewDataSource {
    
    var delegate: NewGameViewDelegate?
    var dataSource: NewGameViewDataSource?
    
    lazy var calendarTopView: CalendarTopView = {
        let view = CalendarTopView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.delegate = self
        view.isCalendar = false
        addSubview(view)
        return view
    } ()
    
    lazy var sampleColor: UIView = {
        let view = UIView()
        view.backgroundColor = .red
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var rect = bounds
        
        (calendarTopView.frame, rect) = rect.divided(atDistance: frame.maxY / 10, from: .minYEdge)
        
        (sampleColor.frame, rect) = rect.divided(atDistance: 8 * frame.maxY / 10, from: .minYEdge)
        
        
    }
    
    func setCalendar(index: Int) {
        delegate!.setCalendar(index: index)
    }
    
    func getCurrentDate() -> CalendarData {
        dataSource!.getCurrentDate()
    }
    
    func updateAll() {
        calendarTopView.updateDateLabel()
    }
    
    func getMonthlyData() -> ScoreFormat {
        return ScoreFormat(high: 0, low: 0, avg: 0)
    }
}
