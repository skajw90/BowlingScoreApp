//
//  CalendarBottomView.swift
//  Demo
//
//  Created by Jiwon Nam on 1/21/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

protocol CalendarBottomViewDataSource {
    func getAverages(interval: IntervalFormat) -> ScoreOverallFormat
}

class CalendarBottomView: UIView {
    // MARK: - Properties
    var dataSource: CalendarBottomViewDataSource?
    var isCalendar: Bool = false
    
    // MARK: - UI Properties
    lazy var monthlyDataLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.text = "Monthly\nData"
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        return label
    } ()
    lazy var noDataLabel: UILabel = {
        let label = UILabel()
        label.text = "No Data"
        label.textAlignment = .center
        label.textColor = .red
        label.numberOfLines = 2
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        return label
    } ()
    lazy var highLowLabel: UILabel = {
        let label = UILabel()
        label.text = "H/G: ---\nL/G: ---"
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 2
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        return label
    } ()
    lazy var averageLabel: UILabel = {
        let label = UILabel()
        label.text = "AVG: ---"
        label.textAlignment = .left
        label.textColor = .white
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        return label
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
        (monthlyDataLabel.frame, rect) = rect.divided(atDistance: frame.maxX / 5, from: .minXEdge)
        (noDataLabel.frame, rect) = rect.divided(atDistance: frame.maxX / 5, from: .minXEdge)
        (highLowLabel.frame, rect) = rect.divided(atDistance: 3 * frame.maxX / 10, from: .minXEdge)
        (averageLabel.frame, rect) = rect.divided(atDistance: 3 * frame.maxX / 10, from: .minXEdge)
    }
    
    // MARK: - Helper Methods to update Data to view
    func updateDateLabel() {
        var score: ScoreOverallFormat?
        if isCalendar {
            score = dataSource!.getAverages(interval: .month)
            monthlyDataLabel.text = "Monthly\nData"
        }
        else {
            score = dataSource!.getAverages(interval: .day)
            monthlyDataLabel.text = "Daily\nData"
        }
        if let high = score!.high, let low = score!.low, let avg = score!.avg {
            noDataLabel.removeFromSuperview()
            highLowLabel.text = "H/G: \(high)\nL/G: \(low)"
            averageLabel.text = "AVG: \(String(format: "%.2f", avg))"
        }
        else {
            addSubview(noDataLabel)
            highLowLabel.text = "H/G: ---\nL/G: ---"
            averageLabel.text = "AVG: ---"
        }
    }
}
