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
}

class MenuSetController: TopMenuSetViewDelegate, BottomMenuSetViewDelegate, CalendarControllerDataSource {
    var dataSource: MenuSetControllerDataSource?
    var mainView: MainView
    var selectedContents: ContentsType = .profile
    
    init(mainView: MainView) {
        self.mainView = mainView
        self.mainView.topMenuSetView.delegate = self
        self.mainView.bottomMenuSetView.delegate = self
    }
    
    func openProfile() {
        print("action open profile")
        selectedContents = .profile
        mainView.contentsView.switchViews(selectedType: selectedContents)
        let controller = ProfileController(view: mainView.contentsView.curView as! ProfileView, name: dataSource!.getUserID(), overall: dataSource!.getUserOverall())
    }
    
    func openNewGame() {
        print("action open new game")
        selectedContents = .newGame
        mainView.contentsView.switchViews(selectedType: selectedContents)
        // profileView switch to newGameView
    }
    
    func openCalendar() {
        print("action open calendar")
        selectedContents = .calendar
        mainView.contentsView.switchViews(selectedType: selectedContents)
        // previous View switch to calendar view
        let controller = CalendarController(view: mainView.contentsView.curView as! CalendarView, selectedDate: Date())
        controller.dataSource = self
    }
    
    func openCamera() {
        print("action open camera")
        selectedContents = .camera
        mainView.contentsView.switchViews(selectedType: selectedContents)
        // start camera module
    }
    
    func openRecord() {
        print("action open record")
        selectedContents = .record
        mainView.contentsView.switchViews(selectedType: selectedContents)
        // switch record view
    }

    func openGraph() {
        print("action open graph")
        selectedContents = .graph
        mainView.contentsView.switchViews(selectedType: selectedContents)
        // switch graph view
    }

    func openAnalysis() {
        print("action open Analysis")
        selectedContents = .analysis
        mainView.contentsView.switchViews(selectedType: selectedContents)
        // switch analysis view
    }

    func openSetting() {
        print("action open setting")
        selectedContents = .setting
        mainView.contentsView.switchViews(selectedType: selectedContents)
        // switch setting view
    }
    
    // calendar controller datasource
    func getUserData(year: Int, month: Int, day: Int) -> ScoreFormat {
        return ScoreFormat(high: 0, low: 0, avg: 0)
    }
       
    func getUserData(from: Int, to: Int, format: IntervalFormat) -> ScoreFormat {
        return calculateUserScore(from: from, to: to, with: format)
    }
    
    func getProfileOverallScore(from: Int, to: Int, with: IntervalFormat) -> ScoreFormat? {
        return calculateUserScore(from: from, to: to, with: with)
    }
    
    // TODO: get user data
    
    func getUserScore(year: Int, month: Int, day: Int) -> ScoreFormat {
        var high: Float?
        var low: Float?
        var avg: Float?
        
        return ScoreFormat(high: high, low: low, avg: avg)
    }
    
    func calculateUserScore(from: Int, to: Int, with: IntervalFormat) -> ScoreFormat {
        var high: Float?
        var low: Float?
        var avg: Float?
        
        return ScoreFormat(high: high, low: low, avg: avg)
    }
}
