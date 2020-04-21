//
//  AnalysisView.swift
//  Demo
//
//  Created by Jiwon Nam on 1/16/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

protocol AnalysisViewDelegate {
    func setPeriod(period: CategoryPeriod)
    func setFrame(frame: Int)
}

protocol AnalysisViewDataSource {
    func getOverallData() -> (strike: Float?, spare: Float?, open: Float?, split: Float?, splitMade: Float?)
    func getPinset() -> (pins: [PinStatInfo], num: Int)
}

class AnalysisView: UIView, AnalysisContentsViewDataSource {
    var dataSource: AnalysisViewDataSource?
    var delegate: AnalysisViewDelegate?
    lazy var segmentControl: UISegmentedControl = {
        let items: [String] = ["1month", "3month", "6month", "1year"]
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0
        control.backgroundColor = .lightGray
        control.tintColor = .white
        control.layer.borderColor = UIColor.black.cgColor
        control.layer.borderWidth = 1
        control.addTarget(self, action: #selector(segmentCategorySelectHandler), for: .valueChanged)
        addSubview(control)
        return control
    } ()
    
    lazy var frameSelector: UISegmentedControl = {
        let items: [String] = ["All", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0
        control.backgroundColor = .lightGray
        control.tintColor = .white
        control.layer.masksToBounds = true
        control.addTarget(self, action: #selector(frameSelectorHandler), for: .valueChanged)
        addSubview(control)
        return control
    } ()
    
    lazy var contentsView: AnalysisContentsView = {
        let view = AnalysisContentsView()
        view.dataSource = self
        addSubview(view)
        return view
    } ()
    
    @objc func segmentCategorySelectHandler(sender: UISegmentedControl) {
        delegate!.setPeriod(period: CategoryPeriod(rawValue: sender.selectedSegmentIndex)!)
        contentsView.update()
    }
    
    @objc func frameSelectorHandler(sender: UISegmentedControl) {
        delegate!.setFrame(frame: sender.selectedSegmentIndex)
        contentsView.update()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var rect = bounds
        (segmentControl.frame, rect) = rect.divided(atDistance: bounds.maxY / 12, from: .minYEdge)
        (frameSelector.frame, rect) = rect.divided(atDistance: bounds.maxY / 12, from: .minYEdge)
        (contentsView.frame, rect) = rect.divided(atDistance: 5 * bounds.maxY / 6, from: .minYEdge)
        contentsView.update()
    }
    
    func getOverallData() -> (strike: Float?, spare: Float?, open: Float?, split: Float?, splitMade: Float?) { return dataSource!.getOverallData() }
    func getPinset() -> (pins: [PinStatInfo], num: Int) { return dataSource!.getPinset() }
}
