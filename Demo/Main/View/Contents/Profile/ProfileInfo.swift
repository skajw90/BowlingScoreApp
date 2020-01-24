//
//  ProfileInfo.swift
//  Demo
//
//  Created by Jiwon Nam on 1/23/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

class ProfileInfo: UIView {
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        return label
    } ()
    
    lazy var highScoreLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        return label
    } ()
    
    lazy var lowScorelabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        return label
    } ()
    
    lazy var averageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        return label
    } ()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var rect = bounds
        
        (nameLabel.frame, rect) = rect.divided(atDistance: frame.maxY / 4, from: .minYEdge)
        (highScoreLabel.frame, rect) = rect.divided(atDistance: frame.maxY / 4, from: .minYEdge)
        (lowScorelabel.frame, rect) = rect.divided(atDistance: frame.maxY / 4, from: .minYEdge)
        (averageLabel.frame, rect) = rect.divided(atDistance: frame.maxY / 4, from: .minYEdge)
    }
}
