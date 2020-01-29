//
//  calendarWeekView.swift
//  Demo
//
//  Created by Jiwon Nam on 1/21/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

class CalendarWeekView: UIView {
    
    override func draw(_ rect: CGRect) {
        initializeWeekDay()
    }
    
    func initializeWeekDay() {
        for i in 0 ..< 7 {
            let label = UILabel()
            label.textAlignment = .center
            label.adjustsFontForContentSizeCategory = true
            label.text = "\(WeekDay(rawValue: i + 1)!)"
            if i == 0 { label.textColor = .red }
            else if i == 6 { label.textColor = .blue }
            else { label.textColor = .black }
            label.frame = CGRect(x: bounds.maxX / 7 * CGFloat(i), y: 0, width: bounds.maxX / 7, height: bounds.height)
            addSubview(label)
        }
    }
}
