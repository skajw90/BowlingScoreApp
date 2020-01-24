//
//  ProfileController.swift
//  Demo
//
//  Created by Jiwon Nam on 1/23/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

class ProfileController: ProfileViewDataSource {
    
    var profileView: ProfileView?
    var name: String?
    var overall: ScoreFormat?
    
    init(view: ProfileView, name: String, overall: ScoreFormat?) {
        self.profileView = view
        self.name = name
        self.overall = overall
        view.dataSource = self
    }
    
    func getProfileName() -> String {
        return name!
    }
    
    func getProfileScore() -> ScoreFormat? {
        return overall
    }
}
