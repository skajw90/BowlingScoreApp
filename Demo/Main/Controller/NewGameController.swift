//
//  NewGameController.swift
//  Demo
//
//  Created by Jiwon Nam on 1/24/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

protocol NewGameControllerDataSource {
    func getCurrentDate() -> CalendarData
    func getUserDetailScores() -> [GameScore]
}

class NewGameController: NewGameViewDataSource, NewGameViewDelegate {
    
    var dataSource: NewGameControllerDataSource?
    var newGameView: NewGameView?
    var currentDate: CalendarData
    
    init (view: NewGameView, date: CalendarData) {
        self.newGameView = view
        self.currentDate = date
        newGameView!.dataSource = self
        newGameView!.delegate = self
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
        newGameView!.updateAll()
    }
}
