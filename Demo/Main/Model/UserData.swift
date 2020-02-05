//
//  UserData.swift
//  Demo
//
//  Created by Jiwon Nam on 1/23/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import Foundation

struct UserData {
    var userID: String?
    var overall: ScoreFormat?
    var dataFiles: [String]? // data file names ex) named by dates
    var joinedClub: String?
}


struct ScoreFormat: Codable {
    var high: Int?
    var low: Int?
    var avg: Int?
    var numOfGame: Int
    
    var scores:[GameScore]?
    
    enum Error: Swift.Error {
        case encoding
        case writing
    }
    
    func save(to url: URL) throws {
        guard let jsonData = try? JSONEncoder().encode(self) else {
            throw ScoreFormat.Error.encoding
        }
        do {
            try jsonData.write(to: url)
        }
        catch {
            throw ScoreFormat.Error.writing
        }
    }
}
