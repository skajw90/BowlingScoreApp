//
//  bottomMenuSetView.swift
//  Demo
//
//  Created by Jiwon Nam on 1/14/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

protocol BottomMenuSetViewDelegate {
    func openRecord()
    func openGraph()
    func openAnalysis()
    func openSetting()
}

class BottomMenuSetView: UIView {
    
    var delegate: BottomMenuSetViewDelegate?
    
    lazy var recordPreview: UIButton = {
        let btn = UIButton()
        btn.setTitle("RECORD", for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.red.cgColor
        btn.addTarget(self, action: #selector(recordPrevBtnHandler), for: UIControl.Event.touchDown)
        addSubview(btn)
        return btn
    } ()
    
    lazy var graphPreview: UIButton = {
        let btn = UIButton()
        btn.setTitle("GRAPH", for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.red.cgColor
        btn.addTarget(self, action: #selector(graphPrevBtnHandler), for: UIControl.Event.touchDown)
        addSubview(btn)
        return btn
    } ()
    
    lazy var analysisPreview: UIButton = {
        let btn = UIButton()
        btn.setTitle("ANALYSIS", for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.red.cgColor
        btn.addTarget(self, action: #selector(analysisPrevBtnHandler), for: UIControl.Event.touchDown)
        addSubview(btn)
        return btn
    } ()
    
    lazy var settingPreview: UIButton = {
        let btn = UIButton()
        btn.setTitle("SETTING", for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.red.cgColor
        btn.addTarget(self, action: #selector(settingPrevBtnHandler), for: UIControl.Event.touchDown)
        addSubview(btn)
        return btn
    } ()
    
    @objc func recordPrevBtnHandler(sender: Any) {
        print("recordPrev Clicked")
        delegate!.openRecord()
    }
    
    @objc func graphPrevBtnHandler(sender: Any) {
        print("graphPrev Clicked")
        delegate!.openGraph()
    }
    
    @objc func analysisPrevBtnHandler(sender: Any) {
        print("analysisPrev Clicked")
        delegate!.openAnalysis()
    }
    
    @objc func settingPrevBtnHandler(sender: Any) {
        print("settingPrev Clicked")
        delegate!.openSetting()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var rect = bounds
        (recordPreview.frame, rect) = rect.divided(atDistance: frame.width * 0.25, from: .minXEdge)
        
        (graphPreview.frame, rect) = rect.divided(atDistance: frame.width * 0.25, from: .minXEdge)
        
        (analysisPreview.frame, rect) = rect.divided(atDistance: frame.width * 0.25, from: .minXEdge)
        
        (settingPreview.frame, rect) = rect.divided(atDistance: frame.width * 0.25, from: .minXEdge)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
}
