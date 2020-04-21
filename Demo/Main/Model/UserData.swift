//
//  UserData.swift
//  Demo
//
//  Created by Jiwon Nam on 1/23/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import Foundation

struct UserData: Codable {
    var userID: String
    var joinedClub: [String]
}

struct ScoreOverallFormat: Codable {
    var date: CalendarData?
    var high: Int?
    var low: Int?
    var avg: Float?
    var highSeries: Int?
    var numOfGame: Int
    var details: [Details]
}

struct Details: Codable {
    var score: Int
    //    var stat: StatFormat
    var strikeCount: Int
    var spareCount: Int
    var openCount: Int
    var splitCount: Int
    var splitMakeCount: Int
    var count: Int
    var leftPins: [[Int]?]?
}

class ScoreFormats: Codable {
    // MARK: - Properties
    var infos: [ScoreOverallFormat] = []
    
    // MARK: - Encoding and Decoding Error message
    enum Error: Swift.Error {
        case encoding
        case writing
    }
    
    // MARK: - Get Total Number of Games in this format
    func getNumberOfGame() -> Int {
        var count = 0
        for info in infos { count += info.numOfGame }
        return count
    }
    
    // MARK: - Get oldest input data date
    func getFirstDateInData() -> CalendarData? {
        var firstDate: CalendarData?
        for info in infos {
            if let first = firstDate {
                if info.date!.compareTo(with: first) < 0 { firstDate = info.date! }
            }
            else { firstDate = info.date! }
        }
        return firstDate
    }
    
    // MARK: - Get All Status data (strike, spare, open, and split)
    func getOverallStats() -> StatFormat {
        let stat = StatFormat()
        for info in infos {
            for detail in info.details {
                stat.setStat(num: detail.count, strikeCount: detail.strikeCount, openCount: detail.openCount, spareCount: detail.spareCount, splitCount: detail.splitCount, splitMakeCount: detail.splitMakeCount)
            }
        }
        return stat
    }
    
    // MARK: - Get All record Scores within period
    func getRecordInfoByPeriod(from: CalendarData, to: CalendarData) -> RecordScore {
        var record = RecordScore(numOfGame: 0, numOfLower150: 0, numOfUpper200: 0, numOfUpper250: 0, numOfPerfect: 0)
        let infosFromPeriod = getInfoByPeriod(from: from, to: to)
        for info in infosFromPeriod.infos {
            if let high = info.high, let low = info.low, let avg = info.avg {
                if let recordHigh = record.high, let recordLow = record.low, let recordAvg = record.avg {
                    if Int(recordHigh) < high {
                        record.high = Float(high)
                        record.highDate = info.date
                    }
                    
                    if Int(recordLow) > low {
                        record.low = Float(low)
                        record.lowDate = info.date
                    }
                    record.low = min(recordLow, Float(low))
                    record.avg = (recordAvg * Float(record.numOfGame) + avg * Float(info.numOfGame)) / Float(record.numOfGame + info.numOfGame)
                    record.numOfGame += info.numOfGame
                }
                else {
                    record.high = Float(high)
                    record.highDate = info.date!
                    record.low = Float(low)
                    record.lowDate = info.date!
                    record.avg = avg
                    record.numOfGame = info.numOfGame
                }
                for detail in info.details {
                    record.setCompareNums(num: detail.score)
                }
            }
            if let highSeries = info.highSeries {
                if record.highSeries != nil {
                    if Int(record.highSeries!) < highSeries {
                        record.highSeries = Float(highSeries)
                        record.highSeriesDate = info.date
                    }
                }
                else {
                    record.highSeries = Float(highSeries)
                    record.highSeriesDate = info.date
                }
            }
        }
        return record
    }
    
    // MARK: - Get Score set in period
    func getInfoByPeriod(from: CalendarData, to: CalendarData) -> ScoreFormats {
        let result: ScoreFormats = ScoreFormats()
        for info in infos {
            if info.date!.compareTo(with: from) >= 0 && info.date!.compareTo(with: to) <= 0 { result.infos.append(info) }
        }
        return result
    }
    
    func getAllFrameStatusInfo() -> Details {
        var result = Details(score: 0, strikeCount: 0, spareCount: 0, openCount: 0, splitCount: 0, splitMakeCount: 0, count: 0, leftPins: nil)
        for info in infos {
            for detail in info.details {
                result.strikeCount += detail.strikeCount
                result.spareCount += detail.spareCount
                result.openCount += detail.openCount
                result.splitCount += detail.splitCount
                result.splitMakeCount += detail.splitMakeCount
                result.count += detail.count
            }
        }
        return result
    }
    
