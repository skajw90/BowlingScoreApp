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
    func openCamera()
    func openPictureLibrary()
    func openSearchRequestController()
    func openClubViewController(index: Int)
}

protocol MenuSetControllerDataSource {
    func getUserID() -> String
    func getUserOverall() -> ScoreOverallFormat?
    func getCurrentDate() -> CalendarData
    func getUserScore(date: CalendarData, interval: IntervalFormat) -> ScoreOverallFormat
    func getUserDetailScores(index: Int) -> GameScore
    func getNumUserScoreData() -> Int
    func hasContentsInMonth(date: CalendarData) -> [Bool]
    func getRecordScoreDatas() -> [(date: CalendarData?, num: Float?)?]
    func getUserOverallAnalysis() -> StatFormat
    func getRecordInfo() -> (from: CalendarData, to: CalendarData, num: Int)
    func getScoreFormats(period: CategoryPeriod) -> (periods: [(from: CalendarData, to: CalendarData)], scores: [ScoreFormats])
    func getToday() -> CalendarData
    func getAnalysisOverallData(period: CategoryPeriod, frame: Int) -> Details
//    func getAnalysisPinsSize(period: CategoryPeriod, frame: Int) -> Int
    func getAnalysisPinSets(period: CategoryPeriod, frame: Int) -> (pins: [PinStatInfo], num: Int)
    func getProfileImage() -> UIImage?
    func getNumOfClub() -> Int
    func getClubName(indexAt: Int) -> String
}

class MenuSetController: TopMenuSetViewDelegate, BottomMenuSetViewDelegate, CalendarControllerDataSource, CalendarControllerDelegate, ScoreListControllerDataSource, ScoreListControllerDelegate, NewGameControllerDelegate, RecordControllerDataSource, ProfileControllerDataSource, ProfileControllerDelegate, GraphControllerDataSource, AnalysisControllerDataSource {
    
    // MARK: - Properties
    var delegate: MenuSetControllerDelegate?
    var dataSource: MenuSetControllerDataSource?
    var mainView: MainView
    var selectedContents: ContentsType?
    
    // MARK: - Initialize
    init(mainView: MainView) {
        self.mainView = mainView
        self.mainView.topMenuSetView.delegate = self
        self.mainView.bottomMenuSetView.delegate = self
    }
    
    // MARK: - Open contents view functions
    func openProfile() {
        if selectedContents == .profile { return }
        selectedContents = .profile
        mainView.contentsView.switchViews(selectedType: selectedContents!)
        let controller = ProfileController(view: mainView.contentsView.curView as! ProfileView, name: dataSource!.getUserID())
        controller.dataSource = self
        controller.delegate = self
    }
    func openScoreListView(date: CalendarData?) {
        if selectedContents == .scorelist { return }
        var openDate = getCurrentDate()
        if let date = date { openDate = date }
        else {
            let year = Calendar.current.component(.year, from: Date())
            let month = Calendar.current.component(.month, from: Date())
            let day = Calendar.current.component(.day, from: Date())
            let weekday = Calendar.current.component(.weekday, from: Date())
            openDate = CalendarData(year: year, month: month, day: day, weekday: WeekDay(rawValue: weekday))
        }
        delegate!.setCurrentDate(date: openDate)
        selectedContents = .scorelist
        mainView.contentsView.switchViews(selectedType: selectedContents!)
        let controller = ScoreListController(view: mainView.contentsView.curView as! ScoreListView, date: openDate)
        controller.dataSource = self
        controller.delegate = self
    }
    func openCalendar() {
        if selectedContents == .calendar { return }
        let year = Calendar.current.component(.year, from: Date())
        let month = Calendar.current.component(.month, from: Date())
        let day = Calendar.current.component(.day, from: Date())
        let weekday = Calendar.current.component(.weekday, from: Date())
        let openDate = CalendarData(year: year, month: month, day: day, weekday: WeekDay(rawValue: weekday))
        selectedContents = .calendar
        delegate!.setCurrentDate(date: openDate)
        delegate!.loadUserScore(date: openDate)
        mainView.contentsView.switchViews(selectedType: selectedContents!)
        let controller = CalendarController(view: mainView.contentsView.curView as! CalendarView)
        controller.dataSource = self
        controller.delegate = self
    }
    func openCamera() {
        if selectedContents == .camera { return }
        selectedContents = .camera
        mainView.contentsView.switchViews(selectedType: selectedContents!)
        delegate!.openCamera()
    }
    func openRecord() {
        if selectedContents == .record { return }
        selectedContents = .record
        mainView.contentsView.switchViews(selectedType: selectedContents!)
        let controller = RecordController(view: mainView.contentsView.curView as! RecordView, name: dataSource!.getUserID())
        controller.dataSource = self
    }
    func openGraph() {
        if selectedContents == .graph { return }
        selectedContents = .graph
        mainView.contentsView.switchViews(selectedType: selectedContents!)
        let controller = GrpahController(view: mainView.contentsView.curView as! GraphView)
        controller.dataSource = self
    }
    func openAnalysis() {
        if selectedContents == .analysis { return }
        print("action open Analysis")
        selectedContents = .analysis
        mainView.contentsView.switchViews(selectedType: selectedContents!)
        let controller = AnalysisController(view: mainView.contentsView.curView as! AnalysisView)
        controller.dataSource = self
        // switch analysis view
    }
    func openSetting() {
        if selectedContents == .setting { return }
        print("action open setting")
        selectedContents = .setting
        mainView.contentsView.switchViews(selectedType: selectedContents!)
        // switch setting view
    }
    
