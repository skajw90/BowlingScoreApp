//
//  TopViewController.swift
//  Demo
//
//  Created by Jiwon Nam on 1/21/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

protocol MenuSetControllerDelegate {
    func saveUserInfo(score: GameScore, date: CalendarData)
    func setCurrentDate(date: CalendarData)
    func loadUserScore(date: CalendarData)
}

protocol MenuSetControllerDataSource {
    func getUserID() -> String
    func getUserOverall() -> ScoreFormat?
    func getCurrentDate() -> CalendarData
    func getUserScore(date: CalendarData, interval: IntervalFormat) -> ScoreFormat
    func getUserDetailScores(index: Int) -> GameScore
    func getNumUserScoreData() -> Int
    func hasContentsInMonth(date: CalendarData) -> [Bool]
}

class MenuSetController: TopMenuSetViewDelegate, BottomMenuSetViewDelegate, CalendarControllerDataSource, CalendarControllerDelegate, ScoreListControllerDataSource, ScoreListControllerDelegate, NewGameControllerDelegate {
    
    var delegate: MenuSetControllerDelegate?
    var dataSource: MenuSetControllerDataSource?
    var mainView: MainView
    var selectedContents: ContentsType?
    
    init(mainView: MainView) {
        self.mainView = mainView
        self.mainView.topMenuSetView.delegate = self
        self.mainView.bottomMenuSetView.delegate = self
    }
    
    func openProfile() {
        if selectedContents == .profile {
            return
        }
        print("action open profile")
        selectedContents = .profile
        mainView.contentsView.switchViews(selectedType: selectedContents!)
        let controller = ProfileController(view: mainView.contentsView.curView as! ProfileView, name: dataSource!.getUserID(), overall: dataSource!.getUserOverall())
    }
    
    func openScoreListView(date: CalendarData?) {
        if selectedContents == .scorelist {
            return
        }
        var openDate = getCurrentDate()
        if let date = date {
            openDate = date
            delegate!.setCurrentDate(date: date)
        }
        else {
            let year = Calendar.current.component(.year, from: Date())
            let month = Calendar.current.component(.month, from: Date())
            let day = Calendar.current.component(.day, from: Date())
            let weekday = Calendar.current.component(.weekday, from: Date())
            openDate = CalendarData(year: year, month: month, day: day, weekday: WeekDay(rawValue: weekday))
            delegate!.setCurrentDate(date: openDate)
        }
        
        print("action open new game")
        selectedContents = .scorelist
        mainView.contentsView.switchViews(selectedType: selectedContents!)
        let controller = ScoreListController(view: mainView.contentsView.curView as! ScoreListView, date: openDate)
        controller.dataSource = self
        controller.delegate = self
        
    }
    
    func openCalendar() {
        if selectedContents == .calendar {
            return
        }
        let year = Calendar.current.component(.year, from: Date())
        let month = Calendar.current.component(.month, from: Date())
        let day = Calendar.current.component(.day, from: Date())
        let weekday = Calendar.current.component(.weekday, from: Date())
        let openDate = CalendarData(year: year, month: month, day: day, weekday: WeekDay(rawValue: weekday))
        delegate!.setCurrentDate(date: openDate)
        delegate!.loadUserScore(date: openDate)
        print("action open calendar")
        selectedContents = .calendar
        mainView.contentsView.switchViews(selectedType: selectedContents!)
        let controller = CalendarController(view: mainView.contentsView.curView as! CalendarView)
        controller.dataSource = self
        controller.delegate = self
    }
    
    func openCamera() {
        if selectedContents == .camera {
            return
        }
        print("action open camera")
        selectedContents = .camera
        mainView.contentsView.switchViews(selectedType: selectedContents!)
        // start camera module
    }
    
    func openRecord() {
        if selectedContents == .record {
            return
        }
        print("action open record")
        selectedContents = .record
        mainView.contentsView.switchViews(selectedType: selectedContents!)
        // switch record view
    }

    func openGraph() {
        if selectedContents == .graph {
            return
        }
        print("action open graph")
        selectedContents = .graph
        mainView.contentsView.switchViews(selectedType: selectedContents!)
        // switch graph view
    }

    func openAnalysis() {
        if selectedContents == .analysis {
            return
        }
        print("action open Analysis")
        selectedContents = .analysis
        mainView.contentsView.switchViews(selectedType: selectedContents!)
        // switch analysis view
    }

    func openSetting() {
        if selectedContents == .setting {
            return
        }
        print("action open setting")
        selectedContents = .setting
        mainView.contentsView.switchViews(selectedType: selectedContents!)
        // switch setting view
    }
    
    func getProfileOverall() -> ScoreFormat? {
        dataSource!.getUserOverall()
    }
    
    // TODO: get user data
//    func getUserScore(date: CalendarData) -> ScoreFormat? {
//        return dataSource!.getUserScore(date: date, interval: .day)
//    }
    
    func getAverages(date: CalendarData, interval: IntervalFormat) -> ScoreFormat {
        return dataSource!.getUserScore(date: date, interval: interval)
    }
    
    func getCurrentDate() -> CalendarData {
        return dataSource!.getCurrentDate()
    }
    
    func getUserDetailScores(index: Int) -> GameScore {
        return dataSource!.getUserDetailScores(index: index)
    }
    
    func openEditGame(date: CalendarData) {
        openScoreListView(date: date)
    }
    
    func getNumOfData(date: CalendarData) -> Int {
        return dataSource!.getNumUserScoreData()
    }
    
    func saveScores(score: GameScore, date: CalendarData) {
        delegate!.saveUserInfo(score: score, date: date)
    }
    
    func setCurrentDate(date: CalendarData) {
        delegate!.setCurrentDate(date: date)
    }
    
    func hasContentsInMonth(date: CalendarData) -> [Bool] {
        return dataSource!.hasContentsInMonth(date: date)
    }
    
    func setMonthlyScores(date: CalendarData) {
        delegate!.loadUserScore(date: date)
    }
    
    
    func openNewGame(date: CalendarData) {
        if selectedContents == .newGame {
            return
        }
        delegate!.setCurrentDate(date: date)
        selectedContents = .newGame
        mainView.contentsView.switchViews(selectedType: .newGame)
        // add controller
        let controller = NewGameController(view: mainView.contentsView.curView as! NewGameView, date: date)
        controller.delegate = self
    }
    
    func openEditGame() {
        
    }
}
