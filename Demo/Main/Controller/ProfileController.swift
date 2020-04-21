//
//  ProfileController.swift
//  Demo
//
//  Created by Jiwon Nam on 1/23/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

protocol ProfileControllerDelegate {
    func openPictureLibrary()
    func openSearchRequestController()
    func openClubViewController(index: Int)
}

protocol ProfileControllerDataSource {
    func getProfileOverall() -> ScoreOverallFormat?
    func getProfileImage() -> UIImage?
    func getNumOfClub() -> Int
    func getClubName(indexAt: Int) -> String
}

class ProfileController: ProfileViewDataSource, ProfileViewDelegate {
    
    // MARK: - Properties
    var dataSource: ProfileControllerDataSource?
    var delegate: ProfileControllerDelegate?
    
    var profileView: ProfileView?
    var name: String?
    
    // MARK: - Initialize
    init(view: ProfileView, name: String) {
        self.profileView = view
        self.name = name
        view.dataSource = self
        view.delegate = self
    }
    
    // MARK: - ProfileViewDataSource Functions
    func getProfileName() -> String {
        return name!
    }
    
    func getProfileScore() -> ScoreOverallFormat? {
        return dataSource!.getProfileOverall()
    }
    
    func openPictureLibrary() {
        delegate!.openPictureLibrary()
    }
    
    func openSearchRequestController() {
        delegate!.openSearchRequestController()
    }
    
    func openClubViewController(index: Int) {
        delegate!.openClubViewController(index: index)
    }
    
    func getProfileImage() -> UIImage? {
        return dataSource!.getProfileImage()
    }
    
    func getNumOfClub() -> Int {
        return dataSource!.getNumOfClub()
    }
    
    func getClubName(indexAt: Int) -> String {
        return dataSource!.getClubName(indexAt: indexAt)
    }
    
}
