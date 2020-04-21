//
//  RecordView.swift
//  Demo
//
//  Created by Jiwon Nam on 1/16/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

protocol RecordViewDataSource {
    func getProfileName() -> String
    func getContentsSize() -> CGSize
    func getRecordInfo() -> (from: CalendarData, to: CalendarData, num: Int)
    func getRecordScoreDatas() -> [(date: CalendarData?, num: Float?)?]
    func getUserOverallAnalysis() -> StatFormat 
}

import UIKit

class RecordView: UIScrollView, RecordInfoViewDataSoucre, RecordScoreViewDataSource, RecordRatioViewDataSource {
    // MARK: - Properties
    var dataSource: RecordViewDataSource?
    // MARK: - UI Properties
    lazy var titleLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.textAlignment = .left
        label.textColor = .white
        label.backgroundColor = .black
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.white.cgColor
        addSubview(label)
        return label
    } ()
    lazy var userInfoLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.text = "User Info"
        label.textAlignment = .left
        label.textColor = .white
        label.backgroundColor = .black
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.white.cgColor
        addSubview(label)
        return label
    } ()
    lazy var recordInfoView: RecordInfoView = {
        let view = RecordInfoView()
        view.dataSource = self
        view.backgroundColor = .white
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.black.cgColor
        addSubview(view)
        return view
    } ()
    lazy var scoreInfoLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.text = "Score Overall"
        label.textAlignment = .left
        label.textColor = .white
        label.backgroundColor = .black
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.white.cgColor
        addSubview(label)
        return label
    } ()
    lazy var recordScoreView: RecordScoreView = {
        let view = RecordScoreView()
        view.dataSource = self
        view.backgroundColor = .white
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.black.cgColor
        addSubview(view)
        return view
    } ()
    lazy var recordRatioLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.text = "Overall Stats"
        label.textAlignment = .left
        label.textColor = .white
        label.backgroundColor = .black
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.white.cgColor
        addSubview(label)
        return label
    } ()
    lazy var recordRatioView: RecordRatioView = {
        let view = RecordRatioView()
        view.dataSource = self
        view.layer.borderColor = UIColor.black.cgColor
        addSubview(view)
        return view
    } ()
    
    // MARK: - UIView Override Functions
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        contentSize = dataSource!.getContentsSize()
        titleLabel.text = dataSource!.getProfileName()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        var rect = CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height)
        var length = contentSize.height
        let titleHeight = contentSize.height / 40
        (titleLabel.frame, rect) = rect.divided(atDistance: 1.5 * titleHeight, from: .minYEdge)
        length -= 3.5 * titleHeight
        (userInfoLabel.frame, rect) = rect.divided(atDistance: titleHeight, from: .minYEdge)
        (recordInfoView.frame, rect) = rect.divided(atDistance: 1 * length / 9, from: .minYEdge)
        (scoreInfoLabel.frame, rect) = rect.divided(atDistance: titleHeight, from: .minYEdge)
        (recordScoreView.frame, rect) = rect.divided(atDistance: 5 * length / 10, from: .minYEdge)
        (recordRatioLabel.frame, rect) = rect.divided(atDistance: titleHeight, from: .minYEdge)
        (recordRatioView.frame, rect) = rect.divided(atDistance: 3 * length / 10, from: .minYEdge)
    }
    
    // MARK: - RecordInfoViewDataSource Function
    func getRecordInfo() -> (from: CalendarData, to: CalendarData, num: Int) { dataSource!.getRecordInfo() }
    
    // MARK: - RecordScoreViewDataSource Function
    func getRecordScoreDatas() -> [(date: CalendarData?, num: Float?)?] { return dataSource!.getRecordScoreDatas() }
    
    // MARK: - RecordRatioViewDataSource Function
    func getUserOverallAnalysis() -> StatFormat { return dataSource!.getUserOverallAnalysis() }
}


// MARK: - UILabel Customed extension functions
extension UILabel {
    func setTextColor() {
        if let text = text, let num = Int(text) {
            if num == 300 { self.textColor = .orange }
            else if num >= 250 { self.textColor = .red }
            else if num >= 200 { self.textColor = .blue }
            else if num >= 180 { self.textColor = .green }
        }
    }
}

// MARK: - Customed UILabel to pad left
class PaddingLabel: UILabel {
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        super.drawText(in: rect.inset(by: insets))
    }
}
