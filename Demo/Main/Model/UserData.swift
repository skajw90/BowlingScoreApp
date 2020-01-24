//
//  UserData.swift
//  Demo
//
//  Created by Jiwon Nam on 1/23/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

struct UserData {
    var userID: String?
    var overall: ScoreFormat?
    var dataFiles: [String]? // data file names ex) named by dates
    var joinedClub: String?
}


struct ScoreFormat {
    var high: Float?
    var low: Float?
    var avg: Float?
}
