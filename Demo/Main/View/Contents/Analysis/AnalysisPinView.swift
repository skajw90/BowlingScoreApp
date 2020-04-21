//
//  AnalysisPinInfoView.swift
//  Demo
//
//  Created by Jiwon Nam on 2/23/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

class AnalysisPinView: UIView, PinsetPreviewDataSource, AnalysisPinInfoViewDataSource {
    var info: PinStatInfo = PinStatInfo(num: 0, spareCount: 0, PinSet: [])
    var totalNum: Int = 0
    
    lazy var overallView: AnalysisPinInfoView = {
        let view = AnalysisPinInfoView()
        view.dataSource = self
        addSubview(view)
        return view
    } ()
    
    lazy var pinView: PinsetPreview = {
        let view = PinsetPreview()
        view.dataSource = self
        view.backgroundColor = .white
        view.backgroundLabel.text = ""
        view.setAllbuttonDisable()
        addSubview(view)
        return view
    } ()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var rect = bounds
        (overallView.frame, rect) = rect.divided(atDistance: 3 * bounds.maxX / 4, from: .minXEdge)
        (pinView.frame, rect) = rect.divided(atDistance: bounds.maxX / 4, from: .minXEdge)
    }
    
    func getPinSet(frame: Int) -> [Int]? { return info.PinSet }
    func getTurn() -> (frame: Int, turn: Int) { return (frame: 0, turn: 0) }
    func isFirstPinInput() -> Bool { return false }
    
    func getPinInfo() -> PinStatInfo {
        return info
    }
    func getTotalNumOfPins() -> Int { return totalNum }
}


protocol AnalysisPinInfoViewDataSource {
    func getPinInfo() -> PinStatInfo
    func getTotalNumOfPins() -> Int
}

class AnalysisPinInfoView: UIView {
    var dataSource: AnalysisPinInfoViewDataSource?
    
    lazy var occuranceTextLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.text = "Ratio:"
        label.textAlignment = .left
        label.textColor = .black
        addSubview(label)
        return label
    } ()
    
    lazy var spareTextLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.text = "Make:"
        label.textAlignment = .left
        label.textColor = .black
        addSubview(label)
        return label
    } ()
    
    lazy var pinsTextLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.text = "Pins:"
        label.textAlignment = .left
        label.textColor = .black
        addSubview(label)
        return label
    } ()
    
    // occurance ratio
    lazy var occuranceLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.textColor = .black
        addSubview(label)
        return label
    } ()
    // spare ratio
    lazy var spareLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.textColor = .black
        addSubview(label)
        return label
    } ()
    
    lazy var pinsLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.textAlignment = .left
        label.textColor = .black
        addSubview(label)
        return label
    } ()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let data = dataSource!.getPinInfo()
        let num = dataSource!.getTotalNumOfPins()
        var pinString = ""
        if data.PinSet.count == 0 {
            pinString = "Striked"
        }
        else {
            for i in 0 ..< data.PinSet.count - 1 {
                pinString += "\(data.PinSet[i] + 1), "
            }
            if data.PinSet.count - 1 >= 0 {
                pinString += "\(data.PinSet[data.PinSet.count - 1] + 1)"
            }
        }
        let occuredRate = Float(data.num) / Float(num)
        let coveredRate = Float(data.spareCount) / Float(data.num)
        pinsLabel.text = pinString
        occuranceLabel.text = "\(String(format: "%0.2f", occuredRate * 100))%"
        spareLabel.text = "\(String(format: "%0.2f", coveredRate * 100))%"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var firstLine = bounds
        var secondLine = CGRect()
        (secondLine, firstLine) = firstLine.divided(atDistance: bounds.maxY / 2, from: .maxYEdge)
        (pinsTextLabel.frame, firstLine) = firstLine.divided(atDistance: bounds.maxX / 5, from: .minXEdge)
        (pinsLabel.frame, firstLine) = firstLine.divided(atDistance: 4 * bounds.maxX / 5, from: .minXEdge)
        (occuranceTextLabel.frame, secondLine) = secondLine.divided(atDistance: bounds.maxX / 4, from: .minXEdge)
        (occuranceLabel.frame, secondLine) = secondLine.divided(atDistance: bounds.maxX / 4, from: .minXEdge)
        (spareTextLabel.frame, secondLine) = secondLine.divided(atDistance: bounds.maxX / 4, from: .minXEdge)
        (spareLabel.frame, secondLine) = secondLine.divided(atDistance: bounds.maxX / 4, from: .minXEdge)
    }
}
