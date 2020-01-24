//
//  CalendarTopView.swift
//  Demo
//
//  Created by Jiwon Nam on 1/21/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

protocol CalendarTopViewDelegate {
    func setCalendar(index: Int)
}

protocol CalendarTopViewDataSoucre {
    func getSelectedDate() -> (Int, Int)
}

class CalendarTopView: UIView {
    var selectedDate: Date?
    var dataSource: CalendarTopViewDataSoucre?
    var delegate: CalendarTopViewDelegate?
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        return label
    } ()
    
    lazy var leftBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("<<", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(leftBtnHandler), for: UIControl.Event.touchDown)
        btn.translatesAutoresizingMaskIntoConstraints = false
        addSubview(btn)
        return btn
    } ()
    
    lazy var rightBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle(">>", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(rightBtnHandler), for: UIControl.Event.touchDown)
        btn.translatesAutoresizingMaskIntoConstraints = false
        addSubview(btn)
        return btn
    } ()
        
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        updateDateLabel()
    }
    
    func updateDateLabel() {
        let date = dataSource!.getSelectedDate()
        let year = date.0
        let month = date.1
        dateLabel.text = "\(month)월 \(year)"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var rect = bounds
        
        (leftBtn.frame, rect) = rect.divided(atDistance: frame.maxX / 4, from: .minXEdge)
        (dateLabel.frame, rect) = rect.divided(atDistance: frame.maxX / 2, from: .minXEdge)
        (rightBtn.frame, rect) = rect.divided(atDistance: frame.maxX / 4, from: .minXEdge)
        
    }
    
    @objc func leftBtnHandler(sender: Any) {
        delegate!.setCalendar(index: -1)
    }
    
    @objc func rightBtnHandler(sender: Any) {
        delegate!.setCalendar(index: 1)
    }
}
