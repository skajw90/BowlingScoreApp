//
//  ProfileNameView.swift
//  Demo
//
//  Created by Jiwon Nam on 1/14/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

protocol ProfileInfoViewDelegate {
    
}

protocol ProfileInfoViewDataSource {
    func getProfileInfo() -> (String, ScoreFormat?)
}

class ProfileInfoView: UIView {
    
    var delegate: ProfileInfoViewDelegate?
    var dataSource: ProfileInfoViewDataSource?
    
    lazy var profileInfo: ProfileInfo = {
        let view = ProfileInfo()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    } ()
    
    lazy var joinedClubView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    } ()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        DispatchQueue.main.async {
            self.update()
        }
    }
    
    func update() {
        profileInfo.nameLabel.text = "\(dataSource!.getProfileInfo().0)"
        profileInfo.nameLabel.textColor = .black
        if let score = dataSource!.getProfileInfo().1 {
            profileInfo.highScoreLabel.text = "HIGH: \(score.high)"
            profileInfo.lowScorelabel.text = "LOW: \(score.low)"
            profileInfo.averageLabel.text = "AVG: \(score.avg)"
        }
        else {
            profileInfo.highScoreLabel.text = "HIGH: ---"
            profileInfo.lowScorelabel.text = "LOW: ---"
            profileInfo.averageLabel.text = "AVG: ---"
        }
        profileInfo.nameLabel.setNeedsDisplay()
    }
    
    func getProfileInfo() -> (String, ScoreFormat?) {
        return dataSource!.getProfileInfo()
    }
}
