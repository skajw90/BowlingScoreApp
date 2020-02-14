//
//  RecordRatioView.swift
//  Demo
//
//  Created by Jiwon Nam on 2/7/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

protocol RecordRatioViewDataSource {
    func getUserOverallAnalysis() -> StatFormat
}

class RecordRatioView: UIView {
    var dataSource: RecordRatioViewDataSource?
    
    lazy var strikeNameLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.text = "Strike"
        label.textColor = .black
        label.textAlignment = .left
        addSubview(label)
        return label
    } ()
    
    lazy var strikeInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.text = ":  no Data"
        addSubview(label)
        return label
    } ()
    
    lazy var spareNameLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.text = "Spare"
        label.textColor = .black
        label.textAlignment = .left
        addSubview(label)
        return label
    } ()
    
    lazy var spareInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.text = ":  no Data"
        addSubview(label)
        return label
    } ()
    
    lazy var openNameLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.text = "Open"
        label.textColor = .black
        label.textAlignment = .left
        addSubview(label)
        return label
    } ()
    
    lazy var openInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.text = ":  no Data"
        addSubview(label)
        return label
    } ()
    
    lazy var splitNameLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.text = "Split"
        label.textColor = .black
        label.textAlignment = .left
        addSubview(label)
        return label
    } ()
    
    lazy var splitInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.text = ":  no Data"
        addSubview(label)
        return label
    } ()
    
    lazy var splitMakeNameLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.text = "Split Make"
        label.textColor = .black
        label.textAlignment = .left
        addSubview(label)
        return label
    } ()
    
    lazy var splitMakeInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.text = ":  no Data"
        addSubview(label)
        return label
    } ()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let data = dataSource!.getUserOverallAnalysis()
        let num = data.num
        let strikeCount = data.strikeCount
        let spareCount = data.spareCount
        let openCount = data.openCount
        let splitCount = data.splitCount
        let splitMakecount = 0
        strikeInfoLabel.text = "\(strikeCount)   (\(String(format: "%.2f", Float(strikeCount) / Float(num) * 100))%)"
        spareInfoLabel.text = "\(spareCount)   (\(String(format: "%.2f", Float(spareCount) / Float(num) * 100))%)"
        openInfoLabel.text = "\(openCount)   (\(String(format: "%.2f", Float(openCount) / Float(num) * 100))%)"
        splitInfoLabel.text = "\(splitCount)   (\(String(format: "%.2f", Float(splitCount) / Float(num) * 100))%)"
        splitMakeInfoLabel.text = "\(splitMakecount)   (\(String(format: "%.2f", Float(splitMakecount) / Float(num) * 100))%)"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var rect = bounds
        
        var leftRect = CGRect()
        
        (leftRect, rect) = rect.divided(atDistance: 2 * frame.width / 5, from: .minXEdge)
        
        (strikeNameLabel.frame, leftRect) = leftRect.divided(atDistance: rect.height / 5, from: .minYEdge)
        (spareNameLabel.frame, leftRect) = leftRect.divided(atDistance: rect.height / 5, from: .minYEdge)
        (openNameLabel.frame, leftRect) = leftRect.divided(atDistance: rect.height / 5, from: .minYEdge)
        (splitNameLabel.frame, leftRect) = leftRect.divided(atDistance: rect.height / 5, from: .minYEdge)
        (splitMakeNameLabel.frame, leftRect) = leftRect.divided(atDistance: rect.height / 5, from: .minYEdge)
        
        (strikeInfoLabel.frame, rect) = rect.divided(atDistance: bounds.height / 5, from: .minYEdge)
        (spareInfoLabel.frame, rect) = rect.divided(atDistance: bounds.height / 5, from: .minYEdge)
        (openInfoLabel.frame, rect) = rect.divided(atDistance: bounds.height / 5, from: .minYEdge)
        (splitInfoLabel.frame, rect) = rect.divided(atDistance: bounds.height / 5, from: .minYEdge)
        (splitMakeInfoLabel.frame, rect) = rect.divided(atDistance: bounds.height / 5, from: .minYEdge)
    }
}
