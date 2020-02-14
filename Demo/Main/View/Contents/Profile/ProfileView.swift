//
//  ProfileView.swift
//  Demo
//
//  Created by Jiwon Nam on 1/14/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

protocol ProfileViewDataSource {
    func getProfileName() -> String
    func getProfileScore() -> ScoreOverallFormat?
}

class ProfileView: UIView, ProfileInfoViewDataSource {
    
    var dataSource: ProfileViewDataSource?
    
    lazy var profilePictureView: ProfilePictureView = {
        let view = ProfilePictureView()
        addSubview(view)
        return view
    } ()
    
    lazy var profileInfoView: ProfileInfoView = {
        let view = ProfileInfoView()
        view.dataSource = self
        addSubview(view)
        return view
    } ()
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        profileInfoView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        setImagePosition()
        setInfoPosition()
    }
    
    func setImagePosition() {
        profilePictureView.frame = CGRect(x: bounds.maxX / 20, y: bounds.maxX / 10, width: bounds.maxX / 3, height: bounds.maxX / 3)
        profilePictureView.backgroundColor = .lightGray
        profilePictureView.layer.borderWidth = 1.0
        profilePictureView.layer.masksToBounds = false
        profilePictureView.layer.cornerRadius = bounds.maxX / 3 / 2
        profilePictureView.clipsToBounds = true
    }
    
    func setInfoPosition() {
        profileInfoView.profileInfo.frame = CGRect(x: profilePictureView.bounds.maxX + bounds.maxX / 6, y: 0, width: bounds.maxX - profilePictureView.bounds.maxX - 2 * bounds.maxX / 12, height: bounds.maxX / 3 + bounds.maxX / 5)
        
        profileInfoView.joinedClubView.frame = CGRect(x: 0, y: bounds.maxX / 5 + profilePictureView.bounds.maxY, width: bounds.maxX, height: bounds.maxY - bounds.maxX / 5 - profilePictureView.bounds.maxY)
    }
    
    
    func getProfileInfo() -> (String, ScoreOverallFormat?) {
        let name = dataSource!.getProfileName()
        let score = dataSource!.getProfileScore()
        return (name, score)
    }
}
