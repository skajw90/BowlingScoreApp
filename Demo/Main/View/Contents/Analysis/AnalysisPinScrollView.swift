//
//  AnalysisPinScrollView.swift
//  Demo
//
//  Created by Jiwon Nam on 2/23/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit
protocol AnalysisPinScrollViewDataSource {
//    func getPinsetSize() -> Int
    func getPinset() -> (pins: [PinStatInfo], num: Int)
}

class AnalysisPinScrollView: UIScrollView {
    
    var dataSource: AnalysisPinScrollViewDataSource?
    lazy var analysisPinView: [AnalysisPinView] = []
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        initialize()
        let pinViewHeight = bounds.height / 4
        let pinsInfo = dataSource!.getPinset()
        for i in 0 ..< pinsInfo.pins.count {
            let frame = CGRect(x: 0, y: CGFloat(i) * pinViewHeight, width: bounds.width, height: pinViewHeight)
            let temp = AnalysisPinView(frame: frame)
            temp.info = pinsInfo.pins[i]
            temp.totalNum = pinsInfo.num
            
            temp.backgroundColor = .lightGray
            temp.layer.borderColor = UIColor.black.cgColor
            temp.layer.borderWidth = 1
            addSubview(temp)
            analysisPinView.append(temp)
        }
    }
    
    func initialize() {
        for i in 0 ..< analysisPinView.count {
            analysisPinView[i].removeFromSuperview()
        }
        analysisPinView = []
    }
}

//TODO:: need to draw pin view
// need to connect pin view to main controller
