//
//  ProfileView.swift
//  Demo
//
//  Created by Jiwon Nam on 1/14/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

protocol ProfileViewDelegate {
    func openPictureLibrary()
    func openSearchRequestController()
    func openClubViewController(index: Int)
}

protocol ProfileViewDataSource {
    func getProfileName() -> String
    func getProfileImage() -> UIImage?
    func getProfileScore() -> ScoreOverallFormat?
    func getNumOfClub() -> Int
    func getClubName(indexAt: Int) -> String
}

class ProfileView: UIView, ProfileInfoViewDataSource, ProfileInfoViewDelegate {
    // MARK: - Properties
    var dataSource: ProfileViewDataSource?
    var delegate: ProfileViewDelegate?
    
    var imagePicker = UIImagePickerController()
    // MARK: - UI Properties
    lazy var profilePictureView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .lightGray
        addSubview(view)
        return view
    } ()
    lazy var profileInfoView: ProfileInfoView = {
        let view = ProfileInfoView()
        view.dataSource = self
        view.delegate = self
        addSubview(view)
        return view
    } ()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var rect = bounds
        var picRect = CGRect()
        (_, rect) = rect.divided(atDistance: bounds.maxY / 8, from: .minYEdge)
        (picRect, rect) = rect.divided(atDistance: bounds.maxX / 3, from: .minYEdge)
        picRect = CGRect(origin: picRect.origin, size: CGSize(width: 2 * picRect.width / 3, height: picRect.maxX / 3))
        (profilePictureView.frame, picRect) = picRect.divided(atDistance: picRect.width / 2, from: .maxXEdge)
        (_, rect) = rect.divided(atDistance: bounds.maxY / 16, from: .minYEdge)
        (profileInfoView.frame, rect) = rect.divided(atDistance: 13 * bounds.maxY / 16, from: .minYEdge)
        
    }
    
    // MARK: - UIView Override Functions
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        profilePictureView.backgroundColor = .lightGray
        profilePictureView.layer.borderWidth = 1.0
        profilePictureView.layer.masksToBounds = false
        profilePictureView.layer.cornerRadius = bounds.maxX / 3 / 2
        profilePictureView.clipsToBounds = true
        if let profileImage = dataSource!.getProfileImage() {
            profilePictureView.image = profileImage
        }
    }
    
    // MARK: - ProfileInfoDataSource Functions
    func getProfileInfo() -> (String, ScoreOverallFormat?) {
        let name = dataSource!.getProfileName()
        let score = dataSource!.getProfileScore()
        return (name, score)
    }
    func getNumOfClub() -> Int {
        return dataSource!.getNumOfClub()
    }
    
    func getClubName(indexAt: Int) -> String {
        return dataSource!.getClubName(indexAt: indexAt)
    }
    
    func openSearchRequestController() {
        delegate!.openSearchRequestController()
    }
    func openClubViewController(index: Int) {
        delegate!.openClubViewController(index: index)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let first = touches.first {
            let location = first.location(in: self)
            if profilePictureView.frame.contains(location) {
                delegate!.openPictureLibrary()
            }
        }
    }
}
