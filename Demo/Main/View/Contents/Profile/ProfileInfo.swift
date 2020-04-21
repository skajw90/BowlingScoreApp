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
    // MARK: - Properties
    var dataSource: ProfileInfoDataSource?
    
    // MARK: - UI Properties
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        return label
    } ()
    lazy var highScoreLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        return label
    } ()
    lazy var lowScorelabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        return label
    } ()
    lazy var averageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        return label
    } ()
    lazy var numOfGameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        return label
    } ()
    
    // MARK: - UIView Override Functions
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        update()
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
    
    // MARK: - Update all data method
    func update() {
        nameLabel.text = "\(dataSource!.getProfileInfo().0)"
        nameLabel.makeOutLine(oulineColor: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
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

extension UILabel{
    func makeOutLine(oulineColor: UIColor, foregroundColor: UIColor) {
        let strokeTextAttributes = [
            NSAttributedString.Key.strokeColor : oulineColor,
            NSAttributedString.Key.foregroundColor : foregroundColor,
            NSAttributedString.Key.strokeWidth : -4.0,
            NSAttributedString.Key.font : self.font ?? 10
            ] as [NSAttributedString.Key : Any]
        self.attributedText = NSMutableAttributedString(string: self.text ?? "", attributes: strokeTextAttributes)
    }
}
