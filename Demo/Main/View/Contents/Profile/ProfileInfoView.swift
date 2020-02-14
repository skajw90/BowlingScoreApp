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
    func getProfileInfo() -> (String, ScoreOverallFormat?)
}

class ProfileInfoView: UIView, ProfileInfoDataSource {
    
    var delegate: ProfileInfoViewDelegate?
    var dataSource: ProfileInfoViewDataSource?
    
    lazy var profileInfo: ProfileInfo = {
        let view = ProfileInfo()
        view.dataSource = self
        view.record = false
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
//        DispatchQueue.main.async {
//            //self.update()
//        }
    }
    
    func getProfileInfo() -> (String, ScoreOverallFormat?) {
        return dataSource!.getProfileInfo()
    }
}
