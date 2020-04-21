//
//  RecordScoreView.swift
//  Demo
//
//  Created by Jiwon Nam on 2/7/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

protocol RecordScoreViewDataSource {
    func getRecordScoreDatas() -> [(date: CalendarData?, num: Float?)?]
}

class RecordScoreView: UIView {
    // MARK: - Properties
    var dataSource: RecordScoreViewDataSource?
    
    // MARK: - UI Properties
    lazy var recordScoreNameLabels: [PaddingLabel] = Array(repeating: PaddingLabel(), count: 8)
    lazy var recordScoreDataLabels: [PaddingLabel] = Array(repeating: PaddingLabel(), count: 8)
    
    // MARK: - UIView Override Functions
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setNameLabels()
        setDataLabels()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        var rect = bounds
        var leftRect = CGRect()
        (leftRect, rect) = rect.divided(atDistance: 2 * frame.width / 5, from: .minXEdge)
        for i in 0 ..< 8 {
            (recordScoreNameLabels[i].frame, leftRect) = leftRect.divided(atDistance: frame.height / 8, from: .minYEdge)
            (recordScoreDataLabels[i].frame, rect) = rect.divided(atDistance: frame.height / 8, from: .minYEdge)
        }
    }
    
    // MARK: - Helper Method to update Data
    func setDataLabels() {
        let datas = dataSource!.getRecordScoreDatas()
        for i in 0 ..< datas.count {
            let label = PaddingLabel()
            if let data = datas[i], let num = data.num {
                var date = ""
                if let temp = data.date { date = "(\(temp.toString()!))" }
                if i != 2 { label.text = ":  \(Int(num))  \(date)" }
                else { label.text = ":  \(String(format: "%.2f", num))  \(date)" }
            }
            else { label.text = ":  no data" }
            label.textAlignment = .left
            label.textColor = .black
            recordScoreDataLabels[i] = label
            addSubview(recordScoreDataLabels[i])
       }
    }
    func setNameLabels() {
        for i in 0 ..< 8 {
            let label = PaddingLabel()
            label.text = RecordScoreLabelName(rawValue: i)!.toString()
            label.textAlignment = .left
            label.textColor = .black
            recordScoreNameLabels[i] = label
            addSubview(recordScoreNameLabels[i])
        }
    }
}

// MARK: - Enum for RecordScoreLabelName
enum RecordScoreLabelName: Int {
    case high = 0, low, avg, highS3, lower150, upper200, upper250, perfect
    func toString() -> String {
        var result: String
        switch  self {
        case .high: result = "HIGH"
        case .low: result = "LOW"
        case .avg: result = "AVERAGE"
        case .highS3: result = "High Series (3G)"
        case .lower150: result = "150 DOWN"
        case .upper200: result = "200 UP"
        case .upper250: result = "250 UP"
        default: result = "PERFECT"
        }
        return result
    }
}
