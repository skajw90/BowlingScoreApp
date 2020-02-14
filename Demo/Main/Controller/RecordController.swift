//
//  RecordController.swift
//  Demo
//
//  Created by Jiwon Nam on 2/7/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

protocol RecordControllerDataSource {
    func getRecordInfo() -> (from: CalendarData, to: CalendarData, num: Int)
    func getRecordScoreDatas() -> [(date: CalendarData?, num: Float?)?]
    func getUserOverallAnalysis() -> StatFormat
}

class RecordController: RecordViewDataSource {
    
    // MARK: - Properties
    var dataSource: RecordControllerDataSource?
    var recordView: RecordView?
    var name: String?
    
    // MARK: - Initialize
    init(view: RecordView, name: String) {
        recordView = view
        self.name = name
        recordView!.dataSource = self
     }
    
    // MARK: - RecordViewDataSource Functions
    func getProfileName() -> String { return name! }
    func getContentsSize() -> CGSize { return CGSize(width: recordView!.frame.width, height: 800) }
    func getRecordInfo() -> (from: CalendarData, to: CalendarData, num: Int) { return dataSource!.getRecordInfo() }
    func getRecordScoreDatas() -> [(date: CalendarData?, num: Float?)?] { return dataSource!.getRecordScoreDatas() }
    func getUserOverallAnalysis() -> StatFormat { return dataSource!.getUserOverallAnalysis() }
}
