//
//  ContentsView.swift
//  Demo
//
//  Created by Jiwon Nam on 1/16/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

enum contentsType {
    case profile
    case newGame
    case camera
    case calendar
    case record
    case graph
    case analysis
    case setting
}

protocol ContentsViewDataSource {
    func getContentsType() -> contentsType
}

class ContentsView: UIView {
    var dataSource: ContentsViewDataSource?
    var curType: contentsType = .profile
    var curView: UIView = ProfileView()
//    var newGameView: NewGameView = {
//        let view = NewGameView()
//        view.backgroundColor = .red
//        return view
//    } ()
//    var calendarView: CalendarView = {
//        let view = CalendarView()
//        view.backgroundColor = .orange
//        return view
//    } ()
//    var recordView: RecordView = {
//        let view = RecordView()
//        view.backgroundColor = .yellow
//        return view
//    } ()
//    var graphView: GraphView = {
//        let view = GraphView()
//        view.backgroundColor = .green
//        return view
//    } ()
//    var analysisView: AnalysisView = {
//        let view = AnalysisView()
//        view.backgroundColor = .blue
//        return view
//    } ()
//    var settingView: SettingView = {
//        let view = SettingView()
//        view.backgroundColor = .purple
//        return view
//    } ()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        curView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        addSubview(curView)
    }
    
    func switchViews() {
        curView.removeFromSuperview()
        switch dataSource!.getContentsType() {
        case .profile:
            curView = ProfileView()
        case .newGame:
            curView = NewGameView()
        case .calendar:
            curView = CalendarView()
        case .record:
            curView = RecordView()
        case .graph:
            curView = GraphView()
        case .analysis:
            curView = AnalysisView()
        case .setting:
            curView = SettingView()
        default:
            curView = ProfileView()
        }
        setNeedsDisplay()
    }
}
