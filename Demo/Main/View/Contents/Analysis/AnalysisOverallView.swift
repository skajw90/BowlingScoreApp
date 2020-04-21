//
//  AnalysisOverallView.swift
//  Demo
//
//  Created by Jiwon Nam on 2/23/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

protocol AnalysisOverallViewDataSource {
    func getOverallData() -> (strike: Float?, spare: Float?, open: Float?, split: Float?, splitMade: Float?)
}

class AnalysisOverallView: UIView {
    var dataSource: AnalysisOverallViewDataSource?
    
    lazy var strikeTextLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.text = "Strike:"
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        label.textColor = .black
        addSubview(label)
        return label
    } ()
    lazy var spareTextLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.text = "Spare:"
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        label.textColor = .black
        addSubview(label)
        return label
    } ()
    lazy var openTextLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.text = "Open:"
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        label.textColor = .black
        addSubview(label)
        return label
    } ()
    lazy var splitTextLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.text = "Split:"
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        label.textColor = .black
        addSubview(label)
        return label
    } ()
    lazy var splitMadeTextLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.text = "Split Made:"
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        label.textColor = .black
        addSubview(label)
        return label
    } ()
    lazy var strikeLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.text = "--"
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .left
        label.textColor = .black
        addSubview(label)
        return label
    } ()
    lazy var spareLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.text = "--"
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .left
        label.textColor = .black
        addSubview(label)
        return label
    } ()
    lazy var openLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.text = "--"
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .left
        label.textColor = .black
        addSubview(label)
        return label
    } ()
    lazy var splitLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.text = "--"
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .left
        label.textColor = .black
        addSubview(label)
        return label
    } ()
    lazy var splitMadeLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.text = "--"
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .left
        label.textColor = .black
        addSubview(label)
        return label
    } ()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var firstRow = bounds
        var secondRow: CGRect
        (secondRow, firstRow) = firstRow.divided(atDistance: bounds.maxY / 2, from: .maxYEdge)
        (strikeTextLabel.frame, firstRow) = firstRow.divided(atDistance: bounds.maxX / 6, from: .minXEdge)
        (strikeLabel.frame, firstRow) = firstRow.divided(atDistance: bounds.maxX / 6, from: .minXEdge)
        (spareTextLabel.frame, firstRow) = firstRow.divided(atDistance: bounds.maxX / 6, from: .minXEdge)
        (spareLabel.frame, firstRow) = firstRow.divided(atDistance: bounds.maxX / 6, from: .minXEdge)
        (openTextLabel.frame, firstRow) = firstRow.divided(atDistance: bounds.maxX / 6, from: .minXEdge)
        (openLabel.frame, firstRow) = firstRow.divided(atDistance: bounds.maxX / 6, from: .minXEdge)
        
        (splitTextLabel.frame, secondRow) = secondRow.divided(atDistance: bounds.maxX / 4, from: .minXEdge)
        (splitLabel.frame, secondRow) = secondRow.divided(atDistance: bounds.maxX / 4, from: .minXEdge)
        (splitMadeTextLabel.frame, secondRow) = secondRow.divided(atDistance: bounds.maxX / 4, from: .minXEdge)
        (splitMadeLabel.frame, secondRow) = secondRow.divided(atDistance: bounds.maxX / 4, from: .minXEdge)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let data = self.dataSource!.getOverallData()
        self.strikeLabel.text = (data.strike != nil) ? "\(String(format: "%.2f", data.strike! * 100))%" : "--"
        self.spareLabel.text = (data.spare != nil) ? "\(String(format: "%.2f", data.spare! * 100))%" : "--"
        self.openLabel.text = (data.open != nil) ? "\(String(format: "%.2f", data.open! * 100))%" : "--"
        self.splitLabel.text = (data.split != nil) ? "\(String(format: "%.2f", data.split! * 100))%" : "--"
        self.splitMadeLabel.text = (data.splitMade != nil) ? "\(String(format: "%.2f", data.splitMade! * 100))%" : "--"
        
    }
}
