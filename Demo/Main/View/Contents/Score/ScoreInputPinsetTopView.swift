//
//  ScoreInputPinsetView.swift
//  Demo
//
//  Created by Jiwon Nam on 1/28/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit
protocol ScoreInputPinsetTopViewDataSource {
    func getPinSet(frame: Int) -> [Int]?
    func getTurn() -> (frame: Int, turn: Int)
    func isFirstPinInput() -> Bool
}

class ScoreInputPinsetTopView: UIView, PinsetPreviewDataSource {
    var dataSource: ScoreInputPinsetTopViewDataSource?
    lazy var pinsetPreview: [PinsetPreview] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderWidth = 2
        layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        for i in 0 ..< 10 {
            let tempPinset = PinsetPreview()
            tempPinset.tag = i
            tempPinset.layer.borderWidth = 1
            tempPinset.layer.borderColor = UIColor.black.cgColor
            tempPinset.dataSource = self
            tempPinset.isPreset = true
            tempPinset.currentFrame = i * 2 + 1
            addSubview(tempPinset)
            pinsetPreview.append(tempPinset)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var rect = bounds
        for i in 0 ..< 10 {
            if i == 9 {
                (pinsetPreview[i].frame, rect) = rect.divided(atDistance: 3 * frame.width / 21, from: .minXEdge)
            }
            else {
                (pinsetPreview[i].frame, rect) = rect.divided(atDistance: 2 * frame.width / 21, from: .minXEdge)
            }
        }
    }
    
    func updatePinsetPreview(index: Int) { pinsetPreview[index].update() }
    
    func getPinSet(frame: Int) -> [Int]? { dataSource!.getPinSet(frame: frame) }
    
    func getTurn() -> (frame: Int, turn: Int) { dataSource!.getTurn() }
    
    func isFirstPinInput() -> Bool { dataSource!.isFirstPinInput() }
}

