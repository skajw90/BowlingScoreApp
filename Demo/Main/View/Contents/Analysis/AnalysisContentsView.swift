//
//  AnalysisContentsView.swift
//  Demo
//
//  Created by Jiwon Nam on 2/23/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

protocol AnalysisContentsViewDataSource {
    func getOverallData() -> (strike: Float?, spare: Float?, open: Float?, split: Float?, splitMade: Float?)
    func getPinset() -> (pins: [PinStatInfo], num: Int)
}

class AnalysisContentsView: UIView, AnalysisOverallViewDataSource, AnalysisPinScrollViewDataSource {
    
    var dataSource: AnalysisContentsViewDataSource?
    
    lazy var analysisOverallView: AnalysisOverallView = {
        let view = AnalysisOverallView()
        view.dataSource = self
        addSubview(view)
        return view
    } ()
    lazy var pinsTextLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.text = "Pins"
        label.textAlignment = .left
        label.backgroundColor = .black
        addSubview(label)
        return label
    } ()
    
    lazy var contentScrolView: AnalysisPinScrollView = {
        let view = AnalysisPinScrollView()
        view.dataSource = self
        view.backgroundColor = .gray
        addSubview(view)
        return view
    } ()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var rect = bounds
        (analysisOverallView.frame, rect) = rect.divided(atDistance: bounds.maxY / 8, from: .minYEdge)
        (pinsTextLabel.frame, rect) = rect.divided(atDistance: bounds.maxY / 16, from: .minYEdge)
        (contentScrolView.frame, rect) = rect.divided(atDistance: 13 * bounds.maxY / 16, from: .minYEdge)
    }
    
    func update() {
        analysisOverallView.setNeedsDisplay()
        contentScrolView.setNeedsDisplay()
    }
    
    func getOverallData() -> (strike: Float?, spare: Float?, open: Float?, split: Float?, splitMade: Float?) {
        return dataSource!.getOverallData()
    }
    
    func getPinset() -> (pins: [PinStatInfo], num: Int) {
        let result = dataSource!.getPinset()
        contentScrolView.contentSize.height = CGFloat(result.pins.count) * contentScrolView.bounds.maxY / 4
        return dataSource!.getPinset()
    }
}
