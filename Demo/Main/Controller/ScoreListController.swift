//
//  NewGameController.swift
//  Demo
//
//  Created by Jiwon Nam on 1/24/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

protocol ScoreListControllerDelegate {
    func openNewGame(date: CalendarData, index: Int)
    func setCurrentDate(date: CalendarData)
    func openEditGame(controller: ScoreListController, index: Int)
}

protocol ScoreListControllerDataSource {
    func getCurrentDate() -> CalendarData
    func getUserDetailScores(index: Int) -> GameScore
    func getNumOfData(date: CalendarData) -> Int
    func getAverages(date: CalendarData, interval: IntervalFormat) -> ScoreOverallFormat
}

class ScoreListController: ScoreListViewDataSource, ScoreListViewDelegate {
    
    // MARK: - Properties
    var delegate: ScoreListControllerDelegate?
    var dataSource: ScoreListControllerDataSource?
    var scoreListView: ScoreListView?
    var currentDate: CalendarData
    
    // MARK: - Initialize
    init (view: ScoreListView, date: CalendarData) {
        self.scoreListView = view
        self.currentDate = date
        scoreListView!.dataSource = self
        scoreListView!.delegate = self
    }

    // MARK: - ScoreListviewDataSource Functions
    func getCurrentDate() -> CalendarData { return currentDate }
    func getScores(tag: Int) -> GameScore { return dataSource!.getUserDetailScores(index: tag) }
    func getAverages(interval: IntervalFormat) -> ScoreOverallFormat { dataSource!.getAverages(date: currentDate, interval: interval) }
    func getNumOfData(date: CalendarData) -> Int { dataSource!.getNumOfData(date: date) }
    
    // MARK: - ScoreListViewDelegate Functions
    func setCalendar(index: Int) {
        let numOfDay = CalendarController().getNumOfDays(year: currentDate.year!, month: currentDate.month!)
        if currentDate.day! + index == 0 {
            if currentDate.month! == 1 {
                currentDate.month = 12
                currentDate.year! -= 1
            }
            else { currentDate.month! -= 1 }
            let lastNumOfDay = CalendarController().getNumOfDays(year: currentDate.year!, month: currentDate.month!)
            currentDate.day = lastNumOfDay
        }
        else if currentDate.day! + index > numOfDay {
            currentDate.day = 1
            if currentDate.month! == 12 {
                currentDate.month = 1
                currentDate.year! += 1
            }
            else { currentDate.month! += 1 }
        }
        else { currentDate.day! += index }
        delegate!.setCurrentDate(date: currentDate)
        scoreListView!.updateAll()
    }
    func addNewGame(date: CalendarData, index: Int) { delegate!.openNewGame(date: date, index: index) }
    func editGame(date: CalendarData, index: Int) { delegate!.openEditGame(controller: self, index: index) }
}
