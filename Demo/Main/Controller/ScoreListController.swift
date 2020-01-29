//
//  NewGameController.swift
//  Demo
//
//  Created by Jiwon Nam on 1/24/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

protocol ScoreListControllerDelegate {
    func openNewGame(date: CalendarData)
    func openEditGame()
}

protocol ScoreListControllerDataSource {
    func getCurrentDate() -> CalendarData
    func getUserDetailScores() -> [GameScore]
    func getNumOfData(date: CalendarData) -> Int
    func getAverages(date: CalendarData, interval: IntervalFormat) -> ScoreFormat
}

class ScoreListController: ScoreListViewDataSource, ScoreListViewDelegate {
    var delegate: ScoreListControllerDelegate?
    var dataSource: ScoreListControllerDataSource?
    var scoreListView: ScoreListView?
    var currentDate: CalendarData
    
    init (view: ScoreListView, date: CalendarData) {
        self.scoreListView = view
        self.currentDate = date
        scoreListView!.dataSource = self
        scoreListView!.delegate = self
    }
    
    func getCurrentDate() -> CalendarData {
        return currentDate
    }
    
    func getScores() -> [GameScore] {
        return dataSource!.getUserDetailScores()
    }
    
    func setCalendar(index: Int) {
        let numOfDay = CalendarController().getNumOfDays(year: currentDate.year!, month: currentDate.month!)
        if currentDate.day! + index == 0 {
            if currentDate.month! == 1 {
                currentDate.month = 12
                currentDate.year! -= 1
            }
            else {
                currentDate.month! -= 1
            }
            let lastNumOfDay = CalendarController().getNumOfDays(year: currentDate.year!, month: currentDate.month!)
            currentDate.day = lastNumOfDay
        }
        else if currentDate.day! + index > numOfDay {
            currentDate.day = 1
            if currentDate.month! == 12 {
                currentDate.month = 1
                currentDate.year! += 1
            }
            else {
                currentDate.month! += 1
            }
        }
        else {
            currentDate.day! += index
        }
        scoreListView!.updateAll()
    }
    
    func getNumOfData(date: CalendarData) -> Int {
        dataSource!.getNumOfData(date: date)
    }
    
    func addNewGame(date: CalendarData) {
        print("add new game!")
        delegate!.openNewGame(date: date)
    }
    
    func editGame(date: CalendarData, index: Int) {
        print("edit game at \(index)")
        delegate!.openEditGame()
    }
    
    func getAverages(interval: IntervalFormat) -> ScoreFormat {
        dataSource!.getAverages(date: currentDate, interval: interval)
    }
}
