//
//  AnalysisController.swift
//  Demo
//
//  Created by Jiwon Nam on 2/23/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

protocol AnalysisControllerDataSource {
    func getAnalysisOverallData(period: CategoryPeriod, frame: Int) -> Details
    func getAnalysisPinSets(period: CategoryPeriod, frame: Int) -> (pins: [PinStatInfo], num: Int)
}

class AnalysisController: AnalysisViewDelegate, AnalysisViewDataSource {
    var dataSource: AnalysisControllerDataSource?
    var analysisView: AnalysisView
    var selectedFrame: Int = 0
    var selectedPeriod: CategoryPeriod = CategoryPeriod(rawValue: 0)!
    
    init(view: AnalysisView) {
        analysisView = view
        analysisView.dataSource = self
        analysisView.delegate = self
    }
    
    func setPeriod(period: CategoryPeriod) { selectedPeriod = period }
    
    func setFrame(frame: Int) { selectedFrame = frame }
    
    func getOverallData() -> (strike: Float?, spare: Float?, open: Float?, split: Float?, splitMade: Float?) {
        let overall = dataSource!.getAnalysisOverallData(period: selectedPeriod, frame: selectedFrame)
        if overall.count == 0 {
            return (strike: nil, spare: nil, open: nil, split: nil, splitMade: nil)
        }
        let count = Float(overall.count)
        let strike = Float(overall.strikeCount) / count
        let spare = Float(overall.spareCount) / count
        let open = Float(overall.openCount) / count
        let split = Float(overall.splitCount) / count
        let splitMade = overall.splitCount == 0 ? nil : Float(overall.splitMakeCount) / Float(overall.splitCount)
        
        
        return (strike: strike, spare: spare, open: open, split: split, splitMade: splitMade)
    }
    
    func getPinset() -> (pins: [PinStatInfo], num: Int) { return dataSource!.getAnalysisPinSets(period: selectedPeriod, frame: selectedFrame) }
}
