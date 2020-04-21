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
    func getCurrentDate() -> CalendarData
}

class CalendarTopView: UIView {
    // MARK: - Properties
    var selectedDate: Date?
    var dataSource: CalendarTopViewDataSoucre?
    var delegate: CalendarTopViewDelegate?
    var isCalendar = false
    
    // MARK: - UI Properties
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
      
    // MARK: - UIView Override Functions
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        updateDateLabel()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .orange
        var rect = bounds
        (leftBtn.frame, rect) = rect.divided(atDistance: frame.maxX / 4, from: .minXEdge)
        (dateLabel.frame, rect) = rect.divided(atDistance: frame.maxX / 2, from: .minXEdge)
        (rightBtn.frame, rect) = rect.divided(atDistance: frame.maxX / 4, from: .minXEdge)
    }
    
    // MARK: - Helper Method to update data
    func updateDateLabel() {
        let date = dataSource!.getCurrentDate()
        let year = date.year!
        let month = date.month!
        let day = isCalendar ? "" : "\(date.day!)일"
        dateLabel.text = "\(month)월 \(day) \(year)년"
    }
    
    // MARK: - UIButton Action Hanlder
    @objc func leftBtnHandler(sender: Any) { delegate!.setCalendar(index: -1) }
    @objc func rightBtnHandler(sender: Any) { delegate!.setCalendar(index: 1) }
}
