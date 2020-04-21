//
//  RecordInfoView.swift
//  Demo
//
//  Created by Jiwon Nam on 2/7/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

protocol RecordInfoViewDataSoucre {
    func getRecordInfo() -> (from: CalendarData, to: CalendarData, num: Int)
}

class RecordInfoView: UIView {
    // MARK: - Properties
    var dataSource: RecordInfoViewDataSoucre?
    
    // MARK: - UI Properties
    lazy var periodLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.text = "Period"
        label.textColor = .black
        label.textAlignment = .left
        addSubview(label)
        return label
    } ()
    lazy var periodDataLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        addSubview(label)
        return label
    } ()
    lazy var numOfGameLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.text = "Played"
        label.textColor = .black
        label.textAlignment = .left
        addSubview(label)
        return label
    } ()
    lazy var numOfGameDataLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        addSubview(label)
        return label
    } ()
    
    // MARK: - UIView Override Functions
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let data = dataSource!.getRecordInfo()
        periodDataLabel.text = ":  \(data.from.toString()!)\n   ~ \(data.to.toString()!)"
        numOfGameDataLabel.text = ":  \(data.num)"
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        var rect = bounds
        var leftRect = CGRect()
        (leftRect, rect) = rect.divided(atDistance: 2 * frame.width / 5, from: .minXEdge)
        (periodLabel.frame, leftRect) = leftRect.divided(atDistance: frame.height / 2, from: .minYEdge)
        (numOfGameLabel.frame, leftRect) = leftRect.divided(atDistance: frame.height, from: .minYEdge)
        (periodDataLabel.frame, rect) = rect.divided(atDistance: frame.height / 2, from: .minYEdge)
        (numOfGameDataLabel.frame, rect) = rect.divided(atDistance: frame.height / 2, from: .minYEdge)
    }
}
