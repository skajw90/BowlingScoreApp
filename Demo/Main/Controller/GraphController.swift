//
//  GraphController.swift
//  Demo
//
//  Created by Jiwon Nam on 2/14/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

protocol GraphControllerDataSource {
    func getScoreFormats(period: CategoryPeriod) -> (periods: [(from: CalendarData, to: CalendarData)], scores: [ScoreFormats])
    func getToday() -> CalendarData
}

class GrpahController: GraphViewDataSource, GraphViewDelegate {
    
    // MARK: - Properties
    var dataSource: GraphControllerDataSource?
    var graphView: GraphView
    var graphViewScores: (periods: [(from: CalendarData, to: CalendarData)], scores: [ScoreFormats])
    
    // MARK: - UI Properties
    init(view: GraphView) {
        graphView = view
        graphViewScores = (periods: [], scores: [])
        graphView.dataSource = self
        graphView.delegate = self
    }
    
    // MRAK:- GraphViewDataSource Functions
    func getNumOfData() -> Int { return graphViewScores.scores.count }
    func getDataAtSC(index: Int) -> (date: (from: CalendarData, to: CalendarData), score: ScoreOverallFormat) {
        return (date: graphViewScores.periods[index], score: graphViewScores.scores[index].getOverallInfo())
    }
    func getDataAtST(index: Int) -> (date: (from: CalendarData, to: CalendarData), stat: StatFormat, numOfGame: Int) {
        return(date: graphViewScores.periods[index], stat: graphViewScores.scores[index].getOverallStats(), numOfGame: graphViewScores.scores[index].getOverallInfo().numOfGame)
        
    }
    
    func getXValuesForGraph(period: CategoryPeriod, type: Category) -> [(from: CalendarData, to: CalendarData, data: Any?)] {
        let today = dataSource!.getToday()
        var firstDate = (from: today, to: today)
        var result: [(from: CalendarData, to: CalendarData, data: Any?)] = []
        for temp in graphViewScores.periods {
            if firstDate.from.compareTo(with: temp.from) >= 0 {
                firstDate = temp
            }
        }
        var count = 0
        while firstDate.from.compareTo(with: today) <= 0 {
            let prev = firstDate
            if period == .month1 {
                firstDate = (from: prev.from.add(month: 1), to: prev.to.add(month: 1))
            }
            else if period == .month3 {
                firstDate = (from: prev.from.add(month: 3), to: prev.to.add(month: 3))
            }
            else if period == .month6 {
                firstDate = (from: prev.from.add(month: 6), to: prev.to.add(month: 6))
            }
            else {
                firstDate = (from: prev.from.add(year: 1), to: prev.to.add(year: 1))
            }
            if graphViewScores.periods.contains(dates: prev) {
                result.append((from: prev.from, to: prev.to, data: type == .score ? graphViewScores.scores[count].getOverallInfo() : graphViewScores.scores[count].getOverallStats()))
                count += 1
            }
            else {
                result.append((from: prev.from, to: prev.to, data: nil))
            }
        }
        return result
    }
    
    // MARK: - GraphViewDelegate Functions
    func setCategory(period: CategoryPeriod, type: Category) {
        graphViewScores = dataSource!.getScoreFormats(period: period) }
 
    
}


extension Array where Element == (from: CalendarData, to: CalendarData) {
    func contains(dates: (from: CalendarData, to: CalendarData)) -> Bool {
        for temp in self {
            if temp.from.compareTo(with: dates.from) == 0 && temp.to.compareTo(with: dates.to) == 0 {
                return true
            }
        }
        return false
    }
}
