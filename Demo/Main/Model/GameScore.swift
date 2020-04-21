//
//  GameScore.swift
//  Demo
//
//  Created by Jiwon Nam on 1/24/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import Foundation

struct FrameScore: Codable {
    // MARK: - Properties
    var score: Int?
    var bonusCount: Int
    var stat: ScoreStat?
    var firstBonusStat: ScoreStat?
    var secondBonusStat: ScoreStat?
    
    // MARK: - Enum CodingKeys for Decodable
    enum CodingKeys: String, CodingKey {
        case score = "score"
        case bonusCount = "bonusCount"
        case stat = "stat"
        case firstBonusStat = "firstBonusStat"
        case secondBonusStat = "secondBonusStat"
    }
}

class GameScore: Codable {
    // MARK: - Properties
    var gameID: Int
    var input: [Int?]
    var output: [FrameScore]
    var finalScore: Int?
    var leftPins: [[Int]?]
    
    // MARK: - Enum for throwing error type
    enum Error: Swift.Error {
        case encoding
        case writing
    }
    
    // MARK: - Initialize this class
    init(gameID: Int) {
        input = Array(repeating: nil, count: 21)
        output = Array(repeating: FrameScore(bonusCount: 0), count: 10)
        leftPins = Array(repeating: nil, count: 21)
        self.gameID = gameID
    }
    
    // MARK: - Get score at position
    func getScoreValue(index: Int) -> Int? { return input[index] == 11 ? 10 : (input[index] == 10 ? 0 : input[index]) }
    
    // MARK: - Calculate Output based on input
    func calculateOutput() {
        var i = 0
        var total = 0
        var showOutput = false
        while i < 21 {
            if var score = getScoreValue(index: i) {
                if i < 18 {
                    if i % 2 == 0 {
                        if i == 16 {
                            if score == 10 {
                                if output[8].bonusCount != 2 {
                                    output[8].bonusCount = 2
                                    output[i / 2].stat = .strike
                                }
                                else {
                                    if let first = getScoreValue(index: i + 2) {
                                        if let second = getScoreValue(index: i + 3) {
                                            if first == 10 { score += 10 + second }
                                            else {
                                                if second == 10 { score += 10 }
                                                else { score += first + second }
                                            }
                                            showOutput = true
                                        }
                                    }
                                }
                                i += 1
                            }
                        }
                        else if score == 10 {
                            if output[i / 2].bonusCount != 2 {
                                output[i / 2].bonusCount = 2
                                output[i / 2].stat = .strike
                            }
                            else {
                                if let first = input[i + 2] {
                                    if first == 11 {
                                        if input[i + 4] != nil {
                                            showOutput = true
                                            total += 10 + getScoreValue(index: i + 4)!
                                        }
                                    }
                                    else {
                                        if input[i + 3] != nil {
                                            showOutput = true
                                            total += first + (input[i + 3] == 11 ? 10 - input[i + 2]! : (input[i + 3] == 10 ? 0 : input[i + 3]!))
                                        }
                                    }
                                }
                            }
                            i += 1
                        }
                    }
                    else {
                        if score == 10 {
                            if output[i / 2].bonusCount == 1 {
                                if let first = getScoreValue(index: i + 1) {
                                    total += first
                                    showOutput = true
                                }
                            }
                            else {
                                output[i / 2].bonusCount = 1
                                if output[i / 2].stat != nil && (output[i / 2].stat == .split || output[i / 2].stat == .splitMake) {
                                    output[i / 2].stat = .splitMake
                                    print("SPLIT MAKE! at \(i)")
                                }
                                else {
                                    output[i / 2].stat = .spare
                                }
                            }
                            score = 10 - input[i - 1]!
                        }
                        else {
                            showOutput = true
                            if output[i / 2].stat == nil {
                                output[i / 2].stat = .open
                            }
                        }
                    }
                }
                else {
                    if i == 18 && score == 10 {
                        output[i / 2].stat = .strike
                    }
                    else if i == 19 && input[18] != 11 {
                        if score == 10 {
                            score = 10 - input[18]!
                            if output[9].stat != nil && (output[9].stat == .split || output[9].stat == .splitMake) {
                                output[9].stat = .splitMake
                                print("SPLIT MAKE! at \(i)")
                            }
                            else {
                                output[9].stat = .spare
                            }
                        }
                        else {
                            total += score
                            output[9].score = total
                            if output[9].stat == nil {
                                output[9].stat = .open
                            }
                            finalScore = total
                            return
                        }
                    }
                    else if i == 19 && input[18] == 11 && score == 10 {
                        output[9].firstBonusStat = .strike
                    }
                    else if i == 20 && score == 10 {
                        if output[9].stat != .strike {
                            output[9].secondBonusStat = .strike
                        }
                        else if output[9].stat == .strike && output[9].firstBonusStat == nil {
                            score = 10 - input[19]!
                            output[9].secondBonusStat = .spare
                        }
                        else if output[9].stat == .strike && output[9].firstBonusStat == .split {
                            score = 10 - input[19]!
                            output[9].firstBonusStat = .splitMake
                            output[9].secondBonusStat = nil
                        }
                        else {
                            output[9].secondBonusStat = .strike
                        }
                    }
                    else if i == 20 && output[9].secondBonusStat == nil {
                        output[9].secondBonusStat = .open
                    }
                }
                total += score
                if showOutput && i < 18 { output[i / 2].score = total }
                if i == 20 {
                    output[9].score = total
                    finalScore = total
                }
                i += 1
                showOutput = false
            }
            else { return }
        }
    }
    
