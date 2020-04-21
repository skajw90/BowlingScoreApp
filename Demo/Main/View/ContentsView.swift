//
//  ContentsView.swift
//  Demo
//
//  Created by Jiwon Nam on 1/16/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

class ContentsView: UIView {
    
    // MARK: - Properties
    var curType: ContentsType = .profile
    
    // MARK: - UI Properties
    var curView: UIView = UIView()
    
    // MARK: - UIView Override Functions
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        curView.backgroundColor = .white
        curView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        addSubview(curView)
    }
    
    // MARK: - Helper Method to change view with params
    func switchViews(selectedType: ContentsType) {
        let preView = curView
        switch selectedType {
        case .profile: curView = ProfileView()
        case .scorelist: curView = ScoreListView()
        case .calendar: curView = CalendarView()
        case .record:  curView = RecordView()
        case .graph: curView = GraphView()
        case .analysis: curView = AnalysisView()
        case .setting: curView = SettingView()
        case .newGame: curView = NewGameView()
        default: curView = UIView()
        }
        preView.swapViews(next: curView)
        setNeedsDisplay()
    }
}

// MARK: - UIView extension method to swap view with animation
extension UIView {
    func swapViews(next: UIView) {
        //self.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self!.transform = CGAffineTransform(translationX: -self!.bounds.maxX, y: 0)
            next.transform = CGAffineTransform(translationX: -self!.bounds.maxX, y: 0)} , completion: { _ in
                self.removeFromSuperview()
        })
    }
}