    func getFrameStatusInfo(frame: Int) -> Details {
        var result = Details(score: 0, strikeCount: 0, spareCount: 0, openCount: 0, splitCount: 0, splitMakeCount: 0, count: 0, leftPins: nil)
        for info in infos {
            for detail in info.details {
                if let leftPins = detail.leftPins {
                    let index = (frame - 1) * 2
                    if index == 18, let leftAt18 = leftPins[18], let leftAt19 = leftPins[19] {
                        if leftAt18.count == 0 {
                            result.strikeCount += 1
                            result.count += 1
                            if leftAt19.count == 0 {
                                result.strikeCount += 1
                                result.count += 1
                                if leftPins[20]!.count == 0 {
                                    result.strikeCount += 1
                                    result.count += 1
                                }
                            }
                            else {
                                var pinString = ""
                                for temp in leftAt18 {
                                    pinString += "\(temp + 1),"
                                }
                                if SPLITCASES.contains(pinString) {
                                    result.splitCount += 1
                                    if leftAt19 == leftPins[20] {
                                        result.splitMakeCount += 1
                                    }
                                }
                                if leftAt19 == leftPins[20] {
                                    result.spareCount += 1
                                }
                                else {
                                    result.openCount += 1
                                }
                                result.count += 1
                            }
                        }
                        else {
                            var pinString = ""
                            for temp in leftAt18 {
                                pinString += "\(temp + 1),"
                            }
                            if SPLITCASES.contains(pinString) {
                                result.splitCount += 1
                                if leftAt18 == leftAt19 {
                                    result.splitMakeCount += 1
                                }
                            }
                            if leftAt18 == leftAt19 {
                                result.spareCount += 1
                                if leftPins[20]!.count == 0 {
                                    result.strikeCount += 1
                                    result.count += 1
                                }
                            }
                            else { result.openCount += 1 }
                            result.count += 1
                        }
                    }
                    if let first = leftPins[index] {
                        if first.count == 0 {
                            result.strikeCount += 1
                            result.count += 1
                            continue
                        }
                        if let second = leftPins[index + 1] {
                            var pinString = ""
                            for temp in first {
                                pinString += "\(temp + 1),"
                            }
                            if SPLITCASES.contains(pinString) {
                                result.splitCount += 1
                                if first == second {
                                    result.splitMakeCount += 1
                                }
                            }
                            if first == second {
                                result.spareCount += 1
                            }
                            else {
                                result.openCount += 1
                            }
                            result.count += 1
                        }
                    }
                }
            }
        }
        
        return result
    }
    
    func appendPins(to: inout [PinStatInfo], val: [Int], isSpare: Bool) {
        for i in 0 ..< to.count {
            if to[i].PinSet == val {
                to[i].num += 1
                if isSpare {
                    to[i].spareCount += 1
                }
                return
            }
        }
        to.append(PinStatInfo(num: 1, spareCount: isSpare ? 1 : 0, PinSet: val))
    }
    func getPinsInfoBy(frame: Int) -> (pins: [PinStatInfo], num: Int) {
        var results: [PinStatInfo] = []
        var totalNum: Int = 0
        for info in infos {
            for detail in info.details {
                if let leftPins = detail.leftPins {
                    let index = (frame - 1) * 2
                    if index == 18, let leftAt18 = leftPins[18], let leftAt19 = leftPins[19]  {
                        if leftAt18.count == 0 {
                            appendPins(to: &results, val: leftAt18, isSpare: true)
                            totalNum += 1
                            if leftAt19.count == 0 {
                                appendPins(to: &results, val: leftAt19, isSpare: true)
                                totalNum += 1
                                // appendPins(to: &results, val: leftPins[20]!, isSpare: true) // last bonus
                            }
                            else {
                                var isSpare = false
                                if leftAt19 == leftPins[20] { isSpare = true }
                                appendPins(to: &results, val: leftAt19, isSpare: isSpare)
                                totalNum += 1
                            }
                        }
                        else {
                            if leftAt19 == leftAt18 {
                                appendPins(to: &results, val: leftAt18, isSpare: true)
                                totalNum += 1
                                // appendPins(to: &results, val: leftPins[20]!, isSpare: true) // last bonus
                            }
                            else {
                                appendPins(to: &results, val: leftAt18, isSpare: false)
                                totalNum += 1
                            }
                        }
                    }
                    else {
                        if let leftPin = leftPins[index] {
                            var isSpare = false
                            if leftPin == leftPins[index + 1] { isSpare = true }
                            appendPins(to: &results, val: leftPin, isSpare: isSpare)
                            totalNum += 1
                        }
                    }
                }
            }
        }
        return (pins: results, num: totalNum)
    }
    
