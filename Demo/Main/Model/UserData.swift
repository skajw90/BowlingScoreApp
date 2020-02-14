//
//  UserData.swift
//  Demo
//
//  Created by Jiwon Nam on 1/23/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import Foundation

struct UserData {
    var userID: String
    var joinedClub: [String?]
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
    var strikeCount: Int
    var spareCount: Int
    var openCount: Int
    var count: Int
    var frame: [StatFormat]?
}

class ScoreFormats: Codable {
    var infos: [ScoreOverallFormat] = []
    
    enum Error: Swift.Error {
        case encoding
        case writing
    }
    
    func getNumberOfGame() -> Int {
        var count = 0
        
        for info in infos {
            count += info.numOfGame
        }
        return count
    }
    
    func getFirstDateInData() -> CalendarData? {
        var firstDate: CalendarData?
        for info in infos {
            if let first = firstDate {
                if info.date!.compareTo(with: first) < 0 {
                    firstDate = info.date!
                }
            }
            else { firstDate = info.date! }
        }
        return firstDate
    }
    
    func getOverallStats() -> StatFormat {
        let stat = StatFormat()
        
        for info in infos {
            for detail in info.details {
                stat.setStat(num: detail.count, strikeCount: detail.strikeCount, openCount: detail.openCount, spareCount: detail.spareCount, splitCount: 0)
            }
        }
        
        return stat
    }
    
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
    
    func getInfoByPeriod(from: CalendarData, to: CalendarData) -> ScoreFormats {
        let result: ScoreFormats = ScoreFormats()
        for info in infos {
            if info.date!.compareTo(with: from) >= 0 && info.date!.compareTo(with: to) <= 0 {
                result.infos.append(info)
            }
        }
        return result
    }
    
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
    
    func add(newInfo: ScoreOverallFormat) {
        for i in 0 ..< infos.count {
            if infos[i].date!.equalTo(with: newInfo.date!) {
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
                            else {
                                series += infos[i].details[j].score
                            }
                        }
                    }
                    else {
                        infos[i].highSeries = infos[i].details[0].score + infos[i].details[1].score + newInfo.details[0].score
                    }
                }
                infos[i].numOfGame += 1
                infos[i].details.append(newInfo.details[0])
                return
            }
        }
        infos.append(newInfo)
    }
    
    func save(to url: URL) throws {
        guard let jsonData = try? JSONEncoder().encode(self) else {
            throw ScoreFormats.Error.encoding
        }
        do {
            try jsonData.write(to: url)
        }
        catch {
            throw ScoreFormats.Error.writing
        }
    }
}