    // MARK: - ProfileControllerDataSource Function
    func getProfileOverall() -> ScoreOverallFormat? { dataSource!.getUserOverall() }
    func getProfileImage() -> UIImage? { dataSource!.getProfileImage() }
    func getNumOfClub() -> Int {
        return dataSource!.getNumOfClub()
    }
    
    func getClubName(indexAt: Int) -> String {
        return dataSource!.getClubName(indexAt: indexAt)
    }
    // MARK: - ProfileControllerDelegate Function
    func openPictureLibrary() { delegate!.openPictureLibrary() }
    func openSearchRequestController() { delegate!.openSearchRequestController() }
    func openClubViewController(index: Int) {delegate!.openClubViewController(index: index) }
    // MARK: - CalendarControllerDataSource Functions
    func hasContentsInMonth(date: CalendarData) -> [Bool] { return dataSource!.hasContentsInMonth(date: date) }
    // MARK: CalendarControllerDelegate Functions
    func openEditGame(date: CalendarData) { openScoreListView(date: date) }
    func setMonthlyScores(date: CalendarData) { delegate!.loadUserScore(date: date) }
    
    // MARK: - CalendarController and ScoreListController shared DataSource
    func getCurrentDate() -> CalendarData { return dataSource!.getCurrentDate() }
    func getAverages(date: CalendarData, interval: IntervalFormat) -> ScoreOverallFormat { return dataSource!.getUserScore(date: date, interval: interval) }
    
    // MARK: - ScoreListControllerDataSource Functions
    func getUserDetailScores(index: Int) -> GameScore { return dataSource!.getUserDetailScores(index: index) }
    func getNumOfData(date: CalendarData) -> Int { return dataSource!.getNumUserScoreData() }
    // MARK: - ScoreListControllerDelegate Functions
    func openNewGame(date: CalendarData, index: Int) {
        if selectedContents == .newGame { return }
        delegate!.setCurrentDate(date: date)
        selectedContents = .newGame
        mainView.contentsView.switchViews(selectedType: .newGame)
        let controller = NewGameController(view: mainView.contentsView.curView as! NewGameView, date: date, gameID: index)
        controller.delegate = self
    }
    func setCurrentDate(date: CalendarData) { delegate!.setCurrentDate(date: date) }
    func openEditGame(controller: ScoreListController, index: Int) {
        let test = getUserDetailScores(index: dataSource!.getNumUserScoreData() - index + 1)
        delegate!.setCurrentDate(date: getCurrentDate())
        selectedContents = .newGame
        mainView.contentsView.switchViews(selectedType: .newGame)
        let controller = NewGameController(view: mainView.contentsView.curView as! NewGameView, date: getCurrentDate(), gameID: index)
        controller.gameScore = test
        controller.curFrame = 21
        controller.selectedFrame = 0
        controller.delegate = self
    }
    
    // MARK: - NewGameControllerDelegate Functions
    func saveScores(score: GameScore, date: CalendarData) { delegate!.saveUserInfo(score: score, date: date) }
    
    // MARK: - RecordControllerDataSource Functions
    func getRecordInfo() -> (from: CalendarData, to: CalendarData, num: Int) { return dataSource!.getRecordInfo() }
    func getRecordScoreDatas() -> [(date: CalendarData?, num: Float?)?] { dataSource!.getRecordScoreDatas() }
    func getUserOverallAnalysis() -> StatFormat { return dataSource!.getUserOverallAnalysis() }
    
    // MARK: - GraphControleerDataSource Functions
    func getScoreFormats(period: CategoryPeriod) -> (periods: [(from: CalendarData, to: CalendarData)], scores: [ScoreFormats]) { return dataSource!.getScoreFormats(period: period) }
    func getToday() -> CalendarData { return dataSource!.getToday()}
    
    // MARK: - AnalysisControllerDataSource Functions
    func getAnalysisOverallData(period: CategoryPeriod, frame: Int) -> Details {
        return dataSource!.getAnalysisOverallData(period: period, frame: frame)
    }
    
//    func getAnalysisPinsSize(period: CategoryPeriod, frame: Int) -> Int {
//        return dataSource!.getAnalysisPinsSize(period: period, frame: frame)
//    }
    
    func getAnalysisPinSets(period: CategoryPeriod, frame: Int) -> (pins: [PinStatInfo], num: Int) {
        return dataSource!.getAnalysisPinSets(period: period, frame: frame)
    }
}