    // MARK: - Get Overall LeftPins
    func getPinsOverallInfo() -> (pins: [PinStatInfo], num: Int) {
        var results: [PinStatInfo] = []
        var totalNum: Int = 0
        for info in infos {
            for detail in info.details {
                if let leftPins = detail.leftPins {
                    var i = 0
                    while(i < 18) {
                        if let leftPin = leftPins[i] {
                            var isSpare = false
                            if leftPin == leftPins[i + 1] { isSpare = true }
                            appendPins(to: &results, val: leftPin, isSpare: isSpare)
                            totalNum += 1
                        }
                        i += 2
                    }
                    if let leftAt18 = leftPins[18], let leftAt19 = leftPins[19] {
                        if leftAt18.count == 0 {
                            appendPins(to: &results, val: leftAt18, isSpare: true)
                            totalNum += 1
                            if leftAt19.count == 0 {
                                appendPins(to: &results, val: leftAt19, isSpare: true)
                                totalNum += 1
                                //                                appendPins(to: &results, val: leftPins[20]!, isSpare: true) // last bonus
                            }
                            else {
                                var isSpare = false
                                if leftAt19 == leftPins[20] { isSpare = true }
                                appendPins(to: &results, val: leftAt19, isSpare: isSpare)
                                totalNum += 1
                            }
                        }
                        else {
                            if leftAt19 == leftAt18 {
                                appendPins(to: &results, val: leftAt18, isSpare: true)
                                totalNum += 1
                                //                                appendPins(to: &results, val: leftPins[20]!, isSpare: true) // last bonus
                            }
                            else {
                                appendPins(to: &results, val: leftAt18, isSpare: false)
                                totalNum += 1
                            }
                        }
                    }
                }
            }
        }
        
        results.sort(by: {(s1, s2) -> Bool in
            if s1.num > s2.num {
                return true
            }
            else if s1.num == s2.num && s1.spareCount > s2.spareCount {
                return true
            }
            return false
        })
        
        return (pins: results, num: totalNum)
    }
    
    // MARK: - Get Overall Scores
    func getOverallInfo() -> ScoreOverallFormat {
        var overall = ScoreOverallFormat(numOfGame: 0, details: [])
        for info in infos {
            if let high = info.high, let low = info.low, let avg = info.avg {
                if let overallHigh = overall.high, let overallLow = overall.low, let overallAvg = overall.avg {
                    overall.high = max(overallHigh, high)
                    overall.low = min(overallLow, low)
                    overall.avg = (overallAvg * Float(overall.numOfGame) + avg * Float(info.numOfGame)) / Float(overall.numOfGame + info.numOfGame)
                    overall.numOfGame += info.numOfGame
                }
                else {
                    overall.high = high
                    overall.low = low
                    overall.avg = avg
                    overall.numOfGame = info.numOfGame
                }
            }
        }
        return overall
    }
    
    func insert(newInfo: ScoreOverallFormat, prevInfo: ScoreOverallFormat, gameID: Int) {
        for i in 0 ..< infos.count {
            if infos[i].date!.compareTo(with: prevInfo.date!) == 0 {
                var high: Int?, low: Int?, avg: Float?
                infos[i].details[gameID] = newInfo.details[0]
                infos[i].high = nil
                infos[i].low = nil
                infos[i].avg = nil
                infos[i].numOfGame = 0
                var sum: Int = 0
                var count: Int = 0
                for detail in infos[i].details {
                    count += 1
                    if high == nil { high = detail.score }
                    else { high = max(high!, detail.score) }
                    if low == nil { low = detail.score }
                    else { low = min(low!, detail.score) }
                    sum += detail.score
                }
                infos[i].numOfGame = count
                infos[i].high = high
                infos[i].low = low
                infos[i].avg = Float(sum) / Float(count)
            }
        }
    }
    
    // MARK: - Add new score in the set
    func add(newInfo: ScoreOverallFormat) {
        for i in 0 ..< infos.count {
            if infos[i].date!.compareTo(with: newInfo.date!) == 0 {
                infos[i].high! = max(infos[i].high!, newInfo.high!)
                infos[i].low! = min(infos[i].low!, newInfo.low!)
                infos[i].avg! = (infos[i].avg! * Float(infos[i].numOfGame) + newInfo.avg!) / Float(infos[i].numOfGame + 1)
                if infos[i].numOfGame % 3 == 2 {
                    if infos[i].highSeries != nil {
                        var series = 0
                        for j in 0 ..< infos[i].details.count {
                            if j % 2 == 0 {
                                series += infos[i].details[j].score
                                infos[i].highSeries = max(infos[i].highSeries!, series)
                                series = 0
                            }
                            else { series += infos[i].details[j].score }
                        }
                    }
                    else { infos[i].highSeries = infos[i].details[0].score + infos[i].details[1].score + newInfo.details[0].score}
                }
                infos[i].numOfGame += 1
                infos[i].details.append(newInfo.details[0])
                return
            }
        }
        infos.append(newInfo)
    }
    
    // MARK: - Encode Method
    func save(to url: URL) throws {
        guard let jsonData = try? JSONEncoder().encode(self) else { throw ScoreFormats.Error.encoding }
        do { try jsonData.write(to: url) }
        catch { throw ScoreFormats.Error.writing }
    }
}
