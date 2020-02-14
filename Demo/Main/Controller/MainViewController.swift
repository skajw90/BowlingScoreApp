//
//  ViewController.swift
//  ProjectDemo
//
//  Created by Jiwon Nam on 1/4/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, MenuSetControllerDataSource, MenuSetControllerDelegate, MenuPreviewDelegate, CameraControllerDelegate {
    
    // MARK: - Properties
    var menuSetController: MenuSetController?
    var userData: UserData = UserData(userID: "TEST", joinedClub: [])
    var userSetting = (0, 0 , IntervalFormat.year)
    var selectedDate: CalendarData = CalendarData()
    var overallScores: ScoreFormats = ScoreFormats()
    var selectedDetailScore: [GameScore] = []
    var contentsInMonth: [Bool] = []
    var today = CalendarData()
    var mainView: MainView { return view as! MainView }
    
    // MARK: - Initialize
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        today.year = Calendar.current.component(.year, from: Date())
        today.month = Calendar.current.component(.month, from: Date())
        today.day = Calendar.current.component(.day, from: Date())
        today.weekday = WeekDay(rawValue: Calendar.current.component(.weekday, from: Date()))
        selectedDate.year = Calendar.current.component(.year, from: Date())
        selectedDate.month = Calendar.current.component(.month, from: Date())
        selectedDate.day = Calendar.current.component(.day, from: Date())
        selectedDate.weekday = WeekDay(rawValue: Calendar.current.component(.weekday, from: Date()))
        loadUserScore(date: selectedDate)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Load Data Methods
    func loadDailyScoreDetail(url: URL) {
        if FileManager.default.fileExists(atPath: url.path) {
            do {
                let jsonData = try Data(contentsOf: url)
                let data = try! JSONDecoder().decode([GameScore].self, from: jsonData)
                selectedDetailScore = data
            } catch { print("error") }
        }
    }
    func loadOverallScores(url: URL) {
        if FileManager.default.fileExists(atPath: url.path) {
            do {
                let jsonData = try Data(contentsOf: url)
                let data = try! JSONDecoder().decode(ScoreFormats.self, from: jsonData)
                overallScores = data
            } catch { print("error") }
        }
        else { overallScores = ScoreFormats() }
    }
    func getContentsInMonth(year: Int, month: Int) {
        let url = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        contentsInMonth = []
        var contentsDays: [Int] = []
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
            for i in 0 ..< contents.count {
                let filename = String(contents[i].lastPathComponent)
                var monthString = "\(month)"
                if month < 10 {
                    monthString = "0\(month)"
                }
                let param = "\(year)\(monthString)"
                if filename.starts(with: param) {
                    let start = filename.index(filename.startIndex, offsetBy: 6)
                    let end = filename.index(filename.endIndex, offsetBy: -5)
                    let range = start ..< end
                    let result = filename[range]
                    let day = Int(result)
                    contentsDays.append(day!)
                }
            }
        } catch { print("error no files") }
        for i in 0 ..< 32 {
            if contentsDays.contains(i) { contentsInMonth.append(true) }
            else { contentsInMonth.append(false) }
        }
    }

    // MARK: - Save Data Methods
    func saveDailyScoreDetail(score: GameScore, url: URL) {
        selectedDetailScore.append(score)
        do {
            try selectedDetailScore.save(to: url)
        } catch { print("error save daily scores") }
        selectedDetailScore = []
    }
    func saveOverallScores(score: GameScore, url: URL) {
        let scoreStat = score.getNumOfStat()
        let dayInfo = ScoreOverallFormat(date: selectedDate, high: score.finalScore!, low: score.finalScore!, avg: Float(score.finalScore!), numOfGame: 1, details: [Details(score: score.finalScore!, strikeCount: scoreStat.strike, spareCount: scoreStat.spare, openCount: scoreStat.open, count: score.getNumOfStat().count)])
        overallScores.add(newInfo: dayInfo)
        do {
            try overallScores.save(to: url)
        } catch { print("error save daily scores") }
    }
    
    override func loadView() { view = MainView() }
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.frame = view.frame
        NSLayoutConstraint.activate([
            mainView.menuPreview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainView.menuPreview.leftAnchor.constraint(equalTo: view.leftAnchor),
            mainView.menuPreview.rightAnchor.constraint(equalTo: view.rightAnchor),
            mainView.menuPreview.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.08),
            
            mainView.topMenuSetView.topAnchor.constraint(equalTo: mainView.menuPreview.bottomAnchor),
            mainView.topMenuSetView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mainView.topMenuSetView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mainView.topMenuSetView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.08),
            
            mainView.contentsView.topAnchor.constraint(equalTo: mainView.topMenuSetView.bottomAnchor),
            mainView.contentsView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mainView.contentsView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mainView.contentsView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.76),
            
            mainView.bottomMenuSetView.topAnchor.constraint(equalTo: mainView.contentsView.bottomAnchor),
            mainView.bottomMenuSetView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mainView.bottomMenuSetView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mainView.bottomMenuSetView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        menuSetController = MenuSetController(mainView: mainView)
        mainView.menuPreview.delegate = self
        menuSetController!.dataSource = self
        menuSetController!.delegate = self
        menuSetController!.openProfile()
    }
    
    // MARK: - MenuSetControllerDataSource Functions
    func getUserID() -> String { return userData.userID }
    func getUserOverall() -> ScoreOverallFormat? {
        let from = CalendarData(year: today.year! - 1, month: 1, day: 1, weekday: nil)
        let overallData = overallScores.getInfoByPeriod(from: from, to: today)
        return overallData.getOverallInfo()
    }
    func getCurrentDate() -> CalendarData { return selectedDate }
    func getUserScore(date: CalendarData, interval: IntervalFormat) -> ScoreOverallFormat {
        var from: CalendarData?
        var to: CalendarData = today
        if interval == .month { from = CalendarData(year: date.year!, month: date.month!, day: 1) }
        else if interval == .day {
            from = CalendarData(year: date.year!, month: date.month!, day: date.day!)
            to = CalendarData(year: date.year!, month: date.month!, day: date.day!)
        }
        else { from = CalendarData(year: date.year!, month: 1, day: 1) }
        let overallData = overallScores.getInfoByPeriod(from: from!, to: to)
        return overallData.getOverallInfo()
    }
    func getUserDetailScores(index: Int) -> GameScore { return selectedDetailScore[index - 1] }
    func getNumUserScoreData() -> Int { return selectedDetailScore.count }
    func hasContentsInMonth(date: CalendarData) -> [Bool] { return contentsInMonth }
    func getRecordScoreDatas() -> [(date: CalendarData?, num: Float?)?] {
        let from = CalendarData(year: today.year! - 1, month: 1, day: 1, weekday: nil)
        return overallScores.getRecordInfoByPeriod(from: from, to: today).toArray()
    }
    func getUserOverallAnalysis() -> StatFormat {
        let from = CalendarData(year: today.year! - 1, month: 1, day: 1, weekday: nil)
        let overallData = overallScores.getInfoByPeriod(from: from, to: today)
        return overallData.getOverallStats()
    }
    func getRecordInfo() -> (from: CalendarData, to: CalendarData, num: Int) {
        let from = CalendarData(year: today.year! - 1, month: 1, day: 1, weekday: nil)
        let overallData = overallScores.getInfoByPeriod(from: from, to: today)
        var firstDate = overallData.getFirstDateInData()
        if firstDate == nil { firstDate = today }
        return (from: firstDate!, to: today, num: overallData.getNumberOfGame())
    }
    // MARK: - MenuSetControllerDelegate Functions
    func saveUserInfo(score: GameScore, date: CalendarData) {
        var month = "\(date.month!)"
        if date.month! < 10 { month = "0\(date.month!)" }
        var day = "\(date.day!)"
        if date.day! < 10 { day = "0\(date.day!)" }
        let fileName = "\(date.year!)\(month)\(day).json"
        let documentsDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let overallUrl = documentsDirectory.appendingPathComponent("overall.json")
        let url = documentsDirectory.appendingPathComponent(fileName)
        print(documentsDirectory)
        saveDailyScoreDetail(score: score, url: url)
        saveOverallScores(score: score, url: overallUrl)
        menuSetController!.openScoreListView(date: date)
    }
    func setCurrentDate(date: CalendarData) {
        selectedDate = date
        loadUserScore(date: selectedDate)
    }
    func loadUserScore(date: CalendarData) {
        selectedDetailScore = []
        var month = "\(date.month!)"
        if date.month! < 10 { month = "0\(date.month!)" }
        var day = "\(date.day!)"
        if date.day! < 10 { day = "0\(date.day!)" }
        let fileName = "\(date.year!)\(month)\(day).json"
        let documentsDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let url = documentsDirectory.appendingPathComponent(fileName)
        let overallUrl = documentsDirectory.appendingPathComponent("overall.json")
        loadDailyScoreDetail(url: url)
        loadOverallScores(url: overallUrl)
        getContentsInMonth(year: date.year!, month: date.month!)
    }
    func openCamera() {
        let controller = VisionViewController()
        controller.delegate = self
        add(controller)
    }
    
    // MARK: - CameraControllerDelegate
    func cancelCamera(controller: CameraController) {
        controller.remove()
        menuSetController!.openProfile()
    }
    func saveData(data: [String]) { }
    
    // MARK: - MenuPreviewDelegate Functions
    func openMenu() {
    }
    
    
    
    

    
    
    
    
    
    
    
    
    
}

