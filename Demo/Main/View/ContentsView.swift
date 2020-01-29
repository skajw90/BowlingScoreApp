//
//  ContentsView.swift
//  Demo
//
//  Created by Jiwon Nam on 1/16/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

//protocol ContentsViewDataSource {
//    func getContentsType() -> ContentsType
//}

class ContentsView: UIView {
    //var dataSource: ContentsViewDataSource?
    var curType: ContentsType = .profile
    var curView: UIView = UIView()

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        curView.backgroundColor = .white
        curView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        addSubview(curView)
    }
    
    func switchViews(selectedType: ContentsType) {
        let preView = curView
        switch selectedType {
        case .profile:
            curView = ProfileView()
        case .scorelist:
            curView = ScoreListView()
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
        case .newGame:
            curView = NewGameView()
        default:
            curView = UIView()
        }
        preView.swapViews(next: curView)
        
        setNeedsDisplay()
    }
}

extension UIView {
    func swapViews(next: UIView) {
        //self.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self!.transform = CGAffineTransform(translationX: -self!.bounds.maxX, y: 0)
            print("\(self!.center)")
            next.transform = CGAffineTransform(translationX: -self!.bounds.maxX, y: 0)} , completion: { _ in
                self.removeFromSuperview()
        })
    }
}

