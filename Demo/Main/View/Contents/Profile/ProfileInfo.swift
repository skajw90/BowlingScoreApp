//
//  ProfileInfo.swift
//  Demo
//
//  Created by Jiwon Nam on 1/23/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

protocol ProfileInfoDataSource {
    func getProfileInfo() -> (String, ScoreOverallFormat?)
}

class ProfileInfo: UIView {
    var dataSource: ProfileInfoDataSource?
    var record: Bool = false
    
    lazy var nameLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.textAlignment = .left
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        return label
    } ()
    
    lazy var highScoreLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.textAlignment = .left
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        return label
    } ()
    
    lazy var lowScorelabel: PaddingLabel = {
        let label = PaddingLabel()
        label.textAlignment = .left
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        return label
    } ()
    
    lazy var averageLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.textAlignment = .left
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        return label
    } ()
    
    lazy var numOfGameLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.textAlignment = .left
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        return label
    } ()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        DispatchQueue.main.async {
            if self.record {
                self.backgroundColor = .white
            }
            else {
                self.backgroundColor = .green
            }
            self.update()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var rect = bounds
        
        (nameLabel.frame, rect) = rect.divided(atDistance: frame.maxY / 3, from: .minYEdge)
        (highScoreLabel.frame, rect) = rect.divided(atDistance: frame.maxY / 6, from: .minYEdge)
        (lowScorelabel.frame, rect) = rect.divided(atDistance: frame.maxY / 6, from: .minYEdge)
        (averageLabel.frame, rect) = rect.divided(atDistance: frame.maxY / 6, from: .minYEdge)
        (numOfGameLabel.frame, rect) = rect.divided(atDistance: frame.maxY / 6, from: .minYEdge)
    }
    
    func update() {
        nameLabel.text = "\(dataSource!.getProfileInfo().0)"
        nameLabel.textColor = .black
        if let score = dataSource!.getProfileInfo().1, let high = score.high, let low = score.low, let avg = score.avg {
            highScoreLabel.text = "HIGH: \(high)"
            lowScorelabel.text = "LOW: \(low)"
            averageLabel.text = "AVG: \(String(format: "%.2f", avg))"
            numOfGameLabel.text = "PLAYED: \(score.numOfGame)"
        }
        
        else {
            highScoreLabel.text = "HIGH: ---"
            lowScorelabel.text = "LOW: ---"
            averageLabel.text = "AVG: ---"
            numOfGameLabel.text = "PLAYED: 0"
        }
    }
}