    // MARK: - Get Number of Status (striek, spare, open, and count of user throw)
    func getNumOfStat() -> (strike: Int, spare: Int, open: Int, split: Int, splitMake: Int, count: Int) {
        var openCount = 0
        var spareCount = 0
        var strikeCount = 0
        var splitCount = 0
        var splitMakeCount = 0
        var count = 0
        var notIncludingCount = 0
        for i in 0 ..< output.count {
            if output[i].stat == .spare { spareCount += 1 }
            else if output[i].stat == .open { openCount += 1 }
            else if output[i].stat == .strike { strikeCount += 1 }
            else if output[i].stat == .split { splitCount += 1}
            else {
                splitCount += 1
                splitMakeCount += 1
            }
            if i == 9 {
                if let firstBonus = output[9].firstBonusStat {
                    if firstBonus == .strike { strikeCount += 1 }
                    else if firstBonus == .spare { spareCount += 1 }
                    else if firstBonus == .open { openCount += 1 }
                    else if firstBonus == .split { splitCount += 1 }
                    else {
                        splitCount += 1
                        splitMakeCount += 1
                    }
                    count += 1
                }
                if let secondBonus = output[9].secondBonusStat {
                    if secondBonus == .strike { strikeCount += 1 }
                    else if secondBonus == .spare { spareCount += 1 }
                    else if secondBonus == .open { openCount += 1 }
                    else if secondBonus == .split {
                        splitCount += 1
                        notIncludingCount += 1
                    }
                    count += 1
                }
            }
            count += 1
        }
        openCount += splitCount - splitMakeCount - notIncludingCount
        spareCount += splitMakeCount
//        splitCount += splitMakeCount
        
        return (strike: strikeCount, spare: spareCount, open: openCount, split: splitCount, splitMake: splitMakeCount, count: count)
    }
    
    // MARK: - Set Input
    func setInput(index: Int, score: Int?, isSplit: Bool) {
        if index < 18 && index % 2 == 0 {
            if !isSplit {
                output[index / 2].stat = nil
            }
            input[index + 1] = nil
        }
        else if index == 18 {
            input[index + 1] = nil
            input[index + 2] = nil
            output[9].firstBonusStat = nil
            output[9].secondBonusStat = nil
        }
        else if index == 19 {
            input[index + 1] = nil
            output[9].secondBonusStat = nil
        }
        input[index] = score
        if index < 19 && index % 2 == 0 && isSplit {
            output[index / 2].stat = .split
            print("SPLIT! at \(index)")
        }
        if index > 18 {
            if index == 19 && input[18] == 11 && isSplit {
                output[9].firstBonusStat = .split
                print("SPLIT! at \(index)")
            }
            else if index == 20 && input[19] == 11 && isSplit {
                output[9].secondBonusStat = .split
                print("SPLIT! at \(index)")
            }
        }
        
        calculateOutput()
    }
    // MARK: - Get All Input
    func getInput() -> [Int?] {
        return input
    }
    // MARK: - get All Output
    func getOutput() -> [FrameScore] {
        return output
    }
    
    // MARK: - get Input at position
    func getInput(index: Int) -> Int? {
        return input[index]
    }
    // MARK: - get Output at Postion
    func getOutput(index: Int) -> FrameScore {
        return output[index]
    }
}

// MARK: - extension of array with element type GameScore to make Encodable and Decodable
extension Array where Element == GameScore {
    func save(to url: URL) throws {
        guard let jsonData = try? JSONEncoder().encode(self) else { throw GameScore.Error.encoding }
        do { try jsonData.write(to: url) }
        catch { throw GameScore.Error.writing }
    }
    init(from url: URL) throws {
        let jsonData = try! Data(contentsOf: url)
        self = try JSONDecoder().decode([GameScore].self, from: jsonData)
    }
}
