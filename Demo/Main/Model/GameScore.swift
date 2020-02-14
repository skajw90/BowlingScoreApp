//
//  GameScore.swift
//  Demo
//
//  Created by Jiwon Nam on 1/24/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import Foundation

enum ScoreStat: String, Codable {
    case strike = "strike"
    case spare = "spare"
    case open = "open"
}

struct FrameScore: Codable {
    var score: Int?
    var bonusCount: Int
    var stat: ScoreStat?
    var bonusStat: [ScoreStat]?
    var isSplit: Bool
    
    enum CodingKeys: String, CodingKey {
        case score = "score"
        case bonusCount = "bonusCount"
        case stat = "stat"
        case isSplit = "isSplit"
    }
}

class GameScore: Codable {
    var input: [Int?]
    var output: [FrameScore]
    var finalScore: Int?
    
    enum Error: Swift.Error {
        case encoding
        case writing
    }
    
    enum CodingKeys: String, CodingKey {
        case input = "input"
        case output = "output"
    }
    
    init() {
        input = Array(repeating: nil, count: 21)
        output = Array(repeating: FrameScore(bonusCount: 0, isSplit: false), count: 10)
    }
    
    func getScoreValue(index: Int) -> Int? {
        return input[index] == 11 ? 10 : (input[index] == 10 ? 0 : input[index])
    }
    
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
                                            if first == 10 {
                                                score += 10 + second
                                            }
                                            else {
                                                if second == 10 {
                                                    score += 10
                                                }
                                                else {
                                                   score += first + second
                                                }
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
                                    // add value to spare frame
                                    total += first
                                    showOutput = true
                                }
                            }
                            else {
                                output[i / 2].bonusCount = 1
                                output[i / 2].stat = .spare
                            }
                            score = 10 - input[i - 1]!
                        }
                        else {
                            showOutput = true
                            output[i / 2].stat = .open
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
                            output[9].stat = .spare
                        }
                        else {
                            total += score
                            output[9].score = total
                            output[9].stat = .open
                            return
                        }
                    }
                    else if i == 19 && input[18] == 11 && score == 10 {
                        output[9].bonusStat = []
                        output[9].bonusStat!.append(.strike)
                        
                    }
                    else if i == 20 && score == 10 {
                        if output[9].stat != .strike {
                            output[9].bonusStat = []
                        }
                        else if output[9].stat == .strike && input[19] != 10 {
                            output[9].bonusStat = [.spare]
                            score = 10 - input[19]!
                        }
                        else {
                            output[9].bonusStat!.append(.strike)
                        }
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
            else {
                return
            }
        }
    }
    
    func getNumOfStat() -> (strike: Int, spare: Int, open: Int, count: Int) {
        var openCount = 0
        var spareCount = 0
        var strikeCount = 0
        var count = 0
        
        for i in 0 ..< output.count {
            if output[i].stat == .spare {
                spareCount += 1
            }
            else if output[i].stat == .open {
                openCount += 1
            }
            else if output[i].stat == .strike {
                strikeCount += 1
            }
            if i == 9, let bonusStat = output[9].bonusStat {
                let num = bonusStat.count
                strikeCount += num
                count += num
            }
            count += 1
        }
        
        return (strike: strikeCount, spare: spareCount, open: openCount, count: count)
    }
    
    func setInput(index: Int, score: Int?) {
        input[index] = score
        if index < 18 && index % 2 == 0 || index == 19 {
            input[index + 1] = nil
        }
        else if index == 18 {
            input[index + 1] = nil
            input[index + 2] = nil
        }
        calculateOutput()
    }
    func getInput() -> [Int?] {
        return input
    }
    func getOutput() -> [FrameScore] {
        return output
    }
    
    func getInput(index: Int) -> Int? {
        return input[index]
    }
    func getOutput(index: Int) -> FrameScore {
        return output[index]
    }
}

extension Array where Element == GameScore {
    func save(to url: URL) throws {
        guard let jsonData = try? JSONEncoder().encode(self) else {
            throw GameScore.Error.encoding
        }
        do {
            try jsonData.write(to: url)
        }
        catch {
            throw GameScore.Error.writing
        }
    }
    
    init(from url: URL) throws {
        let jsonData = try! Data(contentsOf: url)
        self = try JSONDecoder().decode([GameScore].self, from: jsonData)
    }
}
