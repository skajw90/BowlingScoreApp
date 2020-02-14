//
//  ProfileController.swift
//  Demo
//
//  Created by Jiwon Nam on 1/23/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

protocol ProfileControllerDataSource {
    func getProfileOverall() -> ScoreOverallFormat?
}

class ProfileController: ProfileViewDataSource {
    // MARK: - Properties
    var dataSource: ProfileControllerDataSource?
    var profileView: ProfileView?
    var name: String?
    
    // MARK: - Initialize
    init(view: ProfileView, name: String) {
        self.profileView = view
        self.name = name
        view.dataSource = self
    }
    
    // MARK: - ProfileViewDataSource Functions
    func getProfileName() -> String {
        return name!
    }
    
    func getProfileScore() -> ScoreOverallFormat? {
        return dataSource!.getProfileOverall()
    }
}
