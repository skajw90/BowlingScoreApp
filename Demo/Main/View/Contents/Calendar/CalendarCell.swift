//
//  CalendarCell.swift
//  Demo
//
//  Created by Jiwon Nam on 1/23/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

class CalendarCell: UIView {
    var x: Int = 0
    var y: Int = 0
    var isMainDaysInMonth = false
    var isToday = false
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        addSubview(label)
        return label
    } ()
    
    lazy var dailyAverage: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    } ()
    var circle: UIView?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        dateLabel.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height / 2)
        dailyAverage.frame = CGRect(x: 0, y: bounds.height / 2, width: bounds.width, height: bounds.height / 2)
        
        if isToday {
            circle = UIView()
            circle!.frame = CGRect(x: (bounds.maxX - bounds.height / 2) / 2, y: 0, width: bounds.height / 2, height: bounds.height / 2)
            circle!.layer.borderWidth = 2.0
            circle!.layer.borderColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
            circle!.layer.masksToBounds = false
            circle!.layer.cornerRadius = bounds.maxY / 4
            circle!.clipsToBounds = true
            addSubview(circle!)
        }
        else if let circle = circle {
            circle.removeFromSuperview()
        }
    }
    
    func update(date: Int, avg: Float?) {
        dateLabel.text = "\(date)"
        if x == 0 { dateLabel.textColor = .red }
        else if x == 6 {dateLabel.textColor = .blue }
        else { dateLabel.textColor = .black}
        
        if !isMainDaysInMonth {
            dateLabel.alpha = 0.3
        }
        else {
            dateLabel.alpha = 1
        }
        
        if let score = avg {
            dailyAverage.text = "avg: \(score)"
            dailyAverage.textColor = .black
            addSubview(dailyAverage)
        }
        setNeedsDisplay()
    }
}
