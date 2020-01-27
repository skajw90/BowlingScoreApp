//
//  TopViewController.swift
//  Demo
//
//  Created by Jiwon Nam on 1/21/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

protocol MenuSetControllerDataSource {
    func getUserID() -> String
    func getUserOverall() -> ScoreFormat?
    func getCurrentDate() -> CalendarData
    func getUserScore(date: CalendarData, interval: IntervalFormat?) -> ScoreFormat
    func getUserDetailScores() -> [GameScore]
}

class MenuSetController: TopMenuSetViewDelegate, BottomMenuSetViewDelegate, CalendarControllerDataSource, CalendarControllerDelegate, NewGameControllerDataSource {
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
    
    func openEditNewGame(date: CalendarData?) {
        if selectedContents == .newGame {
            return
        }
        var openDate = getCurrentDate()
        if let date = date {
            openDate = date
        }
        print("action open new game")
        selectedContents = .newGame
        mainView.contentsView.switchViews(selectedType: selectedContents!)
        let controller = NewGameController(view: mainView.contentsView.curView as! NewGameView, date: openDate)
        controller.dataSource = self
        
    }
    
    func openCalendar() {
        if selectedContents == .calendar {
            return
        }
        print("action open calendar")
        selectedContents = .calendar
        mainView.contentsView.switchViews(selectedType: selectedContents!)
        let controller = CalendarController(view: mainView.contentsView.curView as! CalendarView, date: getCurrentDate())
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
    func getUserScore(date: CalendarData) -> ScoreFormat? {
        return dataSource!.getUserScore(date: date, interval: nil)
    }
    
    func getUserData(date: CalendarData, interval: IntervalFormat) -> ScoreFormat {
        return dataSource!.getUserScore(date: date, interval: interval)
    }
    
    func getCurrentDate() -> CalendarData {
        return dataSource!.getCurrentDate()
    }
    
    func getUserDetailScores() -> [GameScore] {
        return dataSource!.getUserDetailScores()
    }
    
    func openEditGame(date: CalendarData) {
        openEditNewGame(date: date)
    }
}
